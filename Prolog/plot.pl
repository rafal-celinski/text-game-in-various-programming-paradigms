

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

describe(cameras_aliens_alive):-
    write('You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.'), nl,
    write('In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...'), nl,
    write('...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.'), nl,
    write('The camera feed in the shields room shows another one of these impostors prowling near the shield generators, its form disturbingly familiar.'), nl,
    write('Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.'), nl,
    write('The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.'), nl,
    write('In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever.'), nl.

describe(cameras_alines_cafeteria):-
    write('You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.'), nl,
    write('The camera feed in the shields room shows one of the aliens prowling near the shield generators, its form disturbingly familiar.'), nl,
    write('Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.'), nl,
    write('The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.'), nl,
    write('In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever.'), nl.

describe(cameras_aliens_shields):-
    write('You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.'), nl,
    write('In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...'), nl,
    write('...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.'), nl,
    write('Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.'), nl,
    write('The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.'), nl,
    write('In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever.'), nl.

describe(cameras_no_aliens):-
    write('The camera feeds flicker to life, displaying a quiet stillness that has returned to the ship.'), nl,
    write('The cafeteria sits empty, tables undisturbed and lights humming softly.'), nl,
    write('A calm has settled over the corridors, where only the gentle pulsing of the ship’s systems remains.'), nl,
    write('For a moment, there’s a strange sense of peace... until a faint electric crackle disrupts the silence.'), nl,
    write('The screens flicker one last time, then slowly fade to black. Whatever happened here, it’s finally over.'), nl.

describe(cameras_black_screen) :-
    write('Only thing you can see is your mirrored image on the black screen.'), nl.

describe(power_breaker_used) :- 
    write('Everything seems working fine. Power in medbay should be restored.'), nl.

describe(scanner_used) :-
    write('Don''t waste time. You already did that.'), nl.

describe(scanning) :-
    write('You have aquired medical report. Go to admin room with v1_access card to upgrade it.'), nl.

describe(scanner_black_screen) :-
    write('The medbay scanner sits dormant, its screen blank and unresponsive due to an electrical shortage.'), nl,
    write('Maybe checking electrical room will let you progress. If you recall corectly it was located near lower engines'), nl.

describe(controls):-
    write('Controls'), nl,
    write('To see this message again write ''controls.''.'), nl,
    write('look - let''s you look around the room you are currently in and see potential ways to interact with environment'), nl,
    write('goto(Place). - use it to move around the ship'), nl,
    write('take(Item). - pick up an item'), nl,
    write('inventory. - list items you currently posses'), nl,
    write('drop(Item). - if you don''t like something you can drop it'), nl,
    write('use(Item, Target). - you can use some of the items to accomplish many things'), nl,
    write('use(Item/Object). - use things that don''t have specific target'), nl,
    write('For better understanding of the last two commands we will look at the example below'), nl,
    write('If you want to destroy the door with the bat you should write use(bat, door). but if you wanted to turn on the flashlight you would write use(flashlight)'), nl,
    write('Simple, right?').

describe(petrol_engine_full) :-
    write('You carefully pour the petrol into the left engine. The fuel gauge rises to full!'), nl.

describe(gas_engine_full) :-
    write('You connect the gas canister to the right engine. The gauge stabilizes, indicating full fuel.'), nl.

describe(engines_refueled) :-
    write('Both engines are refueled. The electrical room is now accessible!'), nl.

describe(admin_panel_unlocked) :-
    write('Your access card hums softly as it validates your credentials, granting you a fleeting moment of control.'), nl,
    write('With the system poised for your commands, you can execute one critical operation before the terminal locks out once more.'), nl.

describe(admin_panel_crew_status) :-
    write('The administrative panel displays alarming data: two crew members are deceased, while four survivors sit in the navigation room,'), nl,
    write('their stress levels visibly elevated. The emergency mode is active, and the crew''s health indicators flash red, signaling a critical situation.'), nl,
    write('The activity log shows their recent attempts at coordination'), nl.

describe(admin_panel_medical_report) :- 
    write('Your medical report flashes on the screen, confirming that you are indeed human.'), nl,
    write('As the information sinks in, a new message appears, offering a glimmer of hope.'), nl,
    write('In case of emergency, you are granted a higher-level access card, allowing you to unlock more secure areas of the ship.'), nl,
    write('As you obtain the higher-level access card, an alarm suddenly blares through the ship.'), nl,
    write('"Warning! Oxygen levels critical. Immediate repair needed to maintain safe breathing conditions."'), nl,
    write('The system message echoes ominously, sending a chill down your spine.'), nl, nl,
    write('To reach the oxygen installations, you will need to pass through storage and shields. The path won’t be easy...'), nl.

describe(admin_panel_medical_report_v2_card) :- 
    write('You already have your v2_access_card'), nl,
    write('You don''t need another one'), nl.

