:-module(pit_position,[pit_pos/4]).

:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).

pit_pos(c{x:X,y:Y}, north, HunterBeliefs, Final_New_Eat_pit):-
    pit_yp1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1),
    pit_xm1(c{x:X,y:Y},HunterBeliefs,New1,New2),
    pit_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit).

pit_pos(c{x:X,y:Y}, south, HunterBeliefs,  Final_New_Eat_pit):-
    pit_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1),
    pit_xm1(c{x:X,y:Y},HunterBeliefs,New1,New2),
    pit_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit).


pit_pos(c{x:X,y:Y}, east, HunterBeliefs,  Final_New_Eat_pit):-
    pit_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1),
    pit_yp1(c{x:X,y:Y},HunterBeliefs,New1,New2),
    pit_xp1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit).

pit_pos(c{x:X,y:Y}, west, HunterBeliefs, Final_New_Eat_pit):-
    pit_ym1(c{x:X,y:Y},HunterBeliefs,HunterBeliefs.uncertain_eternals.eat_pit,New1),
    pit_yp1(c{x:X,y:Y},HunterBeliefs,New1,New2),
    pit_xm1(c{x:X,y:Y}, HunterBeliefs,New2, Final_New_Eat_pit).


pit_yp1(c{x:X,y:Y}, HunterBeliefs, Eat_pit, New_Eat_pit_north) :-
    Y1 #= Y + 1,
    (\+ member(_{c:_{x:X,y:Y1},w:_{}},HunterBeliefs.certain_fluents.eat_walls),
    \+ member(_{c:_{x:X,y:Y1},w:_{}},HunterBeliefs.certain_fluents.visited),
    \+ member(_{c:_{x:X,y:Y1},w:_{}},HunterBeliefs.uncertain_eternals.eat_pit),
    ->append(Eat_pit,_{x:X,y:Y1},New_Eat_pit_north)
    ;   New_Eat_pit_north = Eat_pit.
    )

pit_ym1(c{x:X,y:Y}, HunterBeliefs, Eat_pit, New_Eat_pit_south) :-
    Y1 #= Y - 1,
    (\+ member(_{c:_{x:X,y:Y1},w:_{}},HunterBeliefs.certain_fluents.eat_walls),
    \+ member(_{c:_{x:X,y:Y1},w:_{}},HunterBeliefs.certain_fluents.visited),
    \+ member(_{c:_{x:X,y:Y1},w:_{}},HunterBeliefs.uncertain_eternals.eat_pit),
    ->append(Eat_pit,_{c:_{x:X,y:Y1},w:_{}},New_Eat_pit_south)
    ;   New_Eat_pit_south = Eat_pit.
    )



pit_xm1(c{x:X,y:Y},HunterBeliefs, Eat_pit, New_Eat_pit_west) :-
    X2 #= X - 1,
    (\+ member(_{c:_{x:X2,y:Y},w:_{}},HunterBeliefs.certain_fluents.eat_walls),
    \+ member(_{c:_{x:X2,y:Y},w:_{}},HunterBeliefs.certain_fluents.visited),
    \+ member(_{c:_{x:X2,y:Y},w:_{}},HunterBeliefs.uncertain_eternals.eat_pit),
    ->append(Eat_pit,_{x:X2,y:Y},New_Eat_pit_west)
    ;   New_Eat_pit_west = Eat_pit.
    )

pit_xp1(c{x:X,y:Y}, HunterBeliefs, Eat_pit, New_Eat_pit_east) :-
    X3 #= X + 1,
    (\+ member(_{c:_{x:X3,y:Y},w:_{}},HunterBeliefs.certain_fluents.eat_walls),
    \+ member(_{c:_{x:X3,y:Y},w:_{}},HunterBeliefs.certain_fluents.visited),
    \+ member(_{c:_{x:X3,y:Y},w:_{}},HunterBeliefs.uncertain_eternals.eat_pit),
    ->append(Eat_pit,_{x:X3,y:Y},New_Eat_pit_east)
    ;   New_Eat_pit_east = Eat_pit.
    )
