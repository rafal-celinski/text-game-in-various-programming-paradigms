% >> use(Item, Object) <<
% > upper_engine
use(gas_canister, gas_engine) :-
    player_position(upper_engine),
    holding(gas_canister),
    assert(unlocked(gas_engine)),
    retract(holding(gas_canister)),
    describe(gas_engine_full), !, nl,
    check_engine_status.

% > reactor
% > lower_engine
use(petrol_canister, petrol_engine) :-
    player_position(lower_engine),
    holding(petrol_canister),
    assert(unlocked(petrol_engine)),
    retract(holding(petrol_canister)),
    describe(petrol_engine_full), !, nl.
    check_engine_status.

% > medbay
% > security
% > electrical
% > cafeteria
% > admin
% > storage
% > weapons
% > oxygen
% > shields
% > navigation

% >> use(Object)
% > upper_engine
use(gas_engine) :-
    object_at(upper_engine, gas_engine),
    player_position(upper_engine),
    describe(gas_engine), !, nl.

% > reactor
% > lower_engine
use(petrol_engine) :-
    object_at(lower_engine, petrol_engine),
    player_position(lower_engine),
    describe(petrol_engine), !, nl.

% > medbay
use(scanner) :-
    player_position(medbay),
    used(scanner),
    describe(scanner_used), !, nl.

use(scanner) :-
    player_position(medbay),
    unlocked(scanner),
    assert(holding(medical_report)),
    assert(used(scanner)),
    describe(scanning), !, nl.
    
use(scanner) :-
    player_position(medbay),
    describe(scanner_black_screen), !, nl.

% > security
use(cameras) :-
    player_position(security),
    object_at(security, cameras),
    object_at(cafeteria, aliens),
    object_at(shields, aliens),
    retract(object_at(security, cameras)),
    describe(cameras_aliens_alive), !, nl.

use(cameras) :-
    player_position(security),
    object_at(security, cameras),
    object_at(cafeteria, aliens),
    retract(object_at(security, cameras)),
    describe(cameras_alines_cafeteria), !, nl.

use(cameras) :-
    player_position(security),
    object_at(security, cameras),
    object_at(shields, aliens),
    retract(object_at(security, cameras)),
    describe(cameras_aliens_shields), !, nl.

use(cameras) :-
    player_position(security),
    retract(object_at(security, cameras)),
    object_at(security, cameras),
    describe(cameras_no_aliens), !, nl.

use(cameras) :-
    player_position(security),
    describe(cameras_black_screen), !, nl.
    
% > electrical
use(power_breaker) :-
    player_position(electrical),
    used(power_breaker),
    describe(power_breaker_used), !, nl.

use(power_breaker) :-
    player_position(electrical),
    describe(power_breaker), nl,
    assert(used(power_breaker)),
    assert(unlocked(scanner)), !.

% > cafeteria
% > admin
% > storage
% > weapons
% > oxygen
% > shields
% > navigation

% >> use(Item) <<

% >> defaults <<
use(_) :-
    describe(cant_do_that), !, nl.

use(_, _) :-
    describe(cant_do_that), !, nl.

% >> Auxiliary predicates <<

check_engine_status :-
    unlocked(gas_engine),
    unlocked(petrol_engine),
    assert(unlocked_room(electrical)),
    describe(engines_refueled), !, fail, nl.


 % TODO TODO TODO TODO
todo :-
    write('TODO'), !, nl.

use(secret_stash) :- todo, !.
% dostajesz ak-47

use(wrench, broken_pipe) :- todo, !.
%naprawia rure

use(broken_pipe) :- todo, !.
% info o rurze

use(encyklopedia) :- todo, !.
% czytasz encyklopenie


use(admin_terminal) :- todo, !.
%jeśli zabci alieni to czysci statek

use(v2_access_card, terminal) :- todo, !.
% odblokowuje dostęp do nawigacji

use(ak_47, aliens) :- todo, !.
% zabija (zamienia w martwych)


use(v1_access_card, admin_terminal) :- todo, !.
    %sprawdza czy jest wynik z medbay i generuje v2 karte

use(yellow_coat) :- todo, !.
%zakada plaszcz



