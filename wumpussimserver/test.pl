:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).
:- use_module(library(reif)).


test_if([L]) :-
    if_(member(1,L),
        then(writeln("yes")),
        else(writeln("no"))).



        //append(HunterBeliefs.certain_fluents.fat_hunter.c,[],Visited),
        //NewBeliefs.certain_fluents.fat_hunter.visited=Visited,
        next_pos(HunterBeliefs.certain_fluents.fat_hunter.c,north,NewBeliefs.certain_fluents.fat_hunter.c),