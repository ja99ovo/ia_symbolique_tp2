:-module(mylogic,[go/4]).
:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).

go(Position, Dir, Dest):-
    