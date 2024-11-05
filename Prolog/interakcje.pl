% use(Item, Object)
% use(Itme)
% use(Object)

use(secret_stash) :-
    assert(holding(shotgun)), !.

use(cameras):-
    player_position(security),
    object_at(security, cameras),
    object_at(cafeteria, aliens),
    object_at(shields, aliens),
    retract(object_at(security, cameras)),
    describe(cameras_aliens_alive), !.

use(cameras):-
    player_position(security),
    object_at(security, cameras),
    object_at(cafeteria, aliens),
    retract(object_at(security, cameras)),
    describe(cameras_alines_cafeteria), !.

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

use(wrench, broken_pipe).
%naprawia rure

use(broken_pipe).
% info o rurze

use(encyklopedia) :-
    holding(encyklopedia),
    assert(used(encyklopedia)),
    write('You open the worn pages of the encyclopedia, flipping through information on various alien species.'), nl,
    write('One entry catches your attention: it describes a species known for its shape-shifting abilities and hostile nature.'), nl,
    write('A critical line reads: "Though formidable, this species has one weakness—intense, direct light can disorient or even harm it."'), nl,
    write('Maybe bringing flashlight to the battelfield wouldn''t be bad idea'), !, nl.

use(scanner) :-
    player_position(medbay),
    used(scanner),
    write('Don''t waste time. You already did that.'), !, nl.

use(scanner) :-
    player_position(medbay),
    unlocked(scanner),
    assert(holding(medical_report)),
    assert(used(scanner)),
    write("You have aquired medical report. Go to admin room with v1_access card to upgrade it."), !, nl.

use(scanner) :-
    player_position(medbay),
    write('The medbay scanner sits dormant, its screen blank and unresponsive due to an electrical shortage.'), nl,
    write('Maybe checking electrical room will let you progress. If you recall corectly it was located near lower engines'), !, nl.


use(admin_terminal).
%jeśli zabci alieni to czysci statek

use(v2_access_card, terminal).
% odblokowuje dostęp do nawigacji

use(ak_47, aliens).
% zabija (zamienia w martwych)

use(petrol_canister, petrol_engine) :-
    player_position(lower_engine),
    holding(petrol_canister),
    assert(unlocked(petrol_engine)),
    retract(holding(petrol_canister)),
    write('You carefully pour the petrol into the left engine. The fuel gauge rises to full!'), !, nl,
    check_engine_status.

use(gas_canister, gas_engine) :-
    player_position(upper_engine),
    holding(gas_canister),
    assert(unlocked(gas_engine)),
    retract(holding(gas_canister)),
    write('You connect the gas canister to the right engine. The gauge stabilizes, indicating full fuel.'), !, nl,
    check_engine_status.


check_engine_status :-
    unlocked(gas_engine),
    unlocked(petrol_engine),
    assert(unlocked_room(electrical)),
    write('Both engines are refueled. The electrical room is now accessible!'), !, fail, nl.

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


use(v1_access_card, admin_terminal).
    %sprawdza czy jest wynik z medbay i generuje v2 karte

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


use(_):-
    write('You can''t do that'), !, nl.

use(_, _) :-
    write('You can''t do that'), !, nl.
