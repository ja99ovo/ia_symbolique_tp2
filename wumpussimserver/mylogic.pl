:-module(mylogic,[calculer_action_croyances/4]).

:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).
calculer_action_croyances(HunterBeliefs, Percepts, NewBeliefs, grab) :-
    NewBeliefs=HunterBeliefs,
    member(glitter,Percepts).



calculer_action_croyances(HunterBeliefs, _, NewBeliefs, Action) :-
    NewBeliefs=HunterBeliefs,
    Action=move.