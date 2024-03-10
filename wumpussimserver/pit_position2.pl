:-module(pit_position2,[pit_pos/7]).

:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).


%pour déterminer les positions de pits. 
%quand il se sent breeze mais il ne se sent pas stench en même temps, vérifier que si les quatres cases
%se trouvent dans la liste eat_wumpus. Si il existe une case qui est dans eat_wumpus,
%l'ajouter dans fat_gold car dans cette case il n'y a pas de wumpus
%n'a pas cosidéré la condition que pit et wumpus se trouvent dans une même case.

%examiner les trois cases à côté et combiner les résultats ensemble
pit_pos(c{x:X,y:Y}, north, HunterBeliefs, Final_New_Eat_pit, Safe,Final_New_Safe,Percepts):-
    pit_yp1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1,Safe,New_Safe1,Percepts),
    pit_xm1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    pit_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit,New_Safe2,Final_New_Safe,Percepts).

pit_pos(c{x:X,y:Y}, south, HunterBeliefs,  Final_New_Eat_pit, Safe,Final_New_Safe,Percepts):-
    pit_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1,Safe,New_Safe1,Percepts),
    pit_xm1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    pit_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit,New_Safe2,Final_New_Safe,Percepts).


pit_pos(c{x:X,y:Y}, east, HunterBeliefs,  Final_New_Eat_pit, Safe,Final_New_Safe,Percepts):-
    pit_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1,Safe,New_Safe1,Percepts),
    pit_yp1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    pit_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit,New_Safe2,Final_New_Safe,Percepts).

pit_pos(c{x:X,y:Y}, west, HunterBeliefs, Final_New_Eat_pit, Safe,Final_New_Safe,Percepts):-
    pit_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1,Safe,New_Safe1,Percepts),
    pit_yp1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    pit_xm1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit,New_Safe2,Final_New_Safe,Percepts).

%Y+1
pit_yp1(c{x:X,y:Y}, HunterBeliefs, Eat_pit, New_Eat_pit_north,Safe,New_Safe,Percepts) :-
    Y1 #= Y + 1,
    (  member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_wumpus),
    \+member(stench,Percepts)
    ->append(Safe,[_{x:X,y:Y1}],New_Safe),
    New_Eat_pit_north = Eat_pit
    ;\+ member(_{c:_{x:X,y:Y1},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X,y:Y1},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_pit)
    ->append(Eat_pit,[_{x:X,y:Y1}],New_Eat_pit_north),
        New_Safe=Safe
    ;   New_Eat_pit_north = Eat_pit,
        New_Safe=Safe
    ).

%Y-1
pit_ym1(c{x:X,y:Y}, HunterBeliefs, Eat_pit, New_Eat_pit_south,Safe,New_Safe,Percepts) :-
    Y1 #= Y - 1,
    (member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_wumpus),
\+member(stench,Percepts)
    ->append(Safe,[_{x:X,y:Y1}],New_Safe),
    New_Eat_pit_south = Eat_pit
    ;\+ member(_{c:_{x:X,y:Y1},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X,y:Y1},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_pit)
    ->append(Eat_pit,[_{x:X,y:Y1}],New_Eat_pit_south),
    New_Safe=Safe
    ;   New_Eat_pit_south = Eat_pit,
        New_Safe=Safe
    ).


%X-1
pit_xm1(c{x:X,y:Y},HunterBeliefs, Eat_pit, New_Eat_pit_west,Safe,New_Safe,Percepts) :-
    X2 #= X - 1,
    (member(_{x:X2,y:Y},HunterBeliefs.uncertain_eternals.eat_wumpus),
\+member(stench,Percepts)
    ->append(Safe,[_{x:X2,y:Y}],New_Safe),
    New_Eat_pit_west = Eat_pit
    ;\+ member(_{c:_{x:X2,y:Y},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{c:_{from:X2,y:Y},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X2,y:Y},HunterBeliefs.uncertain_eternals.eat_pit)
    ->append(Eat_pit,[_{x:X2,y:Y}],New_Eat_pit_west),
    New_Safe=Safe
    ;   New_Eat_pit_west = Eat_pit,
        New_Safe=Safe
    ).

%X+1
pit_xp1(c{x:X,y:Y}, HunterBeliefs, Eat_pit, New_Eat_pit_east,Safe,New_Safe,Percepts) :-
    X3 #= X + 1,
    (member(_{x:X3,y:Y},HunterBeliefs.uncertain_eternals.eat_wumpus),
\+member(stench,Percepts)
    ->append(Safe,[_{x:X3,y:Y}],New_Safe),
    New_Eat_pit_east = Eat_pit
    ;\+ member(_{c:_{x:X3,y:Y},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X3,y:Y},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X3,y:Y},HunterBeliefs.uncertain_eternals.eat_pit)
    ->append(Eat_pit,[_{x:X3,y:Y}],New_Eat_pit_east),
    New_Safe=Safe
    ;   New_Eat_pit_east = Eat_pit,
        New_Safe=Safe
    ).
