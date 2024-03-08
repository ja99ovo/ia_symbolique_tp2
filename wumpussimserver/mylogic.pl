:-module(mylogic,[calculer_action_croyances/4]).

:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).

:- use_module(wumpus_position).
:- use_module(pit_position2).
%:- use_module(go).


next_pos(c{x:X,y:Y}, north, _{x:X,y:Y1}) :- Y1 #= Y + 1.
next_pos(c{x:X,y:Y}, south, _{x:X,y:Y1}) :- Y1 #= Y - 1.
next_pos(c{x:X,y:Y}, east, _{x:X1,y:Y}) :- X1 #= X + 1.
next_pos(c{x:X,y:Y}, west, _{x:X1,y:Y}) :- X1 #= X - 1.

turn_right(north,NewDir):- NewDir#=east.
turn_right(east,NewDir):- NewDir#=south.
turn_right(south,NewDir):- NewDir#=west.
turn_right(west,NewDir):- NewDir#=north.



get_dir(HunterBeliefs,Dir):-
    HunterBeliefs.certain_fluents.dir = [_{d:Dir, h:_}|_].
get_visited(HunterBeliefs,Visited):-
    VisitedList = HunterBeliefs.certain_fluents.visited,
    (VisitedList = [] -> Visited = []; Visited = VisitedList).

safe_positions(_{x:X,y:Y}, HunterBeliefs, Safe) :-
    findall(
        _{x:XAdj, y:YAdj},
        (
            % 计算上下左右坐标
            (XAdj #= X+1, YAdj = Y;  % 右
             XAdj #= X-1, YAdj = Y;  % 左
             XAdj = X, YAdj is Y+1;  % 上
             XAdj = X, YAdj is Y-1), % 下
            % 检查坐标是否不在walls列表中
            \+ member(_{c:_{x:XAdj, y:YAdj},w:_}, HunterBeliefs.certain_eternals.eat_walls),
            \+ member(_{x:XAdj, y:YAdj}, HunterBeliefs.certain_fluents.fat_gold),
            \+ member(_{from:_{x:XAdj, y:YAdj},to:_},HunterBeliefs.certain_fluents.visited)
        ),
        Safe
    ).


calculer_action_croyances(_, Percepts, _, grab) :-
    member(glitter,Percepts).


calculer_action_croyances(HunterBeliefs, Percepts, NewBeliefs, Action) :-
    get_dir(HunterBeliefs,Dir),
    Safe=HunterBeliefs.certain_fluents.fat_gold,

    ( member(stench,Percepts), \+member(breeze, Percepts)
    ->wumpus_pos(HunterBeliefs.certain_fluents.fat_hunter.c, Dir, HunterBeliefs, Final_New_Eat_Wumpus, Safe,Final_New_Safe),
    New_certain_fluents=_{}.put(dir,Dir).put(fat_gold,Final_New_Safe).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    New_uncertain_eternals=_{}.put(eat_pit,HunterBeliefs.uncertain_eternals.eat_pit).put(eat_wumpus,Final_New_Eat_Wumpus),
    NewBeliefs=_{}.put(certain_eternals,New_certain_fluents).put(certain_fluents,HunterBeliefs.certain_fluents).put(uncertain_eternals,New_uncertain_eternals),
    Action=none

    ;member(breeze, Percepts), \+member(stench,Percepts)
    ->  pit_pos(HunterBeliefs.certain_fluents.fat_hunter.c, Dir, HunterBeliefs, Final_New_Eat_Pits, Safe,Final_New_Safe),
    New_certain_fluents=_{}.put(dir,Dir).put(fat_gold,Final_New_Safe).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    New_uncertain_eternals=_{}.put(eat_wumpus,HunterBeliefs.uncertain_eternals.eat_wumpus).put(eat_pit,Final_New_Eat_Pits),
    NewBeliefs=_{}.put(certain_eternals,New_certain_fluents).put(certain_fluents,HunterBeliefs.certain_fluents).put(uncertain_eternals,New_uncertain_eternals),
    Action=none

    ;member(breeze, Percepts), member(stench,Percepts)
    ->  Action=none

    ;\+member(breeze, Percepts), \+member(stench,Percepts)
    ->  safe_positions(HunterBeliefs.certain_fluents.fat_hunter.c,HunterBeliefs,Final_New_Safe),
    Newdir=[_{d:Dir,h:_{}}],
    New_certain_fluents=_{}.put(dir,Newdir).put(fat_gold,Final_New_Safe).put(fat_hunter,HunterBeliefs.certain_fluents.fat_hunter).put(visited,HunterBeliefs.certain_fluents.visited),
    NewBeliefs1=_{}.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,New_certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals),
    effect_move(NewBeliefs1,NewBeliefs),
    Action=move
    ).





effect_move(HunterBeliefs, NewBeliefs):-
    get_dir(HunterBeliefs,Dir),
    get_visited(HunterBeliefs,Visited),

    Newdir=[_{d:Dir,h:_{}}],
    next_pos(HunterBeliefs.certain_fluents.fat_hunter.c,Dir,New_Position),

    Final_Position=_{}.put(c,New_Position).put(h,_{}),
    New_Visited=_{}.put(from,HunterBeliefs.certain_fluents.fat_hunter.c).put(to,New_Position),
    append(Visited,[New_Visited],Final_Visited),

    put_dict(certain_eternals, _{}, HunterBeliefs.certain_eternals, NewBeliefs1),
    Certain_fluents=_{}.put(dir,Newdir).put(fat_hunter,Final_Position).put(visited,Final_Visited).put(fat_gold,HunterBeliefs.certain_fluents.fat_gold),
	NewBeliefs=NewBeliefs1.put(certain_eternals,HunterBeliefs.certain_eternals).put(certain_fluents,Certain_fluents).put(uncertain_eternals,HunterBeliefs.uncertain_eternals).

