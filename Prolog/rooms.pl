next_to(reactor, upper_engine).
next_to(reactor, lower_engine).
next_to(reactor, security).
next_to(medbay, security).
next_to(upper_engine, cafeteria).
next_to(lower_engine, electrical).
next_to(lower_engine, storage).
next_to(cafeteria, weapons).
next_to(cafeteria, admin).
next_to(cafeteria, storage).
next_to(storage, shields).
next_to(oxygen, shields).
next_to(weapons, shields).
next_to(navigation, shields).

path(X, Y) :- next_to(Y, X).
path(X, Y) :- next_to(X, Y).

unlocked_room(reactor).
unlocked_room(upper_engine).
unlocked_room(lower_engine).
unlocked_room(security).
unlocked_room(medbay).
unlocked_room(cafeteria).
unlocked_room(storage).
unlocked_room(admin).
unlocked_room(weapons) :-
    holding(v2_access_card).
unlocked_room(oxygen) :-
    holding(v2_access_card).
unlocked_room(shields) :-
    holding(v2_access_card).
unlocked_room(navigation) :-
    holding(v2_access_card),
    unlocked(oxygen_pipe),
    object_at(cafeteria, weird_corpses),
    object_at(shields, weird_corpses).
