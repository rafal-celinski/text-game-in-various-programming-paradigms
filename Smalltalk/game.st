Object subclass: Game [
    | isGameOver rooms items currentRoom roomData itemsData holdingItems|

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
        self setupRooms.
        self setupItems.
        currentRoom := (rooms copyFrom: 1 to: 6) atRandom.
    ]

    getRoomByName: roomName [
        |room|
        room := rooms detect: [:r | r getName = roomName] ifNone: [nil].
        ^room

    ]

    getItemFromCurrentRoomByName: itemName [
        |item|
        item := currentRoom getItems detect: [:i | i getName = itemName] ifNone: [nil].
        ^item
    ]

   setupRooms [
    | roomName neighbors descriptionMethodName isLocked lockReasonMethodName description lockReason room |
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


    printCurrentRoom [
        | neighbors count itemsInRoom|
        Transcript show: 'You are in ', currentRoom getName; cr.
        Texts printLines: currentRoom getDescription.
        Transcript show: 'Rooms: '.
        neighbors := currentRoom getNeighbors.
        Texts printListinLine: neighbors.
        Transcript show: 'Items: '.
        itemsInRoom := currentRoom getItems.
        Texts printListinLine: itemsInRoom.
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


    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    run [
        | cmd isUnknown |
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
            ]
        ]
    ]
]

Game new run.
