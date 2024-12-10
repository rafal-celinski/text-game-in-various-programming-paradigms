import Data.List (intercalate)
import System.Random (randomRIO)
import System.IO (hFlush, stdout)
import Control.Monad (when)
import Data.Maybe (listToMaybe)
import Data.List (delete)


type Room = String
type Item = String
type Object = String
type Unlocked = Bool
type Milestone = String


data GameState = GameState {
    currentRoom :: Room,
    holding :: [Item],
    items :: [(Item, Room)],
    objects :: [(Object, Room, Unlocked)],
    milestones :: [Milestone],
    roomsStates :: [(Room, Unlocked)]
}


rooms :: [(Room, [Room])]
rooms = [
    ("Reactor", ["Security", "Lower Engine", "Upper Engine"]),
    ("Security", ["Reactor", "Medbay"]),
    ("Medbay", ["Security"]),
    ("Lower Engine", ["Electrical", "Storage", "Reactor"]),
    ("Storage", ["Electrical", "Shields", "Cafeteria", "Lower Engine"]),
    ("Upper Engine", ["Reactor", "Cafeteria"]),
    ("Electrical", ["Lower Engine", "Storage"]),
    ("Shields", ["Storage", "Oxygen", "Navigation", "Weapons"]),
    ("Cafeteria", ["Upper Engine", "Weapons", "Admin Room", "Storage"]),
    ("Oxygen", ["Shields"]),
    ("Navigation", ["Shields"]),
    ("Weapons", ["Cafeteria", "Shields"]),
    ("Admin Room", ["Cafeteria"])]


startRooms :: [Room]
startRooms = [
    "Reactor", 
    "Security", 
    "Medbay", 
    "Lower Engine", 
    "Storage", 
    "Upper Engine"]


initialRoomsStates :: [(Room, Unlocked)]
initialRoomsStates = [
    ("Reactor", True),
    ("Security", True),
    ("Medbay", True),
    ("Lower Engine", True),
    ("Storage", True),
    ("Upper Engine", True),
    ("Electrical", False),
    ("Shields", True),
    ("Cafeteria", True),
    ("Oxygen", True),
    ("Navigation", True),
    ("Weapons", True),
    ("Admin Room", True)]


initialItems :: [(Item, [Room])]
initialItems = [
    ("encyclopedia", startRooms),
    ("flashlight", startRooms),
    ("wrench", ["Electrical"]),
    ("plushie", ["Storage"]),
    ("empty canister", ["Storage"]),
    ("pokemon card", ["Storage"]),
    ("petrol canister", ["Reactor", "Lower Engine", "Storage", "Upper Engine"]),
    ("gas canister", ["Reactor", "Lower Engine", "Storage", "Upper Engine"]),
    ("rope", ["Storage"]),
    ("carton", ["Storage"]),
    ("lightbulbs", ["Storage"]),
    ("shotgun", ["Weapons"]),
    ("v1 access card", startRooms),
    ("v2 access card", []),
    ("medical raport", [])]


initialObjects :: [(Object, Room, Unlocked)]
initialObjects = [
    ("gas engine", "Upper Engine", True),
    ("petrol engine", "Lower Engine", True),
    ("scanner", "Medbay", False),
    ("cameras", "Security", True),
    ("power breaker", "Electrical", True),
    ("aliens", "Shields", True),
    ("aliens", "Cafeteria", True),
    ("admin panel", "Admin Room", False),
    ("pipe", "Oxygen", True)]


randomizeItemLocation :: [(Item, [Room])] -> IO [(Item, Room)]
randomizeItemLocation [] = return []
randomizeItemLocation ((item, rooms):xs) = do
    room <- if null rooms
            then return ""
            else do 
                idx <- randomRIO (0, length rooms - 1)
                return (rooms !! idx)
    rest <- randomizeItemLocation xs
    return ((item, room): rest)


generateGameState :: IO GameState
generateGameState = do
    items <- randomizeItemLocation initialItems
    idx <- randomRIO (0, length startRooms - 1)
    startRoom <- return (startRooms !! idx)
    return GameState {
        currentRoom = startRoom,
        holding = [],
        items = items,
        objects = initialObjects,
        milestones = [],
        roomsStates = initialRoomsStates
    }


