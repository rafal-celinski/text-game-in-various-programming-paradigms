:- discontiguous 
    unlocked_room/1, 
    describe_room/1,
    write_lock_reason/1.

%PATHS
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

% REACTOR
    unlocked_room(reactor).
    
    describe_room(reactor) :- 
        write('The reactor room hums with an intense energy, the core pulsing with an eerie glow.'), nl,
        write('Pipes and machinery line the walls, and the room feels both hot and tense.'), nl.

% UPPER_ENGINE
    unlocked_room(upper_engine).
    
    describe_room(upper_engine) :- 
        write('The upper engine is loud and shrouded in mist from coolant leaks.'), nl,
        write('Lights flicker as the engine roars, echoing through the metal corridors.'), nl.

% LOWER_ENGINE
    unlocked_room(lower_engine).
    
    describe_room(lower_engine) :- 
        write('The lower engine room is dimly lit, with heavy machinery vibrating beneath the floors.'), nl,
        write('You feel the ship’s heartbeat here, deep and resonant.'), nl.

% SECURITY
    unlocked_room(security).
    
    describe_room(security) :- 
        write('The security room is filled with screens showing feeds from various parts of the ship.'), nl,
        write('There is a sense of unease as you realize some cameras are dead.'), nl.

% MEDBAY
    unlocked_room(medbay).
    
    describe_room(medbay) :- 
        write('The medbay is lined with medical equipment, most of it still functional.'), nl,
        write('An overturned stretcher lies nearby, and the smell of antiseptic lingers.'), nl.

% ELECTRICAL
    unlocked_room(electrical) :-
        done(gas_engine),
        done(petrol_engine).

    describe_room(electrical) :- 
        write('The electrical room is dark, with sparking wires and buzzing panels lining the walls.'), nl,
        write('You can feel the static in the air, and caution is essential here.'), nl.

    write_lock_reason(electrical):-
        write('You try to open the door to the electrical room, but it doesn’t budge.'), nl,
        write('A warning on the control panel reads: "Refuel both engines to stabilize power distribution."'), nl,
        write('It seems that the electrical room’s power systems are reliant on fully fueled engines.'), nl,
        write('And once again you must think of something. Where could the spare fuel be stored?'), nl.

% CAFETERIA
    unlocked_room(cafeteria).
    
    describe_room(cafeteria) :- 
        write('Long tables and empty food trays fill the cafeteria, once bustling with crew.'), nl,
        write('The silence is unsettling, and a faint aroma of old food still lingers.'), nl.

% STORAGE
    unlocked_room(storage).
    
    describe_room(storage) :- 
        write('Storage is cluttered with crates and containers, all labeled with various supplies.'), nl,
        write('It’s cramped and shadowy, making it hard to see what might be hiding here.'), nl.

%WEAPONS
    unlocked_room(weapons) :-
        holding(v2_access_card).
    
    describe_room(weapons) :- 
        write('The weapons room is locked behind a reinforced door, a small armory for the crew.'), nl,
        write('Inside, you see racks of secured weapons awaiting authorization.'), nl.

    write_lock_reason(weapons):-
        write('You need v2_access_card to access this room'), nl.

% OXYGEN
    unlocked_room(oxygen) :-
        holding(v2_access_card).
    
    describe_room(oxygen) :- 
        write('The oxygen room houses the life support systems, vital for air circulation.'), nl,
        write('There’s a soft whirring of fans, but a warning light flashes ominously.'), nl.

    write_lock_reason(oxygen):-
        write('You need v2_access_card to access this room'), nl.


% NAVIGATION
    unlocked_room(navigation) :-
        holding(v2_access_card),
        done(oxygen_pipe),
        object_at(cafeteria, weird_corpses),
        object_at(shields, weird_corpses).
    
    describe_room(navigation) :-
        write('The navigation room is lined with monitors displaying star charts and coordinates, softly glowing in the dim light.'), nl,
        write('This is the heart of the ship’s control, a designated safe point in times of emergency.'), nl,
        write('The remaining crew members look up as you enter, their eyes heavy with exhaustion but filled with relief.'), nl,
        write('They offer tired smiles, grateful that the ordeal is finally over, and a calm settles over the room as everyone regains a sense of safety.'), nl,
        write('You can talk to them using `talk`'), nl.

    write_lock_reason(navigation):-
        write('You need to eliminate every threat on the ship to open this door'),
        write('Don''t forget about v2_access_card. Without it system won''t let you in.'), nl.

%SHIELDS
    unlocked_room(shields) :-
        holding(v2_access_card).
    
    describe_room(shields) :- 
        write('Shield generators hum softly here, their power keeping the ship protected in space.'), nl,
        write('However, flickering lights suggest something isn’t working quite right.'), nl.

    write_lock_reason(shields):-
        write('You need v2_access_card to access this room'), nl.

%ADMIN
    unlocked_room(admin).
    
    describe_room(admin) :- 
        write('The administration room is filled with terminals and data consoles.'), nl,
        write('This is where important authorizations are made, and the captain’s log rests nearby.'), nl.
