describe(reactor) :- 
    write('The reactor room hums with an intense energy, the core pulsing with an eerie glow.'), nl,
    write('Pipes and machinery line the walls, and the room feels both hot and tense.'), nl.

describe(upper_engine) :- 
    write('The upper engine is loud and shrouded in mist from coolant leaks.'), nl,
    write('Lights flicker as the engine roars, echoing through the metal corridors.'), nl.

describe(lower_engine) :- 
    write('The lower engine room is dimly lit, with heavy machinery vibrating beneath the floors.'), nl,
    write('You feel the ship’s heartbeat here, deep and resonant.'), nl.

describe(security) :- 
    write('The security room is filled with screens showing feeds from various parts of the ship.'), nl,
    write('There is a sense of unease as you realize some cameras are dead.'), nl.

describe(medbay) :- 
    write('The medbay is lined with medical equipment, most of it still functional.'), nl,
    write('An overturned stretcher lies nearby, and the smell of antiseptic lingers.'), nl.

describe(electrical) :- 
    write('The electrical room is dark, with sparking wires and buzzing panels lining the walls.'), nl,
    write('You can feel the static in the air, and caution is essential here.'), nl.

describe(cafeteria) :- 
    write('Long tables and empty food trays fill the cafeteria, once bustling with crew.'), nl,
    write('The silence is unsettling, and a faint aroma of old food still lingers.'), nl.

describe(storage) :- 
    write('Storage is cluttered with crates and containers, all labeled with various supplies.'), nl,
    write('It’s cramped and shadowy, making it hard to see what might be hiding here.'), nl.

describe(weapons) :- 
    write('The weapons room is locked behind a reinforced door, a small armory for the crew.'), nl,
    write('Inside, you see racks of secured weapons awaiting authorization.'), nl.

describe(oxygen) :- 
    write('The oxygen room houses the life support systems, vital for air circulation.'), nl,
    write('There’s a soft whirring of fans, but a warning light flashes ominously.'), nl.

describe(navigation) :- 
    write('The navigation room is lined with monitors displaying star charts and coordinates.'), nl,
    write('This is the heart of the ship’s control, a safe point in times of emergency.'), nl.

describe(shields) :- 
    write('Shield generators hum softly here, their power keeping the ship protected in space.'), nl,
    write('However, flickering lights suggest something isn’t working quite right.'), nl.

describe(communications) :- 
    write('The communications room is filled with screens and panels for sending messages.'), nl,
    write('Red lights blink on the consoles, indicating critical systems offline.'), nl.

describe(admin) :- 
    write('The administration room is filled with terminals and data consoles.'), nl,
    write('This is where important authorizations are made, and the captain’s log rests nearby.'), nl.

describe(plot):- 
write('Welcome to "Escape from the Spaceship"'), nl, nl,
write('It''s the year 2124, humanity stands on the brink of a new era of discovery. 
The research ship Nova Explorer sets out in search of exotic life forms and resources on uncharted planets. 
However, during the mission, everything goes horribly wrong. 
An alien life form encountered in deep space becames a grave threat to the crew. 
Without warning, the team was attacked, plunging the ship into chaos. 
Now, with systems failing and the lives of your companions at stake, you must find a way to eliminate problem.

Before the attack, the ship''s captain briefed you on the emergency protocols. 
To reach the navigation room - a safe point, or armory where weapons are stored you must first obtain a higher-level access card.
To acquire this card, you need to gather critical medical research data about yourself from the medbay.
With that and v1_accress_card you need to head to admin room to enhance your access privileges. 
Unfortunately, the rest of the crew is either dead or trapped in the navigation room with no way to escape. 
It’s up to you to confront the aliens and eliminate the threat to your survival. 
Your ultimate goal is to eliminate the threat, cleanse the ship from potential contamination and free the rest of the crew'), nl.

describe(controls):-
write('Controls'), nl,
write('To see this message again write ''describe(controls)''.'), nl,
write('look - let''s you look around the room you are currently in and see potential ways to interact with environment'), nl,
write('goto(Place) - use it to move around the ship'), nl,
write('take(Item) - pick up an item'), nl,
write('inventory - list items you currently posses'), nl,
write('drop(Item) - if you don''t like something you can drop it'), nl,
write('use(Item, Target) - you can use some of the items to accomplish many things'), nl,
write('use(Item) - use items that don''t have specific target'), nl,
write('For better understanding of the last two commands we will look at the example below'), nl,
write('If you want to destroy the door with the bat you should write use(bat, door) but if you wanted to turn on the flashlight you would write use(flashlight)'), nl,
write('Simple, right?').


write_lock_reason(_):- write('This room is locked.'), nl.