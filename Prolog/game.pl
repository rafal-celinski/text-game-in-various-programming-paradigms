
:- dynamic 
    player_position/1, 
    item_at/2, 
    holding/1, 
    object_at/2, 
    unlocked_room/1, 
    player_before/1,
    unlocked_object/1,
    done/1.

:- 
    retractall(player_position(_)), 
    retractall(item_at(_,_)), 
    retractall(holding(_)), 
    retractall(object_at(_,_)), 
    retractall(unlocked_room(_)), 
    retractall(player_before(_)),
    retractall(unlocked_object(_)),
    retractall(done(_)).

:- ['rooms.pl'].
:- ['items.pl'].
:- ['objects.pl'].
:- ['plot.pl'].
:- ['use_item_on_object.pl'].

player_position(reactor).

talk :-
    player_position(navigation),
    describe(ending_scene), !.

talk :-
    describe(insanity), !.

start :-
    describe(plot), nl,
    describe(controls), nl.



run :-
    player_position(Place),
    object_at(Place, aliens),
    player_before(Before), !,
    retract(player_position(Place)),
    assert(player_position(Before)),
    retract(player_before(_)),
    write('You are in '), write(Before), write('.'),
    nl.

run :-
    write('No need to run'), nl.


goto(_) :-
    player_position(Source),
    object_at(Source, aliens), !,
    write('You can''t go anywhere! Run for your life or fight for it!'), nl.


goto(Destination) :-
    player_position(Source),
    object_at(Destination, aliens),
    path(Source, Destination),
    unlocked_room(Destination),
    retract(player_position(Source)),
    assert(player_position(Destination)),
    retractall(player_before(_)),
    assert(player_before(Source)),
    !, write('You are in '), write(Destination), write('.'), nl,
    describe_aliens(Destination),
    check_flashlight,
    check_shotgun,
    write('You can use ''run'' to escape to where from you came'), nl.


goto(Destination) :-
    player_position(Source),
    path(Source, Destination),
    unlocked_room(Destination),
    retract(player_position(Source)),
    assert(player_position(Destination)),
    !, write('You are in '), write(Destination), write('.'),
    nl,
    check_blinded_aliens.


goto(Destination) :-
    player_position(Source),
    path(Source, Destination),
    write_lock_reason(Destination), !, nl.

goto(_) :-
        write('You can''t go that way.'), !, nl.

look :-       
    player_position(Place),
    ( object_at(Place, aliens) ->
        write('It''s not the time for sightseeing!'), nl
    ;   
        describe_room(Place),
        nl,
        notice_objects_at(Place),
        nl,
        notice_items_at(Place),
        nl,
        notice_paths_at(Place),
        nl, !
    ).


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

drop(v2_access_card) :-
    write('Don''t do that, you will need it'), nl


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

controls :-
    describe(controls), !, nl.


% use object when unlocked
use(Object) :-
    player_position(Place),
    object_at(Place, Object),
    unlocked_object(Object),
    use_object(Object), !.

% use object when locked
use(Object) :-
    player_position(Place),
    object_at(Place, Object),
    use_locked_object(Object), !.

use(Item) :-
    holding(Item),
    use_item(Item), !.

use(_) :-
    write('You can''t do that'), !, nl.

% use object when unlocked
use(Item, Object) :-
    holding(Item),
    player_position(Place),
    object_at(Place, Object),
    unlocked_object(Object),
    use_item_on_object(Item, Object), !.

% use object when locked
use(Item, Object) :-
    holding(Item),
    player_position(Place),
    object_at(Place, Object),
    use_locked_item_on_object(Item, Object), !.

use(_, _) :-
    write('You can''t do that'), !, nl.

check_blinded_aliens :-
    (   
        object_at(Place, blinded_aliens),
        retract(object_at(Place, blinded_aliens)),
        assert(object_at(Place, aliens))
    ;   
        true
    ), !.

check_flashlight :-
    (
    holding(flashlight),
    done(encyklopedia),
    describe(have_flashlight)
    ;
        true
    ), !.

check_shotgun :-
    (
    holding(shotgun),
    describe(have_shotgun)
    ;
        true
    ), !.