describe(admin_panel_medical_report_no_card) :- 
    write('You need the access card for the medical report to be valid'), nl.

describe(admin_panel_medical_report_locked) :-
    write('Before use admin panel, you need to authenticate using your access_card'), nl,
    write('Just bring it close to the panel'), nl.

describe(blind_aliens) :-
    write('You flick on the flashlight, pointing it directly at the alien figures before you.'), nl,
    write('The intense beam pierces through the darkness, and the creatures recoil, their hollow eyes blinking and limbs twitching in confusion.'), nl,
    write('They stagger back, momentarily stunned and disoriented by the powerful light. It won’t hold them for long, but you have a chance to move or attack while they’re blinded.'), nl.

describe(blind_blinded_aliens):-
    write('Don''t play with those things, at any moment flashlight can stop working and you stand no chance without it.'), nl.

describe(kill_aliens):-
    write('You raise the shotgun, heart pounding as you take aim at the alien figures.'), nl,
    write('With a deafening blast, the shotgun kicks against your shoulder, the recoil intense but satisfying.'), nl,
    write('The alien creatures stagger, their hollow eyes widening just before they collapse in twisted, unnatural heaps on the floor.'), nl,
    write('Their forms begin to dissolve, revealing something even stranger beneath – twisted, sinewy masses that vaguely resemble what once might have been living beings.'), nl.

describe(kill_blinded_aliens):-
    write('You take advantage of the aliens’ confusion, raising the shotgun with steady hands.'), nl,
    write('The creatures, disoriented and staggering, barely react as you pull the trigger. The shotgun roars, filling the room with an explosive sound.'), nl,
    write('The blinded aliens crumple, their strange, distorted forms dropping heavily to the ground, helpless under the onslaught.'), nl,
    write('As they fall, their true forms begin to seep through the disguise – grotesque, sinewy masses twisted into shapes that vaguely hint at something once living.'), nl,
    write('All that remains are eerie, unnatural corpses scattered on the floor, a disturbing testament to their failed mimicry of the crew.'), nl.

describe(have_flashlight):-
    write('You feel the weight of the flashlight in your pocket, its cool metal a reminder of the creatures’ one known weakness.'), nl.

describe(have_shotgun):-
    write('You grip the shotgun firmly, its weight solid and reassuring in your hands. Whatever these things are, you’re ready.'), nl.

describe(repairing_pipe):-
    write('You position the wrench over the loose bolts near the cracked joint, gripping tightly.'), nl,
    write('With a few strong turns, you feel the bolts begin to tighten, pulling the pipe’s sections securely together.'), nl,
    write('The hissing sound gradually fades as the leak closes, and the air in the room feels more stable.'), nl,
    write('Satisfied with the makeshift repair, you step back, knowing this should hold long enough to restore the oxygen flow.'), nl.

describe(ending_scene) :-
    write('As they gather in the navigation room, the crew exchanges weary but relieved glances.'), nl,
    write('One by one, they take turns recounting the harrowing events, voices hushed but tinged with disbelief and gratitude.'), nl,
    write('They lean in, nodding as each person speaks, sharing quick smiles and soft laughs that cut through the tension.'), nl,
    write('A faint warmth returns to their expressions, a camaraderie solidified by survival. They stand a little taller, knowing the danger is finally behind them.'), nl, nl,
    write('Their reaction means one more thing. Your journey with the game ends. Congratulations!'), nl,
    write('As developers we hope you enjoyed your time here. Have a good one!'), nl.

describe(insanity) :-
    write('Already talking to yourself?'), nl.

describe_aliens(cafeteria):-
    write('You step into the dimly lit room, and a chill immediately runs down your spine.'), nl,
    write('Figures stand scattered across the room, moving with a strange, unnatural grace. At first glance, they look like members of your crew.'), nl,
    write('But as they turn toward you, you notice their eyes: empty, hollow, and unblinking, devoid of any humanity.'), nl,
    write('Their movements are jerky, almost as if they’re struggling to control the forms they’ve taken.'), nl,
    write('A faint, low hiss fills the air as they begin to advance, recognizing you as an outsider.'), nl,
    write('If you are not prepared - prepare to run for your life!'), nl.

describe_aliens(shields):-
    write('You step cautiously into the shields room, but freeze as a pair of low, guttural growls emerges from the darkness.'), nl,
    write('Two alien figures shift in the shadows, their twisted forms barely visible in the dim, flickering lights.'), nl,
    write('Both turn towards you, hollow eyes reflecting a strange glint as they advance, their movements synchronized and predatory.'), nl,
    write('You lift whatever you have in hand, desperately hoping to hold them at bay. The aliens hesitate, momentarily recoiling, their limbs twitching as if repelled.'), nl,
    write('It’s only a brief reprieve, and you can feel the tension building—their hesitation won’t last.'), nl.
