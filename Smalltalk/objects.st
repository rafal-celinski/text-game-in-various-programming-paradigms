Object subclass: GameObject [
    | name description isLocked |

    GameObject class >> newGameObject: aName description: aDescription isLocked: anLockStatus [
    ^self new
        setName: aName;
        setDescription: aDescription;
        setIsLocked: anLockStatus.
    ]

    setName: aName [
        name := aName.
    ]
    setDescription: aDescription [
        description := aDescription.
    ]

    setIsLocked: anLockStatus [
        isLocked := anLockStatus.
    ]


    getDescription [
        ^description
    ]

    getName [
        ^name
    ]

    getIsLocked [
        ^isLocked
    ]
]