goTo :: Room -> GameState -> IO GameState
goTo room state = do
    if roomUnlocked then do
        let newState = move room state
        lookAround newState
        return newState
    else do
        printRoomLocked room
        return state
    where
        roomUnlocked = maybe False id $ listToMaybe [unlocked | (r, unlocked) <- roomsStates state, r == room]
        



move :: Room -> GameState -> GameState
move targetRoom state =
    if targetRoom `elem` neighbors
    then state { currentRoom = targetRoom}
    else state
  where
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []


pick :: Item -> GameState -> IO GameState
pick targetItem state = do
    if targetItem `elem` itemsInRoom
    then return state {
        holding = targetItem : holding state,
        items = [(item, if item == targetItem then "" else room) | (item, room) <- items state]
    }
    else do
        printLines["You can't pick it up"]
        return state
    where
        itemsInRoom = [item | (item, room) <- items state, room == currentRoom state]


addMilestone :: Milestone -> GameState -> GameState
addMilestone milestone state = state {milestones = (milestones state ++ [milestone])}

addItem :: Item -> GameState ->  GameState
addItem item state = state {holding = (holding state ++ [item])}

deleteItem :: Item -> GameState -> GameState
deleteItem item state = state {holding = delete item (holding state)}

unlockRoom :: Room -> GameState -> GameState
unlockRoom room state = state {roomsStates = updatedRoomsStates}
    where
        updatedRoomsStates = [(r, if r == room then True else s) | (r, s) <- roomsStates state]

objectInRoom :: Object -> Room -> GameState -> Bool
objectInRoom object room state = object `elem` [obj | (obj, r, _) <- objects state, r == room]

setObjectUnlockedInRoom :: Object -> Room -> Unlocked -> GameState -> GameState
setObjectUnlockedInRoom object room unlocked state = state {objects = updatedObjects}
    where
        updatedObjects = [(obj, r, if obj == object && r == room then unlocked else oldUnlocked) | (obj, r, oldUnlocked) <- objects state]


setObjectUnlocked :: Object -> Unlocked -> GameState -> GameState
setObjectUnlocked object unlocked state = state {objects = updatedObjects}
    where
        updatedObjects = [(obj, r, if obj == object then unlocked else oldUnlocked) | (obj, r, oldUnlocked) <- objects state]
        

useObject :: Object -> GameState -> IO GameState
useObject object state = do
    newState <- case object of
        "cameras" -> do useCameras objectUnlocked state
        "scanner" -> do useScanner objectUnlocked state
        "power breaker" -> do usePowerBreaker objectUnlocked state
        "gas engine" -> do useGasEngine objectUnlocked state
        "petrol engine" -> do usePetrolEngine objectUnlocked state
        "admin panel" -> do useAdminPanel objectUnlocked state
        "pipe" -> do usePipe objectUnlocked state
        _ -> do printLines ["You can't do that"] >> return state
    return newState
    where
        objectUnlocked = maybe False id $ listToMaybe [unlocked | (obj, _, unlocked) <- objects state, obj == object]


useCameras :: Unlocked -> GameState -> IO GameState
useCameras unlocked state = do
    if unlocked then do
        if aliensInCafeteria && aliensInShields then
            printLines [
                "You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.", 
                "In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...", 
                "...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.", 
                "The camera feed in the shields room shows another one of these impostors prowling near the shield generators, its form disturbingly familiar.", 
                "Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.", 
                "The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.", 
                "In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever."]
        else if aliensInCafeteria then    
            printLines[
                "You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.", 
                "In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...", 
                "...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.", 
                "Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.", 
                "The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.')", 
                "In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever."]
        else if aliensInShields then
            printLines [
                "You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.", 
                "The camera feed in the shields room shows one of the aliens prowling near the shield generators, its form disturbingly familiar.", 
                "Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.", 
                "The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.", 
                "In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever."]
        else
            printLines[
                "The camera feeds flicker to life, displaying a quiet stillness that has returned to the ship.",
                "The cafeteria sits empty, tables undisturbed and lights humming softly.", 
                "A calm has settled over the corridors, where only the gentle pulsing of the ship’s systems remains.", 
                "For a moment, there’s a strange sense of peace... until a faint electric crackle disrupts the silence.", 
                "The screens flicker one last time, then slowly fade to black. Whatever happened here, it’s finally over."]
        let newState = setObjectUnlocked "cameras" False state    
        return newState
    else do
        printLines ["Only thing you can see is your mirrored image on the black screen."]
        return state
    where
        aliensInCafeteria = objectInRoom "aliens" "Cafeteria" state
        aliensInShields = objectInRoom "aliens" "Shields" state


