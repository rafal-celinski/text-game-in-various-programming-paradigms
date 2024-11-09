:- discontiguous 
    describe_object/1,
    use_object/1,
    use_locked_object/1,
    object_at/2,
    unlocked_object/1.

% GAS_ENGINE
    object_at(upper_engine, gas_engine).
    unlocked_object(gas_engine).

    describe_object(gas_engine) :-
        write('The engine provides power for the entire ship'), nl.

% PETROL_ENGINE
    object_at(lower_engine, petrol_engine).
    unlocked_object(petrol_engine).

    describe_object(petrol_engine) :-
        write('The engine provides power for the entire ship'), nl.


% SCANNER
    object_at(medbay, scanner).
    unlocked_object(scanner) :- done(power_breaker).

    use_object(scanner) :-
        assert(holding(medical_report)),
        assert(done(scanner)),
        describe(scanning), !, nl.

    use_object(scanner) :-
        done(scanner),
        describe(scanner_used), !, nl.

    use_locked_object(scanner) :-
        describe(scanner_black_screen), !, nl.  

% CAMERAS
    object_at(security, cameras).
    unlocked_object(cameras) :- \+ done(cameras).

    use_object(cameras) :-
        assert(done(cameras)),
        fail.

    use_object(cameras) :-
        object_at(cafeteria, aliens),
        object_at(shields, aliens),
        describe(cameras_aliens_alive), !, nl.

    use_object(cameras) :-
        object_at(cafeteria, aliens),
        describe(cameras_alines_cafeteria), !, nl.

    use_object(cameras) :-
        object_at(shields, aliens),
        describe(cameras_aliens_shields), !, nl.

    use_object(cameras) :-
        describe(cameras_no_aliens), !, nl.

    use_locked_object(cameras) :-
        describe(cameras_black_screen), !, nl.

% POWER_BREAKER
    object_at(electrical, power_breaker).
    unlocked_object(power_breaker).

    describe_object(power_breaker) :-
        write('A sturdy power breaker is mounted on the wall, labeled "Medbay Power Supply."'), nl,
        write('It seems switched off, likely the cause of the scanner’s malfunction.'), nl,
        write('You try pulling the lever to restore power to the medbay.'), nl,
        write('It worked. Finally no sad suprises...'), nl,
        write('At least for now...'), nl.

    use_object(power_breaker) :-
        done(power_breaker),
        describe(power_breaker_used), !, nl.

    use_object(power_breaker) :-
        assert(done(power_breaker)),
        describe(power_breaker), !, nl.

% ALIENS
    object_at(shields, aliens).
    object_at(cafeteria, aliens).
    unlocked_object(aliens).

% BLIND_ALIENS
    unlocked_object(blinded_aliens).

    describe_object(blinded_aliens):-
        write('You flick on the flashlight, pointing it directly at the alien figures before you.'), nl,
        write('The intense beam pierces through the darkness, and the creatures recoil, their hollow eyes blinking and limbs twitching in confusion.'), nl,
        write('They stagger back, momentarily stunned and disoriented by the powerful light. It won’t hold them for long, but you have a chance to move or attack while they’re blinded.'), nl.



% ADMIN_PANEL
    object_at(admin, admin_panel).

    describe_object(admin_panel) :-
        write('In front of you is the administration panel, the crew management center on the spaceship.'), nl,
        write('This is where you coordinate the activities of individual crew members,'), nl,
        write('assign tasks, monitor their health and morale, ensuring that everyone knows their place and role in this interstellar journey.'), nl,
        write('To use it, you need to authenticate using your access_card.'), nl.
    
    use_object(admin_panel) :-
        retract(unlocked(admin_panel)),
        describe(admin_panel_crew_status), !, nl.

    use_locked_object(admin_panel) :-
        describe_object(admin_panel), !, nl.

% BROKEN_PIPE
    object_at(oxygen, broken_pipe).
    unlocked_object(broken_pipe).

    describe_object(broken_pipe):-
        write('A sturdy metal pipe runs along the wall, but near one of the joints, a crack has started to leak oxygen in faint, rhythmic hisses.'), nl,
        write('The crack is surrounded by a series of loose bolts and fittings that hold the pipe’s sections together.'), nl,
        write('With a wrench, you might be able to tighten the joints and secure the connection enough to stop the leak temporarily.'), nl.


use_object(Object) :-
    describe_object(Object), !, nl.