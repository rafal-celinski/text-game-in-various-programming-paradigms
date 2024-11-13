use_item_on_object(gas_canister, gas_engine) :-
    assert(done(gas_engine)),
    assert(holding(empty_canister)),
    retract(holding(gas_canister)),
    describe(gas_engine_full), !, nl,
    check_engine_status.

use_item_on_object(petrol_canister, petrol_engine) :-
    assert(done(petrol_engine)),
    retract(holding(petrol_canister)),
    assert(holding(empty_canister)),
    describe(petrol_engine_full), !, nl,
    check_engine_status.

use_item_on_object(flashlight, aliens) :-
    player_position(Place),
    retract(object_at(Place, aliens)),
    assert(object_at(Place, blinded_aliens)),
    describe(blind_aliens), !.

use_item_on_object(flashlight, blinded_aliens) :-
    describe(blind_blinded_aliens).

use_item_on_object(shotgun, aliens) :-
    player_position(Place),
    retract(object_at(Place, aliens)),
    assert(object_at(Place, weird_corpses)), !,
    describe(kill_aliens).

use_item_on_object(shotgun, blinded_aliens) :-
    player_position(Place),
    retract(object_at(Place, blinded_aliens)),
    assert(object_at(Place, weird_corpses)), !,
    describe(kill_blinded_aliens).

use_item_on_object(medical_report, admin_panel) :-
    holding(v2_access_card),
    retract(unlocked_object(admin_panel)),
    describe(admin_panel_medical_report_v2_card), !, nl.

use_item_on_object(medical_report, admin_panel) :-
    holding(v1_access_card),
    retract(unlocked_object(admin_panel)),
    retract(holding(v1_access_card)),
    assert(holding(v2_access_card)),
    describe(admin_panel_medical_report), !, nl.

use_item_on_object(medical_report, admin_panel) :-
    retract(unlocked_object(admin_panel)),
    describe(admin_panel_medical_report_no_card), !, nl.

use_item_on_object(wrench, broken_pipe) :-
    assert(done(oxygen_pipe)),
    retract(object_at(oxygen, broken_pipe)),
    assert(unlocked_object(repaired_pipe)),
    assert(object_at(oxygen, repaired_pipe)),
    describe(repairing_pipe).

check_engine_status :-
    (
    done(gas_engine),
    done(petrol_engine),
    describe(engines_refueled)
    ;
        true
    ), !.

use_locked_item_on_object(v1_access_card, admin_panel) :-
    assert(unlocked_object(admin_panel)),
    describe(admin_panel_unlocked), !, nl.

use_locked_item_on_object(v2_access_card, admin_panel) :-
    assert(unlocked_object(admin_panel)),
    describe(admin_panel_unlocked), !, nl.

use_locked_item_on_object(medical_report, admin_panel) :-
    describe(admin_panel_medical_report_locked), !, nl.
