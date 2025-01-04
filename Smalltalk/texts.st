Object subclass: Texts [
    Texts class >> new [
        | t |
        t := super new.
        ^t
    ]

    instructionsText := #(
        ''
        'Instructions'
        'To see this message again write ''instructions''.'
        'quit - quits the game.'
        'look around - lets you look around the room you are currently in and see potential ways to interact with the environment.'
        'go to [place] - use it to move around the ship.'
        'pick up [item] - pick up an item.'
        'look up inventory - list items you currently possess.'
        'use [item] on [object] - you can use some of the items to accomplish many things.'
        'use [item/object] - use things that don''t have a specific target.'
        'For better understanding of the last two commands, we will look at the example below:'
        'If you want to destroy the door with the bat, you should write ''use bat on door,'' but if you wanted to turn on the flashlight, you would write ''use flashlight''.'
        'Simple, right?'
        ''
    ).


    plotText := #(
        ''
        'Welcome to "Escape from the Spaceship"'
        ''
        'It''s the year 2124, humanity stands on the brink of a new era of discovery.'
        'The research ship Nova Explorer sets out in search of exotic life forms and resources on uncharted planets.'
        'However, during the mission, everything goes horribly wrong.'
        'An alien life form encountered in deep space becomes a grave threat to the crew.'
        'Without warning, the team was attacked, plunging the ship into chaos.'
        'Now, with systems failing and the lives of your companions at stake, you must find a way to eliminate the problem.'
        ''
        'Before the attack, the ship''s captain briefed you on the emergency protocols.'
        'To reach the navigation room - a safe point, or armory where weapons are stored, you must first obtain a higher-level access card.'
        'To acquire this card, you need to gather critical medical research data about yourself from the medbay.'
        'With that and v1_access_card, you need to head to the admin room to enhance your access privileges.'
        'Unfortunately, the rest of the crew is either dead or trapped in the navigation room with no way to escape.'
        'It’s up to you to confront the aliens and eliminate the threat to your survival.'
        'Your ultimate goal is to eliminate the threat, cleanse the ship from potential contamination, and free the rest of the crew.'
        ''
    ).

    Texts class >> printListinLine: anArray [
        |count|
        count := 1.
        anArray do: [ :element |
            Transcript show: (element getName).
            (count < anArray size) ifTrue: [
                Transcript show: ', '.
            ].
            count := count + 1.
        ].
        Transcript cr.
    ]
    
    Texts class >> printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    Texts class >> printPlot [
        self printLines: plotText.
    ]

    Texts class >> printInstructions [
        self printLines: instructionsText.
    ]

    Texts class >> reactorDescription [
        ^#(
            'The reactor room hums with an intense energy, the core pulsing with an eerie glow.'
            'Pipes and machinery line the walls, and the room feels both hot and tense.'
        ).
    ]

    Texts class >> upperEngineDescription [
        ^#(
            'The upper engine is loud and shrouded in mist from coolant leaks.'
            'Lights flicker as the engine roars, echoing through the metal corridors.'
        ).
    ]

    Texts class >> lowerEngineDescription [
        ^#(
            'The lower engine room is dimly lit, with heavy machinery vibrating beneath the floors.'
            'You feel the ship’s heartbeat here, deep and resonant.'
        ).
    ]

    Texts class >> securityDescription [
        ^#(
            'The security room is filled with screens showing feeds from various parts of the ship.'
            'There is a sense of unease as you realize some cameras are dead.'
        ).
    ]

    Texts class >> medbayDescription [
        ^#(
            'The medbay is lined with medical equipment, most of it still functional.'
            'An overturned stretcher lies nearby, and the smell of antiseptic lingers.'
        ).
    ]

    Texts class >> electricalDescription [
        ^#(
            'The electrical room is dark, with sparking wires and buzzing panels lining the walls.'
            'You can feel the static in the air, and caution is essential here.'
        ).
    ]

    Texts class >> cafeteriaWithAliensDescription [
            ^#(
                'You step into the dimly lit room, and a chill immediately runs down your spine.'
                'Figures stand scattered across the room, moving with a strange, unnatural grace.'
                'At first glance, they look like members of your crew, but as they turn toward you,'
                'you notice their eyes: empty, hollow, and unblinking, devoid of any humanity.'
                'Their movements are jerky, almost as if they’re struggling to control the forms they’ve taken.'
                'A faint, low hiss fills the air as they begin to advance, recognizing you as an outsider.'
                'If you are not prepared - prepare to run for your life!'
            ).
    ]

    Texts class >> cafeteriaDescription [ 
            ^#(
                'Long tables and empty food trays fill the cafeteria, once bustling with crew.'
                'The silence is unsettling, and a faint aroma of old food still lingers.'
            ).
    ]
    

    Texts class >> storageDescription [
        ^#(
            'Storage is cluttered with crates and containers, all labeled with various supplies.'
            'It’s cramped and shadowy, making it hard to see what might be hiding here.'
        ).
    ]

    Texts class >> weaponsDescription [
        ^#(
            'The weapons room is locked behind a reinforced door, a small armory for the crew.'
            'Inside, you see racks of secured weapons awaiting authorization.'
        ).
    ]

    Texts class >> oxygenDescription [
        ^#(
            'The oxygen room houses the life support systems, vital for air circulation.'
            'There’s a soft whirring of fans, but a warning light flashes ominously.'
        ).
    ]

    Texts class >> navigationDescription [
        ^#(
            'The navigation room is lined with monitors displaying star charts and coordinates, softly glowing in the dim light.'
            'This is the heart of the ship’s control, a designated safe point in times of emergency.'
        ).
    ]

    Texts class >> shieldsWithAliensDescription [
            ^#(
                'You step cautiously into the shields room, but freeze as a pair of low, guttural growls emerges from the darkness.'
                'Two alien figures shift in the shadows, their twisted forms barely visible in the dim, flickering lights.'
                'Both turn towards you, hollow eyes reflecting a strange glint as they advance, their movements synchronized and predatory.'
                'You lift whatever you have in hand, desperately hoping to hold them at bay. The aliens hesitate, momentarily recoiling, their limbs twitching as if repelled.'
                'It’s only a brief reprieve, and you can feel the tension building—their hesitation won’t last.'
            ).
    ]

    Texts class >> shieldsDescriptions [
            ^#(
                'Shield generators hum softly here, their power keeping the ship protected in space.'
                'However, flickering lights suggest something isn’t working quite right.'
            ).
    ]
    

    Texts class >> adminRoomDescription [
        ^#(
            'The administration room is filled with terminals and data consoles.'
            'This is where important authorizations are made, and the captain’s log rests nearby.'
        ).
    ]

    Texts class >> emptyLockReason [
        ^#('').
    ]

    Texts class >> emptyDescription [
        ^#('').
    ]


    Texts class >> electricalLockReason [
        ^#('You try to open the door to the electrical room, but it doesn’t budge.'
        'A warning on the control panel reads: "Refuel both engines to stabilize power distribution."'
        'It seems that the electrical room’s power systems are reliant on fully fueled engines.'
        'And once again you must think of something. Where could the spare fuel be stored?').
    ]

    Texts class >> v2AccessCardLockReason [
        ^#('You need v2_access_card to access this room').
    ]

    Texts class >> lockedAdminPanelDescription [
        ^#(
            'In front of you is the administration panel, the crew management center on the spaceship.'
            'This is where you coordinate the activities of individual crew members,'
            'assign tasks, monitor their health and morale, ensuring that everyone knows their place and role in this interstellar journey.'
            'To use it, you need to authenticate using your access_card.'
        ).
    ]

    Texts class >> unlockedAdminPanelDescription [
        ^#(
        'The administrative panel displays alarming data: two crew members are deceased, while four survivors sit in the navigation room,'
        'their stress levels visibly elevated. The emergency mode is active, and the crew`s health indicators flash red, signaling a critical situation.'
        'The activity log shows their recent attempts at coordination.'
        ).
    ]

    Texts class >> scannerLockReason [
        ^#('The medbay scanner sits dormant, its screen blank and unresponsive due to an electrical shortage.'
           'Maybe checking electrical room will let you progress. If you recall corectly it was located near lower engines').
    ]

    Texts class >> navigationLockReason [
        ^#('You need to eliminate every threat on the ship to open this door.'
        'Don''t forget about v2_access_card. Without it system won''t let you in.')
    ]

    Texts class >> encyclopediaDescription [
    ^#(
        'A thick, well-worn encyclopedia filled with pages of knowledge.'
        'It seems to cover a wide variety of topics, though much of it looks outdated.'
        'Perhaps some of the information could still prove useful.'
    ).
    ]

    Texts class >> flashlightDescription [
    ^#(
        'A sturdy flashlight with a slightly scratched lens.'
        'It flickers occasionally, but it still casts a bright beam.'
        'This could be invaluable in the darker parts of the ship.'
    ).
    ]

    Texts class >> unlockedScanner [
        ^#('You have aquired medical report. Go to admin room with v1_access card to upgrade it.').
    ]

    Texts class >> wrenchDescription [
        ^#(
            'A heavy-duty wrench, its surface marred with grease and scratches.'
            'It looks like it could tighten bolts—or fend off an unwelcome threat.'
        ).
    ]

    Texts class >> plushieDescription [
        ^#(
            'A small, soft plushie that resembles a cartoon character.'
            'It’s a bit worn but still exudes a sense of comfort and nostalgia.'
            'Why was this left behind?'
        ).
    ]

    Texts class >> emptyCanisterDescription [
        ^#(
            'An empty metal canister, its interior spotless.'
            'It might be used to transport something, but right now it’s useless.'
        ).
    ]

    Texts class >> pokemonCardDescription [
        ^#(
            'A rare collectible card featuring a powerful Pokémon.'
            'Its edges are slightly bent, but the artwork is pristine.'
            'Someone must have treasured this dearly.'
        ).
    ]

    Texts class >> petrolCanisterDescription [
        ^#(
            'A sturdy canister filled with petrol, its weight evident when lifted.'
            'The smell of fuel wafts faintly from the seal.'
            'It’s clearly meant for use in the ship’s engines.'
        ).
    ]

    Texts class >> gasCanisterDescription [
        ^#(
            'A pressurized gas canister with warning labels plastered across its surface.'
            'The contents could be dangerous if mishandled.'
            'It must serve some specific purpose aboard the ship.'
        ).
    ]

    Texts class >> ropeDescription [
        ^#(
            'A coil of strong, durable rope.'
            'It looks like it’s been used before, but it remains sturdy and reliable.'
            'This could come in handy for securing or climbing.'
        ).
    ]

    Texts class >> cartonDescription [
        ^#(
            'A simple cardboard carton, slightly crushed on one side.'
            'It’s empty now, but it could potentially hold something useful.'
        ).
    ]

    Texts class >> lightbulbsDescription [
        ^#(
            'A small box of replacement lightbulbs, carefully packed to prevent breakage.'
            'These could brighten the darkest corners of the ship.'
        ).
    ]

    Texts class >> shotgunDescription [
        ^#(
            'A powerful shotgun with a polished barrel and a faint scent of gunpowder.'
            'It feels solid in your hands, ready to defend against any threat.'
            'This is a weapon of last resort.'
        ).
    ]

    Texts class >> v1AccessCardDescription [
        ^#(
            'A sleek plastic card marked "V1 Access".'
            'It looks like it’s used for accessing restricted areas of the ship.'
            'Without it, some doors will remain firmly shut.'
        ).
    ]

    Texts class >> v2AccessCardDescription [
        ^#(
            'An advanced security card marked "V2 Access".'
            'It’s pristine and clearly intended for high-level clearance.'
            'Few doors aboard the ship could resist this key.'
        ).
    ]

    Texts class >> medicalReportDescription [
        ^#(
            'A detailed medical report, filled with diagrams and data entries.'
            'It chronicles the health of a crew member, but the name has been redacted.'
            'The implications of the data might be unsettling.'
        ).
    ]

    Texts class >> cameraCafeteriaAndShields [
        ^#(
            'You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.'
            'In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...'
            '...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.'
            'The camera feed in the shields room shows another one of these impostors prowling near the shield generators, its form disturbingly familiar.'
            'Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.'
            'The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.'
            'In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever.'
        ).
    ]

    Texts class >> cameraCafeteriaOnly [
        ^#(
            'You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.'
            'In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...'
            '...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.'
            'Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.'
            'The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.'
            'In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever.'
        ).
    ]

    Texts class >> cameraShieldsOnly [
        ^#(
            'You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.'
            'The camera feed in the shields room shows one of the aliens prowling near the shield generators, its form disturbingly familiar.'
            'Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.'
            'The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.'
            'In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever.'
        ).
    ]

    Texts class >> cameraAllClear [
        ^#(
            'The camera feeds flicker to life, displaying a quiet stillness that has returned to the ship.'
            'The cafeteria sits empty, tables undisturbed and lights humming softly.'
            'A calm has settled over the corridors, where only the gentle pulsing of the ship’s systems remains.'
            'For a moment, there’s a strange sense of peace... until a faint electric crackle disrupts the silence.'
            'The screens flicker one last time, then slowly fade to black. Whatever happened here, it’s finally over.'
        ).
    ]

    Texts class >> cameraOffline [
        ^#(
            'You attempt to activate the cameras, but all the screens remain blank.'
            'A faint hum of power is the only indication that the system is even operational.'
            'Whatever caused the failure, it’s complete. The cameras are offline, leaving you in the dark.'
        ).
    ]

    Texts class >> useScannerDescription [
        ^#(
            'The medbay scanner sits dormant, its screen blank and unresponsive due to an electrical shortage.'
            'Maybe checking electrical room will let you progress. If you recall correctly, it was located near lower engines.'
        ).
    ]

    Texts class >> usePowerBreakerDescription [
        ^#(
            'A sturdy power breaker is mounted on the wall, labeled "Medbay Power Supply."'
            'It seems switched off, likely the cause of the scanner’s malfunction.'
            'You try pulling the lever to restore power to the medbay.'
            'It worked. Finally no sad surprises...'
            'At least for now...'
        ).
    ]

    Texts class >> usedPowerBreakerDescription [
        ^#(
            'Everything seems working fine. Power in medbay should be restored.'
        ).
    ]

    Texts class >> usedScannerDescription [
        ^#(
            'Don''t waste time. You already did that.'
        ).
    ]

    Texts class >> useGasEngineDescription [
        ^#(
            'The gas engine provides power for the entire ship.'
        ).
    ]

    Texts class >> gasEngineAfterRefuelDescription [
        ^#(
            'The gas engine provides power for the entire ship. Now it`s refueld and you can hear it working clearly.'
        ).
    ]

    Texts class >> useGasCanisterOnGasEngineDescription [
        ^#(
            'You connect the gas canister to the right engine. The gauge stabilizes, indicating full fuel.'
        ).
    ]

    Texts class >> usePetrolEngineDescription [
        ^#(
            'The petrol engine provides power for the entire ship.'
        ).
    ]

    Texts class >> usePipeDescription [
        ^#(
            'A sturdy metal pipe runs along the wall, but near one of the joints, a crack has started to leak oxygen in faint, rhythmic hisses.'
            'The crack is surrounded by a series of loose bolts and fittings that hold the pipe’s sections together.'
            'With a wrench, you might be able to tighten the joints and secure the connection enough to stop the leak temporarily.'
        ).
    ]

    Texts class >> useFlashlightOnAliensDescription [
        ^#(
            'You flick on the flashlight, pointing it directly at the alien figures before you.'
            'The intense beam pierces through the darkness, and the creatures recoil, their hollow eyes blinking and limbs twitching in confusion.'
            'They stagger back, momentarily stunned and disoriented by the powerful light.'
            'It won’t hold them for long, but you have a chance to move or attack while they’re blinded.'
        ).
    ]

    Texts class >> useShotgunOnAliensDescription [
        ^#(
            'You raise the shotgun, heart pounding as you take aim at the alien figures.'
            'With a deafening blast, the shotgun kicks against your shoulder, the recoil intense but satisfying.'
            'The alien creatures stagger, their hollow eyes widening just before they collapse in twisted, unnatural heaps on the floor.'
            'Their forms begin to dissolve, revealing something even stranger beneath – twisted, sinewy masses that vaguely resemble what once might have been living beings.'
        ).
    ]

    Texts class >> useMedicalReportOnAdminPanelDescription [
        ^#(
            'Your medical report flashes on the screen, confirming that you are indeed human.'
            'As the information sinks in, a new message appears, offering a glimmer of hope.'
            'In case of emergency, you are granted a higher-level access card, allowing you to unlock more secure areas of the ship.'
            'As you obtain the higher-level access card, an alarm suddenly blares through the ship.'
            '"Warning! Oxygen levels critical. Immediate repair needed to maintain safe breathing conditions."'
            'The system message echoes ominously, sending a chill down your spine.'
            'To reach the oxygen installations, you will need to pass through storage and shields. The path won’t be easy...'
        ).
    ]

    Texts class >> useCardOnAdminPanelDescription [
        ^#(
            'Your access card hums softly as it validates your credentials, granting you a fleeting moment of control.'
            'With the system poised for your commands, you can execute one critical operation before the terminal locks out once more.'
        ).
    ]

    Texts class >> youNeedToUnlockPanelDescription [
        ^#('To use it, you need to authenticate using your access_card.').
    ]

    Texts class >> alreadyUnlockedPanelDescription [
        ^#(
            'You already unlocked admin panel. Try doing something with it'
        ).
    ]

    Texts class >> unlockElectricalDescription [
        ^#(
            'You managed to unlock Electrical'
        ).
    ]

    Texts class >> petrolEngineAfterRefuelDescription [
        ^#(
            'The petrol engine provides power for the entire ship. After refuelling you can feel the engine`s vibrations'
        ).
    ]

    Texts class >> usePetrolCanisterOnPetrolEngineDescription [
        ^#(
            'You carefully pour the petrol into the left engine. The fuel gauge rises to full!'
        ).
    ]

]