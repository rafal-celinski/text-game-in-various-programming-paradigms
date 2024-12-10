import Data.List (intercalate)
import System.Random (randomRIO)
import System.IO (hFlush, stdout)


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
    milestones :: [Milestone]
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
    ("admin panel", "Admin", False),
    ("broken pipe", "Oxygen", True)]


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
        milestones = []
    }


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


addMilestone :: Milestone -> GameState -> IO GameState
addMilestone milestone state = do
    let newState = state {milestones = (milestones state ++ [milestone])}
    return newState

addItem :: Item -> GameState -> IO GameState
addItem item state = do
    let newState = state {holding = (holding state ++ [item])}
    return newState

objectInRoom :: Object -> Room -> GameState -> Bool
objectInRoom object room state = object `elem` [obj | (obj, r, _) <- objects state, r == room]


setObjectUnlockedInRoom :: Object -> Room -> Unlocked -> GameState -> IO GameState
setObjectUnlockedInRoom object room unlocked state = do 
    let newState = state {objects = updatedObjects}
    return newState
    where
        updatedObjects = [(obj, r, if obj == object && r == room then unlocked else oldUnlocked) | (obj, r, oldUnlocked) <- objects state]


setObjectUnlocked :: Object -> Unlocked -> GameState -> IO GameState
setObjectUnlocked object unlocked state = do
    let newState = state {objects = updatedObjects}
    return newState
    where
        updatedObjects = [(obj, r, if obj == object then unlocked else oldUnlocked) | (obj, r, oldUnlocked) <- objects state]
        

useObject :: Object -> GameState -> IO GameState
useObject object state = do
    newState <- case object of
        "cameras" -> do useCameras objectUnlocked state
        "scanner" -> do useScanner objectUnlocked state
        _ -> do printLines ["You can't do that"] >> return state
    return newState
    where
        objectUnlocked = head [unlocked | (obj, _, unlocked) <- objects state, obj == object]


useCameras :: Unlocked -> GameState -> IO GameState
useCameras unlocked state = do
    if unlocked then do
        if aliensInCafeteria && aliensInShields then
            printLines ["You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.", "In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...", "...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.", "The camera feed in the shields room shows another one of these impostors prowling near the shield generators, its form disturbingly familiar.", "Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.", "The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.", "In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever."]
        else if aliensInCafeteria then    
            printLines["You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.", "In the cafeteria, you catch a glimpse of several figures moving between the tables. At first, they look like your crewmates...", "...until you notice the unnatural, jerky way they move. The aliens have taken on the appearance of the fallen crew.", "Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.", "The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.')", "In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever."]
        else if aliensInShields then
            printLines ["You scan the camera feeds one by one. Some screens flicker with static, showing nothing but interference.", "The camera feed in the shields room shows one of the aliens prowling near the shield generators, its form disturbingly familiar.", "Suddenly, a loud electric crackle fills the room, and the monitor screens flicker violently.", "The image distorts as arcs of electricity surge through the system, and one by one, the cameras go dark.", "In the heavy silence that follows, you’re left with only your imagination to fill the gaps. The ship feels more dangerous than ever."]
        else
            printLines["The camera feeds flicker to life, displaying a quiet stillness that has returned to the ship.", "The cafeteria sits empty, tables undisturbed and lights humming softly.", "A calm has settled over the corridors, where only the gentle pulsing of the ship’s systems remains.", "For a moment, there’s a strange sense of peace... until a faint electric crackle disrupts the silence.", "The screens flicker one last time, then slowly fade to black. Whatever happened here, it’s finally over."]
        newState <- setObjectUnlocked "cameras" False state    
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
            printLines ["Don''t waste time. You already did that."]
            return state
        else do
            printLines ["You have aquired medical report. Go to admin room with v1_access card to upgrade it."]
            newState <- addMilestone "scanner" state
            newState <- addItem "medical report" newState
            return newState
    else do
        printLines ["The medbay scanner sits dormant, its screen blank and unresponsive due to an electrical shortage.", "Maybe checking electrical room will let you progress. If you recall corectly it was located near lower engines"]
        return state


readCommand :: IO String
readCommand = do
    putStr "> "
    hFlush stdout
    xs <- getLine
    return xs


printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)


printEnterRoom :: GameState -> IO ()
printEnterRoom state = do
    printLines ["You are in: " ++ currentRoom state]
    printLines ["Available rooms: " ++ intercalate(", ") neighbors]
    printLines ["Available items: " ++ intercalate(", ") itemsInRoom]
    printLines ["Available objects: " ++ intercalate(", ") objectsInRoom]
    where
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []
    itemsInRoom = [item | (item, room) <- items state, room == currentRoom state]
    objectsInRoom = [object | (object, room, _) <- objects state, room == currentRoom state]


printStartGame :: GameState -> IO ()
printStartGame state = do
    printLines ["Game start"]
    printEnterRoom state


gameLoop :: GameState -> IO ()
gameLoop state = do
    cmd <- readCommand
    case words cmd of
        ["list", "my", "inventory"] -> do
            printLines["You are holding " ++ intercalate(", ") (holding state)]
            gameLoop state
        ("go" : "to" : rest) -> do
            let room = unwords rest
            let newState = move room state
            printEnterRoom newState
            gameLoop newState
        ["quit"] -> return ()
        ("pick" : "up" : rest) -> do
            let item = unwords rest
            newState <- pick item state
            printLines["You picked up " ++ item]
            gameLoop newState
        ("use" : rest) -> case break (== "on") rest of
            (itemWords, "on" : objectWords) -> do
                let item = unwords itemWords
                let object = unwords objectWords
                printLines ["Using " ++ item ++ " on " ++ object]
                gameLoop state
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
