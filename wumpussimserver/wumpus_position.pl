:-module(wumpus_position,[wumpus_pos/7]).

:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).

wumpus_pos(c{x:X,y:Y}, north, HunterBeliefs,  Final_New_Eat_Wumpus, Safe,Final_New_Safe,Percepts):-
    wumpus_yp1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_wumpus,New1,Safe,New_Safe1,Percepts),
    wumpus_xm1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    wumpus_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_Wumpus,New_Safe2,Final_New_Safe,Percepts).

wumpus_pos(c{x:X,y:Y}, south, HunterBeliefs,  Final_New_Eat_Wumpus, Safe,Final_New_Safe,Percepts):-
    wumpus_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_wumpus,New1,Safe,New_Safe1,Percepts),
    wumpus_xm1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    wumpus_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_Wumpus,New_Safe2,Final_New_Safe,Percepts).


wumpus_pos(c{x:X,y:Y}, east, HunterBeliefs,  Final_New_Eat_Wumpus, Safe,Final_New_Safe,Percepts):-
    wumpus_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_wumpus,New1,Safe,New_Safe1,Percepts),
    wumpus_yp1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    wumpus_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_Wumpus,New_Safe2,Final_New_Safe,Percepts).

wumpus_pos(c{x:X,y:Y}, west, HunterBeliefs, Final_New_Eat_Wumpus, Safe,Final_New_Safe,Percepts):-
    wumpus_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_wumpus,New1,Safe,New_Safe1,Percepts),
    wumpus_yp1(c{x:X,y:Y},HunterBeliefs,New1,New2,New_Safe1,New_Safe2,Percepts),
    wumpus_xm1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_Wumpus,New_Safe2,Final_New_Safe,Percepts).


wumpus_yp1(c{x:X,y:Y}, HunterBeliefs, Eat_Wumpus, New_Eat_Wumpus_north,Safe,New_Safe,Percepts) :-
    Y1 #= Y + 1,
    (member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_pit),
    \+member(breeze,Percepts)
    ->append(Safe,[_{x:X,y:Y1}],New_Safe),
    New_Eat_Wumpus_north = Eat_Wumpus
    ;\+ member(_{c:_{x:X,y:Y1},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X,y:Y1},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_wumpus)
    ->append(Eat_Wumpus,[_{x:X,y:Y1}],New_Eat_Wumpus_north),
    New_Safe=Safe
    ;   New_Eat_Wumpus_north = Eat_Wumpus,
    New_Safe=Safe
    ).

wumpus_ym1(c{x:X,y:Y}, HunterBeliefs, Eat_Wumpus, New_Eat_Wumpus_south,Safe,New_Safe,Percepts) :-
    Y1 #= Y - 1,
    (
    member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_pit),
    \+member(breeze,Percepts)
    ->append(Safe,[_{x:X,y:Y1}],New_Safe),
    New_Eat_Wumpus_south = Eat_Wumpus
    ;\+ member(_{c:_{x:X,y:Y1},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X,y:Y1},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X,y:Y1},HunterBeliefs.uncertain_eternals.eat_wumpus)
    ->append(Eat_Wumpus,[_{x:X,y:Y1}],New_Eat_Wumpus_south),
    New_Safe=Safe
    ;   New_Eat_Wumpus_south = Eat_Wumpus,
    New_Safe=Safe
    ).



wumpus_xm1(c{x:X,y:Y},HunterBeliefs, Eat_Wumpus, New_Eat_Wumpus_west,Safe,New_Safe,Percepts) :-
    X2 #= X - 1,
    (    member(_{x:X2,y:Y},HunterBeliefs.uncertain_eternals.eat_pit),
\+member(breeze,Percepts)
    ->append(Safe,[_{x:X2,y:Y}],New_Safe),
    New_Eat_Wumpus_west = Eat_Wumpus
    ;\+ member(_{c:_{x:X2,y:Y},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X2,y:Y},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X2,y:Y},HunterBeliefs.uncertain_eternals.eat_wumpus)
    ->append(Eat_Wumpus,[_{x:X2,y:Y}],New_Eat_Wumpus_west),
    New_Safe=Safe
    ;   New_Eat_Wumpus_west = Eat_Wumpus,
    New_Safe=Safe
    ).

wumpus_xp1(c{x:X,y:Y}, HunterBeliefs, Eat_Wumpus, New_Eat_Wumpus_east,Safe,New_Safe,Percepts) :-
    X3 #= X + 1,
    (member(_{x:X3,y:Y},HunterBeliefs.uncertain_eternals.eat_pit),
\+member(breeze,Percepts)
    ->append(Safe,[_{x:X3,y:Y}],New_Safe),
    New_Eat_Wumpus_east = Eat_Wumpus
    ;\+ member(_{c:_{x:X3,y:Y},w:_},HunterBeliefs.certain_eternals.eat_walls),
    \+ member(_{from:_{x:X3,y:Y},to:_},HunterBeliefs.certain_fluents.visited),
    \+ member(_{x:X3,y:Y},HunterBeliefs.uncertain_eternals.eat_wumpus)
    ->append(Eat_Wumpus,[_{x:X3,y:Y}],New_Eat_Wumpus_east),
    New_Safe=Safe
    ;   New_Eat_Wumpus_east = Eat_Wumpus,
    New_Safe=Safe
    ).