useScanner :: Unlocked -> GameState -> IO GameState
useScanner unlocked state = do
    if unlocked then do
        if "scanner" `elem` milestones state then do
            printLines ["Don't waste time. You already did that."]
            return state
        else do
            printLines ["You have aquired medical report. Go to admin room with v1_access card to upgrade it."]
            let newState = addMilestone "scanner" $ addItem "medical report" state
            return newState
    else do
        printLines [
            "The medbay scanner sits dormant, its screen blank and unresponsive due to an electrical shortage.",
            "Maybe checking electrical room will let you progress. If you recall corectly it was located near lower engines"]
        return state


usePowerBreaker :: Unlocked -> GameState -> IO GameState
usePowerBreaker unlocked state = do
    if "power breaker" `elem` milestones state then do
        printLines ["Everything seems working fine. Power in medbay should be restored."]
        return state
    else do
        printLines [
            "A sturdy power breaker is mounted on the wall, labeled \"Medbay Power Supply.\"",
            "It seems switched off, likely the cause of the scanner’s malfunction.",
            "You try pulling the lever to restore power to the medbay.",
            "It worked. Finally no sad surprises...",
            "At least for now..."]
        let newState = addMilestone "power breaker" $ setObjectUnlocked "scanner" True state
        return newState

useGasEngine :: Unlocked -> GameState -> IO GameState
useGasEngine unlocked state = do
    printLines ["The gas engine provides power for the entire ship"]
    return state

usePetrolEngine :: Unlocked -> GameState -> IO GameState
usePetrolEngine unlocked state = do
    printLines ["The petrol engine provides power for the entire ship"]
    return state

useAdminPanel :: Unlocked -> GameState -> IO GameState
useAdminPanel unlocked state = do
    if unlocked then do
        printLines [
            "The administrative panel displays alarming data: two crew members are deceased, while four survivors sit in the navigation room,",
            "their stress levels visibly elevated. The emergency mode is active, and the crew's health indicators flash red, signaling a critical situation.",
            "The activity log shows their recent attempts at coordination."]
        let newState = setObjectUnlocked "admin panel" False state
        return newState

    else do
        printLines [
            "In front of you is the administration panel, the crew management center on the spaceship.",
            "This is where you coordinate the activities of individual crew members,",
            "assign tasks, monitor their health and morale, ensuring that everyone knows their place and role in this interstellar journey.",
            "To use it, you need to authenticate using your access_card."]
        return state

usePipe :: Unlocked -> GameState -> IO GameState
usePipe unlocked state = do
    if "pipe" `elem` milestones state then do
        printLines ["Now it looks way better."]
        return state
    else do
        printLines [
            "A sturdy metal pipe runs along the wall, but near one of the joints, a crack has started to leak oxygen in faint, rhythmic hisses.",
            "The crack is surrounded by a series of loose bolts and fittings that hold the pipe’s sections together.",
            "With a wrench, you might be able to tighten the joints and secure the connection enough to stop the leak temporarily."]
        return state


readCommand :: IO String
readCommand = do
    putStr "> "
    hFlush stdout
    xs <- getLine
    return xs


printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)


lookAround :: GameState -> IO ()
lookAround state = do
    printLines ["You are in " ++ currentRoom state, ""]
    printRoomInfo (currentRoom state)
    printLines ["", "You can go to: " ++ intercalate(", ") neighbors]
    when (length itemsInRoom > 0) $
        printLines ["There are many items around: " ++ intercalate(", ") itemsInRoom]
    when (length objectsInRoom > 0 ) $
        printLines ["You can use: " ++ intercalate(", ") objectsInRoom]
    where
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []
    itemsInRoom = [item | (item, room) <- items state, room == currentRoom state]
    objectsInRoom = [object | (object, room, _) <- objects state, room == currentRoom state]


