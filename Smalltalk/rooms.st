Object subclass: Room [
    | name description neighbours isLocked lockReason items objects|

    Room class >> newRoom: aName description: aDescription isLocked: aLockState lockReason: aReason [
        ^self new
            setName: aName;
            setDescription: aDescription;
            setIsLocked: aLockState;
            setLockReason: aReason;
            initializeItems;
            initializeObjects;
            initializeNeighbours.
    ]

    initializeObjects [
        objects := OrderedCollection new.
    ]

    initializeItems [
        items := OrderedCollection new.
    ]

    initializeNeighbours [
        neighbours := OrderedCollection new.
    ]

    addNeighbour: aNeighbour [
        neighbours add: aNeighbour
    ]

    addObject: anObject [
        objects add: anObject
    ]

    addItem: aItem [
        items add: aItem
    ]

    removeItem: anItem [
        items remove: anItem
    ]

    removeObject: anObject [
        objects remove: anObject
    ]

    setName: aName [
        name := aName
    ]

    setDescription: aDescription [
        description := aDescription
    ]

    setIsLocked: aLockState [
        isLocked := aLockState
    ]

    setLockReason: aReason [
        lockReason := aReason
    ]

    getName [
        ^name
    ]

    getItems [
        ^items
    ]

    getDescription [
        ^description
    ]

    getNeighbors [
        ^neighbours
    ]

    isRoomLocked [
        ^isLocked
    ]

    getLockReason [
        ^lockReason
    ]

    getObjects [
        ^objects
    ]
]