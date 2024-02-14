:-module(mylogic,[calculer_action_croyances/4]).

:- use_module(library(clpfd)).
calculer_action_croyances(HunterBeliefs, _, NewBeliefs, Action) :-
    NewBeliefs = HunterBeliefs,
    Action = move.