printRoomInfo :: Room -> IO ()
printRoomInfo room = do
    case room of
        "Reactor" -> printLines [
            "The reactor room hums with an intense energy, the core pulsing with an eerie glow.",
            "Pipes and machinery line the walls, and the room feels both hot and tense."]
        "Upper Engine" -> printLines [
            "The upper engine is loud and shrouded in mist from coolant leaks.", 
            "Lights flicker as the engine roars, echoing through the metal corridors."]
        "Lower Engine" -> printLines [
            "The lower engine room is dimly lit, with heavy machinery vibrating beneath the floors.",
            "You feel the ship’s heartbeat here, deep and resonant."]
        "Security" -> printLines [
            "The security room is filled with screens showing feeds from various parts of the ship.",
            "There is a sense of unease as you realize some cameras are dead."]
        "Medbay" -> printLines [
            "The medbay is lined with medical equipment, most of it still functional.", 
            "An overturned stretcher lies nearby, and the smell of antiseptic lingers."]
        "Electrical" -> printLines [ 
            "The electrical room is dark, with sparking wires and buzzing panels lining the walls.", 
            "You can feel the static in the air, and caution is essential here."]
        "Cafeteria" -> printLines [
            "Long tables and empty food trays fill the cafeteria, once bustling with crew.", 
            "The silence is unsettling, and a faint aroma of old food still lingers."]
        "Storage" -> printLines [
            "Storage is cluttered with crates and containers, all labeled with various supplies.", 
            "It’s cramped and shadowy, making it hard to see what might be hiding here."]
        "Weapons" -> printLines [
            "The weapons room is locked behind a reinforced door, a small armory for the crew.",
            "Inside, you see racks of secured weapons awaiting authorization."]
        "Oxygen" -> printLines [
            "The oxygen room houses the life support systems, vital for air circulation.",
            "There’s a soft whirring of fans, but a warning light flashes ominously."]
        "Navigation" -> printLines [
            "The navigation room is lined with monitors displaying star charts and coordinates, softly glowing in the dim light.",
            "This is the heart of the ship’s control, a designated safe point in times of emergency.",
            "The remaining crew members look up as you enter, their eyes heavy with exhaustion but filled with relief.",
            "They offer tired smiles, grateful that the ordeal is finally over, and a calm settles over the room as everyone regains a sense of safety.",
            "You can talk to them using `talk`."]
        "Shields" -> printLines [
            "Shield generators hum softly here, their power keeping the ship protected in space.",
            "However, flickering lights suggest something isn’t working quite right."]
        "Admin Room" -> printLines [
            "The administration room is filled with terminals and data consoles.",
            "This is where important authorizations are made, and the captain’s log rests nearby."]
        _ -> printLines [""]

printRoomLocked :: Room -> IO ()
printRoomLocked room = do
    case room of
        "Electrical" -> printLines [
            "You try to open the door to the electrical room, but it doesn’t budge.", 
            "A warning on the control panel reads: \"Refuel both engines to stabilize power distribution.\"", 
            "It seems that the electrical room’s power systems are reliant on fully fueled engines.", 
            "And once again you must think of something. Where could the spare fuel be stored?"]
        "Oxygen" -> printLines ["You need v2_access_card to access this room"]
        "Navigation" -> printLines [
            "You need to eliminate every threat on the ship to open this door", 
            "Don't forget about v2_access_card. Without it system won't let you in."]
        "Shields" -> printLines ["You need v2_access_card to access this room"]
        _ -> printLines ["You can't go there"]


printStartGame :: GameState -> IO ()
printStartGame state = do
    printLines [
        "Welcome to \"Escape from the Spaceship\"", 
        "", 
        "It's the year 2124, humanity stands on the brink of a new era of discovery.", 
        "The research ship Nova Explorer sets out in search of exotic life forms and resources on uncharted planets.", 
        "However, during the mission, everything goes horribly wrong.",
        "An alien life form encountered in deep space becomes a grave threat to the crew.",
        "Without warning, the team was attacked, plunging the ship into chaos.",
        "Now, with systems failing and the lives of your companions at stake, you must find a way to eliminate the problem.",
        "",
        "Before the attack, the ship's captain briefed you on the emergency protocols.",
        "To reach the navigation room - a safe point, or armory where weapons are stored, you must first obtain a higher-level access card.",
        "To acquire this card, you need to gather critical medical research data about yourself from the medbay.",
        "With that and v1_access_card, you need to head to the admin room to enhance your access privileges.",
        "Unfortunately, the rest of the crew is either dead or trapped in the navigation room with no way to escape.",
        "It’s up to you to confront the aliens and eliminate the threat to your survival.",
        "Your ultimate goal is to eliminate the threat, cleanse the ship from potential contamination, and free the rest of the crew.",
        ""]
    printControls
    lookAround state


