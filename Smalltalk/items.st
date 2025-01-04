Object subclass: Item [
    | name description |

    Item class >> newItem: aName description: aDescription [
        ^ self new
            initializeItem: aName
            description: aDescription.
    ]

    initializeItem: aName description: aDescription [
        name := aName.
        description := aDescription.
        ^ self.
    ]

    getName [
        ^name.
    ]

    getDescription [
        ^description.
    ]
]