:- use_module(library(main)).
:- use_module(library(settings)).

:- use_module(library(http/http_server)).
%% Commentez la ligne suivante si vous utilisez windows
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
:- use_module(mylogic).
%% Commentez la ligne suivante si vous utilisez windows
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
%Cette partie reste inchangée
handle_action_request(Request) :-
   option(method(options), Request), !,
   cors_enable(Request, [methods([put])]),
   format('Content-type: text/plain\r\n'),
   format('~n').
%Cette partie définit l'interaction avec le serveur 
handle_action_request(Request) :-
   %recuperer le JSON à partir des données brutes
   http_read_json_dict(Request, RequestJSON, [value_string_as(atom)]),
   %unifier des variables avec le contenu du JSON
   _{
       beliefs: HunterBeliefs, 
       percepts: Percepts
    } :< RequestJSON,
   %Ces 2 lignes impriment joliment votre JSON reçu
   http_log_stream(Stream),
   print_term(_{beliefs: HunterBeliefs, percepts: Percepts }, [output(Stream),nl(true)]),
   %% ICI vous mettez l'appel au prédicat qui calculera l'action et les nouvelles
   %% croyances (vous êtes libres de faire comme bon vous semble ici)
   calculer_action_croyances(HunterBeliefs, Percepts, NewBeliefs, Action),
   %Cette ligne doit être l'avant-dernière
   cors_enable,
   %% cette ligne envoie le json de votre réponse au serveur
   reply_json_dict(_{
    hunterState: _{
        beliefs:NewBeliefs, percepts: Percepts
    }, 
    action: Action
    }).