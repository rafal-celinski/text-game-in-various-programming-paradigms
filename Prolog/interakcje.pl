% use(Item, Object)
% use(Itme)
% use(Object)

use(secret_stash).
% dostajesz ak-47

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

use(encyklopedia).
% czytasz encyklopenie

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


use(v1_access_card, admin_terminal).
    %sprawdza czy jest wynik z medbay i generuje v2 karte

use(yellow_coat).
%zakada plaszcz


use(_):-
    write('You can''t do that'), !, nl.

use(_, _) :-
    write('You can''t do that'), !, nl.