printControls :: IO ()
printControls = printLines [
    "",
    "Controls",
    "To see this message again write 'controls'.",
    "look around - let's you look around the room you are currently in and see potential ways to interact with environment",
    "go to [place] - use it to move around the ship",
    "pick up [item] - pick up an item",
    "list my inventory - list items you currently posses",
    "drop [item] - if you don't like something you can drop it",
    "use [item] on [object] - you can use some of the items to accomplish many things",
    "use [item/object] - use things that don't have specific target",
    "For better understanding of the last two commands we will look at the example below",
    "If you want to destroy the door with the bat you should write 'use bat on door' but if you wanted to turn on the flashlight you would write 'use flashlight'",
    "Simple, right?"]


useItemOnObject :: Item -> Object -> GameState -> IO GameState
useItemOnObject item object state = do
    case (item, object) of
        ("gas canister", "gas engine") -> do
            newState <- useCanisterGasEngine state
            return newState
        ("petrol canister", "petrol engine") -> do
            newState <- useCanisterPetrolEngine state
            return newState
        _ -> do 
            printLines ["You can't do that"]
            return state


useCanisterGasEngine :: GameState -> IO GameState
useCanisterGasEngine state = do
    printLines ["You connect the gas canister to the right engine. The gauge stabilizes, indicating full fuel."]
    let newState = addMilestone "gas engine" $ addItem "empty canister" $ deleteItem "gas canister" state
    newState <- unlockElectrical newState
    return newState

useCanisterPetrolEngine :: GameState -> IO GameState
useCanisterPetrolEngine state = do
    printLines ["You carefully pour the petrol into the left engine. The fuel gauge rises to full!"]
    let newState = addMilestone "petrol engine" $ addItem "empty canister" $ deleteItem "petrol canister" state
    newState <- unlockElectrical newState
    return newState

unlockElectrical :: GameState -> IO GameState
unlockElectrical state = do
    if "gas engine" `elem` milestones state && "petrol engine" `elem` milestones state then do
        printLines ["You managed to unlock Electrical"]
        let newState = unlockRoom "Electrical" state
        return newState
    else do return state

gameLoop :: GameState -> IO ()
gameLoop state = do
    cmd <- readCommand
    case words cmd of
        ["list", "my", "inventory"] -> do
            printLines["You are holding " ++ intercalate(", ") (holding state)]
            gameLoop state
        ("go" : "to" : rest) -> do
            let room = unwords rest
            newState <- goTo room state
            gameLoop newState
        ["quit"] -> return ()
        ["controls"] -> do 
            printControls
            gameLoop state
        ["look", "around"] -> do
            lookAround state
            gameLoop state
        ("pick" : "up" : rest) -> do
            let item = unwords rest
            newState <- pick item state
            printLines["You picked up " ++ item]
            gameLoop newState
        ("use" : rest) -> case break (== "on") rest of
            (itemWords, "on" : objectWords) -> do
                let item = unwords itemWords
                let object = unwords objectWords
                if item `elem` holding state && object `elem` objectsInRoom then do
                    newState <- useItemOnObject item object state
                    gameLoop newState
                else do 
                    printLines ["You can't do that"]
                    gameLoop state
                where 
                    objectsInRoom = [object | (object, room, _) <- objects state, room == currentRoom state]
            (itemObjectWords, []) -> do
                let itemObject = unwords itemObjectWords
                if itemObject `elem` holding state then do
                    printLines ["Using item: " ++ itemObject]
                    gameLoop state
                else if itemObject `elem` objectsInRoom then do
                    newState <- useObject itemObject state
                    gameLoop newState
                else do
                    printLines ["Invalid use command"]
                    gameLoop state
                where 
                    objectsInRoom = [object | (object, room, _) <- objects state, room == currentRoom state]
            _ -> do
                printLines ["Invalid use command"]
                gameLoop state
        _ -> do
            printLines ["Unknown command."]
            gameLoop state


main = do
    initialState <- generateGameState
    printStartGame initialState
    gameLoop initialState
