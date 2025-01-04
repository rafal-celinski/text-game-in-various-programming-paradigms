Object subclass: GameObject [
    | name description isLocked room|

    GameObject class >> newGameObject: aName room: aRoom description: aDescription isLocked: anLockStatus [
    ^self new
        setName: aName;
        setRoom: aRoom;
        setDescription: aDescription;
        setIsLocked: anLockStatus.
    ]


    setDescription: aDescription [
        description := aDescription.
    ]

    setIsLocked: anLockStatus [
        isLocked := anLockStatus.
    ]

    setName: aName [
        name := aName. 
    ]

    setRoom: aRoom [
        room := aRoom.
    ]

    getDescription [
        ^description
    ]

    getName [
        ^name
    ]

    getRoom [
        ^room
    ]

    getIsLocked [
        ^isLocked
    ]
]