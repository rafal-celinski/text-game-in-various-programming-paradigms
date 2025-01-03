Object subclass: Game [
    | isGameOver rooms currentRoom roomData|

    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        rooms := OrderedCollection new.
        self setupRooms.
        currentRoom := (rooms copyFrom: 1 to: 6) atRandom.
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
        neighbors := roomInfo at: 2.
        descriptionMethodName := roomInfo at: 3.
        isLocked := roomInfo at: 4.
        lockReasonMethodName := roomInfo at: 5.

        room := Room newRoom: roomName
            description: (Texts perform: descriptionMethodName)
            neighbors: neighbors
            isLocked: isLocked
            lockReason: (Texts perform: lockReasonMethodName).
        rooms add: room.
    ].
]


    printCurrentRoom [
        | neighbors count |
        Texts printLines: currentRoom getDescription.
        Transcript show: 'Rooms: '.
        neighbors := currentRoom getNeighbors.
        count := 1.
        neighbors do: [:neighbor |
            Transcript show: neighbor.
            (count < neighbors size) ifTrue: [
                Transcript show: ', '.
            ].
            count := count + 1.
        ].
        Transcript cr.
    ]

    move: roomName [
        | nextRoom nextRoomName |
        nextRoomName := (currentRoom getNeighbors detect: [:neighbor | neighbor = roomName] ifNone: [nil]).
        nextRoomName ifNil: [
            Transcript show: 'You cannot go that way.'; cr.
            ^self
        ].
        nextRoom := rooms detect: [:room | room getName = nextRoomName] ifNone: [nil].
        nextRoom isRoomLocked ifTrue: [
            Texts printLines: nextRoom getLockReason.
            ^self
        ].
        currentRoom := nextRoom.
        self printCurrentRoom.
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
