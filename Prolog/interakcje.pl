


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
    describe(cameras_no_aliens), !.


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
    % unlocked(scanner),
    assert(holding(medical_report)),
    assert(used(scanner)),
    write("You have aquired medical report. Go to admin room with v1_access card to upgrade it"), !, nl.



use(admin_terminal).
%jeśli zabci alieni to czysci statek

use(v2_access_card, terminal).
% odblokowuje dostęp do nawigacji

use(ak_47, aliens).
% zabija (zamienia w martwych)

use(fuel, tank).
%tankuje zbiornik

use(v1_access_card, admin_terminal).
    %sprawdza czy jest wynik z medbay i generuje v2 karte

use(yellow_coat).
%zakada plaszcz