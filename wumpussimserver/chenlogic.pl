:- use_module(library(main)).
:- use_module(library(settings)).

:- use_module(library(http/http_server)).
%% Comment the following line if using windows
%:- use_module(library(http/http_unix_daemon)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_log)).
:- use_module(library(http/http_cors)).
:- debug.
:- set_setting(http:logfile, 'httpd.log').
:- set_setting(http:cors, [*]).


:- cors_enable.
%
% :- use_module(/*ICI IRA VOTRE MODULE QUI DEFISSANT VOS PREDICATS*/).
%% Comment the following line if using windows
%:- initialization(run, main).


run :- 
   http_log_stream(_),
   debug(http(_)),
   ( current_prolog_flag(windows, true) ->
       http_server(http_dispatch, [port(8081)])
       ;
       http_daemon([fork(false), interactive(false), port(8081)])
   ).


:- http_handler(root(action), handle_action_request, []).
%This section remains unchanged
handle_action_request(Request) :-
   option(method(options), Request), !,
   cors_enable(Request, [methods([put])]),
   format('Content-type: text/plain\r\n'),
   format('~n').
%This part defines the interaction with the server 
handle_action_request(Request) :-
   %Recover JSON from raw data
   http_read_json_dict(Request, RequestJSON, [value_string_as(atom)]),
   %Unify variables with JSON content
   _{
       beliefs: HunterBeliefs, 
       percepts: Percepts
   } :< RequestJSON,
   %These 2 lines print your received JSON nicely
   http_log_stream(Stream),
   print_term(_{beliefs: HunterBeliefs, percepts: Percepts }, [output(Stream),nl(true)]),
   %% HERE you put the call to the predicate which will calculate the action and the new
   %% beliefs
   calculate_action_beliefs(HunterBeliefs, Percepts, NewBeliefs, Action),
   %This line must be the penultimate one
   cors_enable,
   %% this line sends the json of the response to the server
   reply_json_dict(_{
       hunterState: _{
           beliefs:NewBeliefs, percepts: Percepts
       }, 
       action: Action
   }).

update_visited(CF, NCF) :-
    _{
        alive: A,
        dir: D,
        fat_gold: FG,
        fat_hunter: FH,
        game_state: GS,
        has_arrow: HA,
        has_gold: HG,
        score: S,
        visited: V
    } :< CF,
    NCF = _{
        alive: A,
        dir: D,
        fat_gold: FG,
        fat_hunter: FH,
        game_state: GS,
        has_arrow: HA,
        has_gold: HG,
        score: S,
        visited: [CF.fat_hunter|V]
    }.

    

calculate_action_beliefs(B, [stench|Rest], BB, Action) :-
    _{ certain_eternals: CE,
       certain_fluents: CF,
      uncertain_eternals: UCE,
      uncertain_fluents: UCF
      } :< B,
    around(B, Positions),
    append(Positions, UCE.eat_wumpus, New_eat_wumpus),
    New_uncertain_eternals = _{eat_pit: UCE.eat_pit, eat_wumpus: New_eat_wumpus},
    NB = _{ certain_eternals: CE,
            certain_fluents: CF,
            uncertain_eternals: New_uncertain_eternals,
            uncertain_fluents: UCF
          },
    calculate_action_beliefs(NB, Rest, BB, Action).

calculate_action_beliefs(B, [glitter|Rest], BB, Action) :-
    % _{ certain_eternals: CE,
    %    certain_fluents: CF,
    %   uncertain_eternals: UCE,
    %   uncertain_fluents: UCF
    %   } :< B,
    calculate_action_beliefs(B, Rest, BB, Action).


calculate_action_beliefs(B, [breeze|Rest], B, Action) :-
    _{ certain_eternals: CE,
       certain_fluents: CF,
      uncertain_eternals: UCE,
      uncertain_fluents: UCF
      } :< B,
    around(B, Positions),
    append(Positions, UCE.eat_pit, New_eat_pit),
    New_uncertain_eternals = _{eat_pit: New_eat_pit, eat_wumpus: UCE.eat_wumpus},
    NB = _{ certain_eternals: CE,
            certain_fluents: CF,
            uncertain_eternals: New_uncertain_eternals,
            uncertain_fluents: UCF
          },
    calculate_action_beliefs(NB, Rest, BB, Action).

calculate_action_beliefs(B, [], NB, Action) :-
    update_visited(B.certain_fluents, NCF),
    NB = _{certain_eternals: B.certain_eternals, certain_fluents: NCF, uncertain_eternals: B.uncertain_eternals, uncertain_fluents: B.uncertain_fluents},
    calculate_action(NB, Action).
    
calculate_action(NB, Action) :-
    Cells = NB.certain_eternals.cells,
    member(C, Cells),
    Pos = _{c: C, w:_},
    \+ member(Pos, NB.certain_eternals.eat_walls),
    \+ member(Pos, NB.uncertain_eternals.eat_pit),
    \+ member(Pos, NB.uncertain_eternals.eat_wumpus),
    \+ member(_{c:C,h:_}, NB.certain_fluents.visited),
    term_string(C.x, X),
    term_string(C.y, Y),
    string_concat(X, "-", XX),
    string_concat(XX, Y, XY),
    Action = XY.





around(B, Ps) :-
    Cells = B.certain_eternals.cells,
    Current_Pos = B.certain_fluents.fat_hunter.c,
    X = Current_Pos.x,
    Y = Current_Pos.y,
    A1 is X + 1,
    A2 is X - 1,
    A3 is Y + 1,
    A4 is Y - 1,
    Around_Pos = [
        _{x: A1, y: Current_Pos.y},
        _{x: A2, y: Current_Pos.y},
        _{x: Current_Pos.x, y: A3},
        _{x: Current_Pos.x, y: A4}
    ],
    is_member(Around_Pos, Cells, Around_Pos_valid),
    is_not_member(Around_Pos_valid, B.certain_eternals.eat_walls, Ps).

is_member([], C, []).
is_member([X|XS], C, [X|V]) :-
    member(X, C),
    is_member(XS, C, V).
is_member([X|XS], C, V) :-
    \+ member(X, C),
    is_member(XS, C, V).

is_not_member([], C, []).
is_not_member([X|XS], C, [X|V]) :-
    \+ member(X, C),
    is_member(XS, C, V).
is_not_member([X|XS], C, V) :-
    member(X, C),
    is_member(XS, C, V).





    
