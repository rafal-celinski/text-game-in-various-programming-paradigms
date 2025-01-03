Object subclass: Room [
    | name description neighbors isLocked lockReason items|

    Room class >> newRoom: aName description: aDescription neighbors: aDictionary isLocked: aLockState lockReason: aReason [
        ^self new
            setName: aName;
            setDescription: aDescription;
            setNeighbors: aDictionary;
            setIsLocked: aLockState;
            setLockReason: aReason;
            initializeItems
    ]

    initializeItems [
        items := OrderedCollection new.
    ]

    addItem: aItem [
        items add: aItem
    ]

    removeItem: anItem [
        items remove: anItem ifAbsent: [Transcript show: 'Can`t do it.'; cr]
    ]

    setName: aName [
        name := aName
    ]

    setDescription: aDescription [
        description := aDescription
    ]

    setNeighbors: aDictionary [
        neighbors := aDictionary
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
        ^neighbors
    ]

    isRoomLocked [
        ^isLocked
    ]

    getLockReason [
        ^lockReason
    ]
]