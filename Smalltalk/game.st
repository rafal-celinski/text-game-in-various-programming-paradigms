Object subclass: Game [
    | isGameOver rooms items objects currentRoom roomData itemsData objectsData holdingItems actionMap milestones|

    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        items := OrderedCollection new.
        rooms := OrderedCollection new.
        holdingItems := OrderedCollection new.
        objects := OrderedCollection new.
        actionMap := Dictionary new.
        milestones := OrderedCollection new.
        self setupRooms.
        self setupItems.
        self setupObjects.
        self setupActions.
        currentRoom := (rooms copyFrom: 1 to: 6) atRandom.
    ]

    getRoomByName: roomName [
        |room|
        room := rooms detect: [:r | r getName = roomName] ifNone: [nil].
        ^room

    ]

    getItemFromInventoryByName: itemName [
        |item|
        item := holdingItems detect: [:i | i getName = itemName] ifNone: [nil].
        ^item
    ]

    getItemByName: itemName [
        |item|
        item := items detect: [:i | i getName = itemName] ifNone: [nil].
        ^item
    ]

    getItemFromCurrentRoomByName: itemName [
        |item|
        item := currentRoom getItems detect: [:i | i getName = itemName] ifNone: [nil].
        ^item
    ]

    getObjectFromCurrentRoomByName: objectName [
        |object|
        object := currentRoom getObjects detect: [:i | i getName = objectName] ifNone: [nil].
        ^object
    ]

    getObjectByName: objectName [
        |object|
        object := objects detect: [:i | i getName = objectName] ifNone: [nil].
        ^object
    ]
 
   setupRooms [
    | roomName neighbors descriptionMethodName isLocked lockReasonMethodName description lockReason room |
    "single room data format"
    "name (neighbors) description isLocked reasonForLock"
    roomData := #(
        ('Reactor' #('Security' 'Lower Engine' 'Upper Engine') #reactorDescription false #emptyLockReason)
        ('Security' #('Reactor' 'Medbay') #securityDescription false #emptyLockReason)
        ('Medbay' #('Security') #medbayDescription false #emptyLockReason)
        ('Lower Engine' #('Electrical' 'Storage' 'Reactor') #lowerEngineDescription false #emptyLockReason)
        ('Storage' #('Electrical' 'Shields' 'Cafeteria' 'Lower Engine') #storageDescription false #emptyLockReason)
        ('Upper Engine' #('Reactor' 'Cafeteria') #upperEngineDescription false #emptyLockReason)
        ('Electrical' #('Lower Engine' 'Storage') #electricalDescription true #electricalLockReason)
        ('Shields' #('Storage' 'Oxygen' 'Navigation' 'Weapons') #shieldsWithAliensDescription true #v2AccessCardLockReason)
        ('Cafeteria' #('Upper Engine' 'Weapons' 'Admin Room' 'Storage') #cafeteriaWithAliensDescription false #emptyLockReason)
        ('Oxygen' #('Shields') #oxygenDescription false #emptyLockReason)
        ('Navigation' #('Shields') #navigationDescription true #navigationLockReason)
        ('Weapons' #('Cafeteria' 'Shields') #weaponsDescription true #v2AccessCardLockReason)
        ('Admin Room' #('Cafeteria') #adminRoomDescription false #emptyLockReason)
    ).

    roomData do: [:roomInfo |
        roomName := roomInfo at: 1.
        descriptionMethodName := roomInfo at: 3.
        isLocked := roomInfo at: 4.
        lockReasonMethodName := roomInfo at: 5.

        room := Room newRoom: roomName
            description: (Texts perform: descriptionMethodName)
            isLocked: isLocked
            lockReason: (Texts perform: lockReasonMethodName).
        rooms add: room.
    ].

    self setupNeighbours: roomData.
]

    setupNeighbours: aRoomData [
    aRoomData do: [:roomInfo |
        | roomName neighbors room neighborRoom |
        roomName := roomInfo at: 1.
        neighbors := roomInfo at: 2.
        room := self getRoomByName: roomName.
        room ifNotNil: [
            neighbors do: [:neighborName |
                neighborRoom := self getRoomByName: neighborName.
                neighborRoom ifNotNil: [
                    room addNeighbour: neighborRoom.
                ].
            ].
        ].
    ].
]


    setupItems [
        | itemName descriptionMethodName item chosenRoomName chosenRoom description roomNames validRoomsNames|
        "single item data format"
        "(name (possible spawn room) description)" 
        itemsData := #(
            ('encyclopedia' #('Reactor' 'Security' 'Medbay' 'Lower Engine' 'Storage' 'Upper Engine') #encyclopediaDescription)
            ('flashlight' #('Reactor' 'Security' 'Medbay' 'Lower Engine' 'Storage' 'Upper Engine') #flashlightDescription)
            ('wrench' #('Electrical') #wrenchDescription)
            ('plushie' #('Storage') #plushieDescription)
            ('empty canister' #('Storage') #emptyCanisterDescription)
            ('pokemon card' #('Storage') #pokemonCardDescription)
            ('petrol canister' #('Reactor' 'Lower Engine' 'Storage' 'Upper Engine') #petrolCanisterDescription)
            ('gas canister' #('Reactor' 'Lower Engine' 'Storage' 'Upper Engine') #gasCanisterDescription)
            ('rope' #('Storage') #ropeDescription)
            ('carton' #('Storage') #cartonDescription)
            ('lightbulbs' #('Storage') #lightbulbsDescription)
            ('shotgun' #('Weapons') #shotgunDescription)
            ('v1 access card' #('Reactor' 'Security' 'Medbay' 'Lower Engine' 'Storage' 'Upper Engine') #v1AccessCardDescription)
            ('v2 access card' #() #v2AccessCardDescription)
            ('medical report' #() #medicalReportDescription)
        ).

        itemsData do: [:itemData |
            itemName := itemData at: 1.
            validRoomsNames := itemData at: 2.
            descriptionMethodName := itemData at: 3.
            item := Item newItem: itemName 
                        description: (Texts perform: descriptionMethodName).
            items add: item.
            validRoomsNames isEmpty ifFalse: [
                chosenRoomName := validRoomsNames atRandom.
                chosenRoom := self getRoomByName: chosenRoomName.
                chosenRoom ifNotNil: [
                    chosenRoom addItem: item.
                ].
            ].
        ].
    ]

    setupObjects [
        |objectName spawnRoom descriptionMethodName isLockedStatus gameObject|
        "signle object data form"
        "name spawningRoom description isLocked lockReason"
        objectsData := #(
            ('gas engine' 'Upper Engine' #useGasEngineDescription false)
            ('petrol engine' 'Lower Engine' #usePetrolEngineDescription false)
            ('scanner' 'Medbay' #useScannerDescription true)
            ('cameras' 'Security' #cameraCafeteriaAndShields false)
            ('power breaker' 'Electrical' #usePowerBreakerDescription false)
            ('aliens' 'Shields' #emptyDescription false)
            ('aliens' 'Cafeteria' #emptyDescription false)
            ('admin panel' 'Admin Room' #useAdminPanelDescription true)
            ('pipe' 'Oxygen' #usePipeDescription false)
    ).

    objectsData do: [:objectData |
        objectName := objectData at: 1.
        spawnRoom := (self getRoomByName: (objectData at: 2)).
        descriptionMethodName := objectData at: 3.
        isLockedStatus := objectData at: 4.
        spawnRoom ifNotNil: [
            gameObject := GameObject newGameObject: objectName
                room: spawnRoom
                description: (Texts perform: descriptionMethodName)
                isLocked: isLockedStatus.
            spawnRoom addObject: gameObject.
            objects add: gameObject.
        ].
    ].
]

    printCurrentRoom [
        Transcript show: 'You are in ', currentRoom getName; cr.
        Texts printLines: currentRoom getDescription.
        Transcript show: 'Rooms: '.
        Texts printListinLine: (currentRoom getNeighbors).
        Transcript show: 'Items: '.
        Texts printListinLine: (currentRoom getItems).
        Transcript show: 'Objects: '.
        Texts printListinLine: (currentRoom getObjects).
    ]


    move: roomName [
        | nextRoom |
        nextRoom := currentRoom getNeighbors detect: [:room | (room getName) = roomName] ifNone: [nil].
        nextRoom ifNotNil: [
            nextRoom isRoomLocked ifTrue: [
                Texts printLines: nextRoom getLockReason.
                ^self
            ].
            currentRoom := nextRoom.
            self printCurrentRoom.
            ^self
        ].
        Transcript show: 'Can`t go there'; cr.
    ]

    pickUp: itemName [
        |item|
        item := self getItemFromCurrentRoomByName: itemName.
        item ifNotNil: [
            currentRoom removeItem: item.
            holdingItems add: item.
            Transcript show: 'Picked up ', (item getName); cr.
            ^self
        ].
        Transcript show: 'Can`t do that'; cr.
    ]

    listInventory [
        Transcript show: 'You are holding: '.
        Texts printListinLine: holdingItems.
    ]

    use: name [
        |interactiveObject|
        interactiveObject := self getItemFromInventoryByName: name.
        interactiveObject ifNotNil: [
            Transcript show: 'Using ', (interactiveObject getName); cr.
            Texts printLines: (interactiveObject getDescription).
            ^self
        ].
        interactiveObject := self getObjectFromCurrentRoomByName: name.
        interactiveObject ifNotNil: [
            Transcript show: 'Using ', (interactiveObject getName); cr.
            self performActionWith: nil on: name.
            ^self
        ].
        Transcript show: 'Invalid item or object specified'; cr.

    ]

    use: itemName on: objectName [
        | item object |
        item := self getItemFromInventoryByName: itemName.
        object := self getObjectFromCurrentRoomByName: objectName.
        (item notNil and: [object notNil]) ifTrue: [
            self performActionWith: itemName on: objectName.
        ] ifFalse: [
            Transcript show: 'Invalid item and object specified.'; cr.
        ].
]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    run [
        | cmd isUnknown commandParts item object|
        Texts printPlot.
        Texts printInstructions.
        self printCurrentRoom.
        [isGameOver] whileFalse: [

            isUnknown := true.
            cmd := self readCommand.

            (cmd startsWith: 'go to ') ifTrue: [
                isUnknown := false.
                self move: (cmd allButFirst: 6).
            ].

            (cmd startsWith: 'pick up ') ifTrue: [
                isUnknown := false.
                self pickUp: (cmd allButFirst: 8).
            ].

            (cmd startsWith: 'use ') ifTrue: [
                isUnknown := false.
                commandParts := (cmd allButFirst: 4) subStrings: ' '.
                (commandParts includes: 'on') ifTrue: [
                    item := ((commandParts copyFrom: 1 to: ((commandParts indexOf: 'on') - 1)) collect: [:each | each]) join: ' '.
                    object := ((commandParts copyFrom: ((commandParts indexOf: 'on') + 1) to: commandParts size) collect: [:each | each]) join: ' '.
                    self use: item on: object.
                ] ifFalse: [
                    item := (commandParts collect: [:each | each]) join: ' '.
                    self use: item.
                ].
            ].


            cmd = 'look up inventory' ifTrue: [
                isUnknown := false.
                self listInventory.
            ].

            cmd = 'look around' ifTrue: [
                isUnknown := false.
                self printCurrentRoom.
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false.
            ].

            cmd = 'instructions' ifTrue: [
                isUnknown := false.
                Texts printInstructions.
            ].
                
            isUnknown ifTrue: [
                Texts printLines: #('Unknown command.' '').
            ].
        ].
    ]

performActionWith: anItem on: anObject [
    | actionKey actionBlock |
    actionKey := { anItem. anObject }.
    actionBlock := actionMap at: actionKey ifAbsent: [ 
        Transcript show: 'Nothing happens.'; cr.
        ^self
    ].
    actionBlock value.
]


setupActions [
        actionMap
            at: { nil. 'cameras' } put: [ self useCameras ];
            at: { nil. 'gas engine' } put: [self useGasEngine];
            at: { nil. 'petrol engine' } put: [self usePetrolEngine];
            at: { nil. 'power breaker' } put: [self usePowerBreaker];
            at: { nil. 'scanner'} put: [self useScanner];
            at: { 'gas canister'. 'gas engine' } put: [self useGasCanisterOnGasEngine];
            at: { 'petrol canister'. 'petrol engine' } put: [self usePetrolCanisterOnPetrolEngine].
    ]

useCameras [
        |cameras|
        cameras := (self getObjectFromCurrentRoomByName: 'cameras').
        Texts printLines: (cameras getDescription).
        cameras setDescription: Texts cameraOffline.
        milestones add: 'cameras'
    ]

useGasEngine [
        |gasEngine|
        gasEngine := (self getObjectFromCurrentRoomByName: 'gas engine').
        Texts printLines: (gasEngine getDescription).
]

usePetrolEngine [
        |petrolEngine|
        petrolEngine := (self getObjectFromCurrentRoomByName: 'petrol engine').
        Texts printLines: (petrolEngine getDescription).
]

useGasCanisterOnGasEngine [
        |gasEngine gasCanister emptyCanister|
        gasEngine := (self getObjectFromCurrentRoomByName: 'gas engine').
        gasCanister := (self getItemFromInventoryByName: 'gas canister').
        emptyCanister := (self getItemByName: 'empty canister').

        holdingItems remove: gasCanister.
        holdingItems add: emptyCanister.
        milestones add: 'gas engine'.

        Texts printLines: Texts useGasCanisterOnGasEngineDescription.
        gasEngine setDescription: Texts gasEngineAfterRefuelDescription.
        self unlockElectrical.
]

usePetrolCanisterOnPetrolEngine [
        |petrolEngine petrolCanister emptyCanister|
        petrolEngine := (self getObjectFromCurrentRoomByName: 'petrol engine').
        petrolCanister := (self getItemFromInventoryByName: 'petrol canister').
        emptyCanister := (self getItemByName: 'empty canister').

        holdingItems remove: petrolCanister.
        holdingItems add: emptyCanister.
        milestones add: 'petrol engine'.

        Texts printLines: Texts usePetrolCanisterOnPetrolEngineDescription.
        petrolEngine setDescription: Texts petrolEngineAfterRefuelDescription.
        self unlockElectrical.

]

unlockElectrical [
        |electrical|
        ((milestones includes: 'gas engine') and: [milestones includes: 'petrol engine']) ifTrue: [
            electrical := (self getRoomByName: 'Electrical').
            electrical setIsLocked: false.
            Texts printLines: Texts unlockElectricalDescription. 
        ].
]

usePowerBreaker [
        |powerBreaker scanner|
        powerBreaker := (self getObjectFromCurrentRoomByName: 'power breaker').
        (milestones includes: 'power breaker') ifFalse: [   
            scanner := (self getObjectByName: 'scanner').

            Texts printLines: powerBreaker getDescription.

            milestones add: 'power breaker'.
            scanner setIsLocked: false.
            scanner setDescription: Texts unlockedScanner.
            powerBreaker setDescription: Texts usedPowerBreakerDescription.
        ] ifTrue: [
            Texts printLines: powerBreaker getDescription.
        ].
]

useScanner [
        |scanner medicalReport|
        scanner := (self getObjectByName: 'scanner').
        (scanner getIsLocked) ifTrue: [
            Texts printLines: scanner getDescription.
            ^self
        ].
        (milestones includes: 'scanner') ifFalse: [
            medicalReport := (self getItemByName: 'medical report').
            Texts printLines: scanner getDescription.
            milestones add: 'scanner'.
            holdingItems add: medicalReport.
            scanner setDescription: Texts usedScannerDescription.
    ] ifTrue: [
        Texts printLines: scanner getDescription.
    ]
]

]

Game new run.