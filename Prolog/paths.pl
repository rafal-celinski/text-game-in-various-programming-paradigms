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

unlocked_room(_).

