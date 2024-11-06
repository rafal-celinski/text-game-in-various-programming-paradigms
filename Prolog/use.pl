% >> use(Item, Object) <<

% > upper_engine

use(gas_canister, gas_engine) :-
    player_position(upper_engine),
    holding(gas_canister),
    assert(unlocked(gas_engine)),
    assert(holding(empty_canister)),
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
    assert(holding(empty_canister)),
    describe(petrol_engine_full), !, nl,
    check_engine_status.

% > medbay
% > security
% > electrical
% > cafeteria/shields

use(flashlight, aliens) :-
    holding(flashlight),
    player_position(Place),
    object_at(Place, aliens),
    retract(object_at(Place, aliens)),
    assert(object_at(Place, blinded_aliens)),
    describe(blind_aliens), !.

use(flashlight, blinded_aliens) :-
    holding(flashlight),
    player_position(Place),
    object_at(Place, blinded_aliens), !,
    describe(blind_blinded_aliens).

use(shotgun, aliens) :-
    holding(shotgun),
    player_position(Place),
    object_at(Place, aliens), !,
    retract(object_at(Place, aliens)),
    assert(object_at(Place, weird_corpses)), !,
    describe(kill_aliens).

use(shotgun, blinded_aliens) :-
    holding(shotgun),
    player_position(Place),
    object_at(Place, blinded_aliens), !,
    retract(object_at(Place, blinded_aliens)),
    assert(object_at(Place, weird_corpses)), !,
    describe(kill_blinded_aliens).

% > admin
use(v1_access_card, admin_panel) :-
    player_position(admin),
    holding(v1_access_card),
    assert(unlocked(admin_panel)),
    describe(admin_panel_unlocked), !, nl.

use(v2_access_card, admin_panel) :-
    player_position(admin),
    holding(v2_access_card),
    assert(unlocked(admin_panel)),
    describe(admin_panel_unlocked), !, nl.

use(medical_report, admin_panel) :-
    player_position(admin),
    unlocked(admin_panel),
    holding(medical_report),
    holding(v2_access_card),
    retract(unlocked(admin_panel)),
    describe(admin_panel_medical_report_v2_card), !, nl.

use(medical_report, admin_panel) :-
    player_position(admin),
    unlocked(admin_panel),
    holding(medical_report),
    holding(v1_access_card),
    retract(unlocked(admin_panel)),
    retract(holding(v1_access_card)),
    assert(holding(v2_access_card)),
    describe(admin_panel_medical_report), !, nl.

use(medical_report, admin_panel) :-
    player_position(admin),
    unlocked(admin_panel),
    holding(medical_report),
    retract(unlocked(admin_panel)),
    describe(admin_panel_medical_report_no_card), !, nl.

use(medical_report, admin_panel) :-
    player_position(admin),
    describe(admin_panel_medical_report_locked), !, nl.


% > storage
% > weapons
% > oxygen
use(wrench, broken_pipe) :-
    player_position(oxygen),
    holding(wrench),
    assert(unlocked(oxygen_pipe)),
    describe(repairing_pipe).

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

use(flashlight) :-
    holding(flashlight),
    describe(flashlight).
    
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
use(admin_panel) :-
    player_position(admin),
    unlocked(admin_panel),
    retract(unlocked(admin_panel)),
    describe(admin_panel_crew_status), !, nl.

use(admin_panel) :-
    player_position(admin),
    describe(admin_panel), !, nl.
% > storage
% > weapons
% > oxygen

use(broken_pipe) :- 
    player_position(oxygen),
    describe(broken_pipe), !.

% > shields
% > navigation

% >> use(Item) <<

use(medical_report) :-
    holding(medical_report),
    describe(medical_report), !, nl.

use(encyklopedia) :-
    holding(encyklopedia),
    assert(used(encyklopedia)),
    describe(encyklopedia).


% >> defaults <<

use(_) :-
    describe(cant_do_that), !, nl.


use(_, _) :-
    describe(cant_do_that), !, nl.



% >> Auxiliary predicates <<

check_engine_status :-
    (
    unlocked(gas_engine),
    unlocked(petrol_engine),
    assert(unlocked_room(electrical)),
    describe(engines_refueled)
    ;
        true
    ), !.

check_flashlight :-
    (
    holding(flashlight),
    used(encyklopedia),
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

check_blinded_aliens :-
    (   
        object_at(Place, blinded_aliens),
        retract(object_at(Place, blinded_aliens)),
        assert(object_at(Place, aliens))
    ;   
        true
    ), !.


%  % TODO TODO TODO TODO
% todo :-
%     write('TODO'), !, nl.

% use(secret_stash) :- todo, !.
% % dostajesz ak-47





