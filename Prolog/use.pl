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
    describe(petrol_engine_full), !, nl,
    check_engine_status.

% > medbay
% > security
% > electrical
% > cafeteria
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

use(_, _) :-
    describe(cant_do_that), !, nl.

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

use(cameras):-
    player_position(security),
    object_at(security, cameras),
    object_at(shields, aliens),
    retract(object_at(security, cameras)),
    describe(cameras_aliens_shields), !.

use(cameras):-
    player_position(security),
    retract(object_at(security, cameras)),
    object_at(security, cameras),
    describe(cameras_no_aliens), !, nl.

use(cameras):-
    player_position(security),
    write('Only thing you can see is your mirrored image on the black screen.'), !, nl.

use(power_breaker) :-
    player_position(electrical),
    used(power_breaker),
    write('Everything seems working fine. Power in medbay should be restored.'), !, nl.

use(power_breaker):-
    player_position(electrical),
    write('A sturdy power breaker is mounted on the wall, labeled "Medbay Power Supply."'), nl,
    write('It seems switched off, likely the cause of the scanner’s malfunction.'), nl,
    write('You try pulling the lever to restore power to the medbay.'), nl,
    write('It worked. Finally no sad suprises...'), nl,
    write('At least for now...'), nl,
    assert(used(power_breaker)),
    assert(unlocked(scanner)), !.



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
% > shields
% > navigation

% >> use(Item) <<
use(medical_report) :-
    holding(medical_report),
    describe(medical_report), !, nl.

use(encyklopedia) :-
    holding(encyklopedia),
    assert(used(encyklopedia)),
    write('You open the worn pages of the encyclopedia, flipping through information on various alien species.'), nl,
    write('One entry catches your attention: it describes a species known for its shape-shifting abilities and hostile nature.'), nl,
    write('A critical line reads: "Though formidable, this species has one weakness—intense, direct light can disorient or even harm it."'), nl,
    write('Maybe bringing flashlight to the battelfield wouldn''t be bad idea'), !, nl.

use(flashlight, aliens) :-
    holding(flashlight),
    player_position(Place),
    object_at(Place, aliens), !,
    retract(object_at(Place, aliens)),
    assert(object_at(Place, blinded_aliens)),
    write('You flick on the flashlight, pointing it directly at the alien figures before you.'), nl,
    write('The intense beam pierces through the darkness, and the creatures recoil, their hollow eyes blinking and limbs twitching in confusion.'), nl,
    write('They stagger back, momentarily stunned and disoriented by the powerful light. It won’t hold them for long, but you have a chance to move or attack while they’re blinded.'), nl, !.

use(flashlight, blinded_aliens) :-
    holding(flashlight),
    player_position(Place),
    object_at(Place, blinded_aliens), !,
    write('Don''t play with those things, at any moment flashlight can stop working and you stand no chance without it.'), nl.


use(flashlight) :-
    holding(flashlight),
    write('You don''t know how long will the battery keep up but the light could easily blind someone'), !, nl.


use(shotgun, aliens) :-
    holding(shotgun),
    player_position(Place),
    object_at(Place, aliens), !,
    retract(object_at(Place, aliens)),
    assert(object_at(Place, weird_corpses)), !,
    write('You raise the shotgun, heart pounding as you take aim at the alien figures.'), nl,
    write('With a deafening blast, the shotgun kicks against your shoulder, the recoil intense but satisfying.'), nl,
    write('The alien creatures stagger, their hollow eyes widening just before they collapse in twisted, unnatural heaps on the floor.'), nl,
    write('Their forms begin to dissolve, revealing something even stranger beneath – twisted, sinewy masses that vaguely resemble what once might have been living beings.'), nl.


use(shotgun, blinded_aliens) :-
    holding(shotgun),
    player_position(Place),
    object_at(Place, blinded_aliens), !,
    retract(object_at(Place, blinded_aliens)),
    assert(object_at(Place, weird_corpses)), !,
    write('You take advantage of the aliens’ confusion, raising the shotgun with steady hands.'), nl,
    write('The creatures, disoriented and staggering, barely react as you pull the trigger. The shotgun roars, filling the room with an explosive sound.'), nl,
    write('The blinded aliens crumple, their strange, distorted forms dropping heavily to the ground, helpless under the onslaught.'), nl,
    write('As they fall, their true forms begin to seep through the disguise – grotesque, sinewy masses twisted into shapes that vaguely hint at something once living.'), nl,
    write('All that remains are eerie, unnatural corpses scattered on the floor, a disturbing testament to their failed mimicry of the crew.'), nl.


% >> defaults <<

use(_) :-
    describe(cant_do_that), !, nl.





% >> Auxiliary predicates <<

check_engine_status :-
    unlocked(gas_engine),
    unlocked(petrol_engine),
    assert(unlocked_room(electrical)),
    describe(engines_refueled), !, fail, nl.

check_flashlight :-
    (
    holding(flashlight),
    used(encyklopedia),
    write('You feel the weight of the flashlight in your pocket, its cool metal a reminder of the creatures’ one known weakness.'), nl
    ;
        true
    ), !.

check_shotgun :-
    (
    holding(shotgun),
    write('You grip the shotgun firmly, its weight solid and reassuring in your hands. Whatever these things are, you’re ready.'), nl
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

% use(wrench, broken_pipe) :- todo, !.
% %naprawia rure

% use(broken_pipe) :- todo, !.
% % info o rurze

% use(encyklopedia) :- todo, !.
% % czytasz encyklopenie

