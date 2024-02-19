:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).
:- use_module(library(reif)).


test_if([L]) :-
    if_(member(1,L),
        then(writeln("yes")),
        else(writeln("no"))).