:- dynamic player_position/1, item_at/2, holding/1.
:- retractall(player_position(_)), retractall(item_at(_,_)), retractall(holding(_)).


player_position(reactor).

:- ['paths.pl'].
:- ['descriptions.pl'].
:- ['items.pl'].
:- ['interakcje.pl'].



start :-
    describe(plot).



goto(Destination) :-
    player_position(Source),
    path(Source, Destination),
    unlocked_room(Destination),
    retract(player_position(Source)),
    assert(player_position(Destination)),
    !, write('You are in '), write(Destination), write('.'),
    nl.

goto(Destination) :-
    player_position(Source),
    path(Source, Destination),
    write_lock_reason(Destination).

goto(_) :-
        write('You can''t go that way.').

look :-       
    player_position(Place),
    describe(Place),
    nl,
    notice_objects_at(Place),
    nl,
    notice_items_at(Place),
    nl,
    notice_paths_at(Place),
    nl, !.


notice_items_at(Place) :-
    write('Available items:'), nl,
    item_at(Place, Item),
    write(' - '), write(Item), write(','), nl,
    fail.

notice_items_at(_).

notice_paths_at(Place) :-
    write('You can go to:'), nl,
    path(Place, Destination),
    write(' - '), write(Destination), write(','), nl,
    fail.

notice_paths_at(_).

notice_objects_at(Place) :-
    write('Available objects:'), nl,
    object_at(Place, Object),
    Object \= secret_stash,
    write(' - '), write(Object), write(','), nl,
    fail.

notice_objects_at(_).

take(Item) :-
        holding(Item),
        write('You''re already holding it!'),
        !, nl.

take(Item) :-
        player_position(Place),
        item_at(Place, Item),
        retract(item_at(Place, Item)),
        assert(holding(Item)),
        write('You took '), write(Item), write(','), nl,
        !.

take(_) :-
        write('I don''t see it here.'),
        nl.

drop(Item) :-
        holding(Item),
        player_position(Place),
        retract(holding(Item)),
        assert(item_at(Place, Item)),
        write('OK.'),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.

inventory :-
    write('You are holding:'), nl,
    holding(Item),
    write(' - '), write(Item), write(','), nl,
    fail.

inventory.
