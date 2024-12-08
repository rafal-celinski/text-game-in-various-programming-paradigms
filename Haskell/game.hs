import Data.List (intercalate)
import System.Random (randomRIO)



type Room = String
type Item = String

data GameState = GameState {
    currentRoom :: Room,
    holding :: [Item],
    items :: [(Item, Room)]
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
startRooms = ["Reactor", "Security", "Medbay", "Lower Engine", "Storage", "Upper Engine"]


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
        items = items
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


readCommand :: IO String
readCommand = do
    putStr "> "
    xs <- getLine
    return xs

printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)

printEnterRoom :: GameState -> IO ()
printEnterRoom state = do
    printLines ["You are in: " ++ currentRoom state]
    printLines ["Available rooms: " ++ intercalate(", ") neighbors]
    printLines ["Available items: " ++ intercalate(", ") itemsInRoom]
    where
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []
    itemsInRoom = [item | (item, room) <- items state, room == currentRoom state]


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
            gameLoop newState
        _ -> do
            printLines ["Unknown command.", ""]
            gameLoop state


main = do
    initialState <- generateGameState
    printStartGame initialState
    gameLoop initialState

