import { defineStore, acceptHMRUpdate } from 'pinia';
import {
  WorldState,
  Percept,
  Fluents,
  GameState,
  HunterState,
  ActionResponse,
  Action,
} from 'src/components/models';

interface WumpusState {
  worldState: WorldState;
  percepts: Percept[];
  previousFluents: Fluents | undefined;
  hunterState: HunterState;
  action: Action;
}

export const useWumpusStore = defineStore('wumpus', {
  state: (): WumpusState => ({
    worldState: new WorldState(),
    previousFluents: undefined,
    percepts: [],
    hunterState: new HunterState(),
    action: Action.None,
  }),
  getters: {
    gridSize: (state) => {
      if (state.worldState.eternals) {
        console.log(state.worldState.eternals.cells.length);
        return Math.sqrt(state.worldState.eternals.cells.length);
      } else {
        return 0;
      }
    },
    isGameOver: (state) => {
      return state.worldState.fluents?.game_state === GameState.Finished;
    },
    score: (state) => {
      return state.worldState.fluents ? state.worldState.fluents.score : 0;
    },
  },
  actions: {
    async initGame() {
      fetch('http://localhost:8080/default', {
        method: 'PUT',
      })
        .then((response) => response.json())
        .then((json) => {
          this.worldState = new WorldState(json);
          this.percepts = [];
          console.log(json);
          this.hunterState = new HunterState(this.worldState, this.percepts);
        });
    },
    async initGameWithSize(size: number) {
      fetch('http://localhost:8080/init', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ size }),
      })
        .then((response) => response.json())
        .then((json) => {
          this.worldState = new WorldState(json.state);
          this.percepts = json.percepts;
          console.log(json);
          this.hunterState = new HunterState(this.worldState, this.percepts);
        });
    },
    async resetGame() {
      fetch('http://localhost:8080/init', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ size: 1 }),
      })
        .then((response) => response.json())
        .then((json) => {
          this.worldState = new WorldState(json.state);
          this.percepts = json.percepts;
          console.log(json);
          this.hunterState = new HunterState(this.worldState, this.percepts);
        });
    },
    async performSimAction(action: string) {
      fetch('http://localhost:8080/sim', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...this.worldState,
          previous_fluents: this.previousFluents
            ? this.previousFluents
            : this.worldState.fluents,
          plan: action,
        }),
      })
        .then((response) => response.json())
        .then((json) => {
          this.previousFluents = this.worldState.fluents;
          this.worldState.fluents = json.fluents;
          this.percepts = json.percepts;
        });
    },/*
    async getHunterAction() {
      this.hunterState.percepts=this.percepts;
      fetch('http://localhost:8081/action', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ ...this.hunterState }),
      })
        .then((response) => response.json())
        .then((json: ActionResponse) => {
          this.hunterState = json.hunterState;
          this.action = json.action;
        });
    }*/
    async getHunterAction() {
      this.hunterState.percepts = this.percepts;
      try {
        const response = await fetch('http://localhost:8081/action', {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ ...this.hunterState }),
        });
        const json = await response.json();
        this.hunterState = json.hunterState;
        this.action = json.action;
        // 确保返回一个对象，其中包含需要的信息
        return { hunterState: this.hunterState, action: this.action };
      } catch (error) {
        console.error('获取Hunter Action时发生错误:', error);
        // 根据你的错误处理策略，你可以在这里抛出错误或返回一个错误标记
        throw error; // 或者 return { error };
      }
    }
    ,
  },
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useWumpusStore, import.meta.hot));
}
