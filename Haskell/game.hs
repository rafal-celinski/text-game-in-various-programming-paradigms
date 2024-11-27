import Data.List (intercalate)
import System.Random (randomRIO)

type Room = String

data GameState = GameState {
    currentRoom :: Room
} deriving (Show)

rooms :: [(Room, [Room])]
rooms = [
    ("Reactor", ["Security", "Lower Engine", "Upper Engine"]),
    ("Security", ["Reactor", "Medbay"]),
    ("Medbay", ["Security"]),
    ("Lower Engine", ["Electrical", "Storage"]),
    ("Storage", ["Electrical", "Shields", "Cafeteria", "Lower Engine"]),
    ("Upper Engine", ["Reactor", "Cafeteria"]),
    ("Electrical", ["Lower Engine", "Storage"]),
    ("Shields", ["Storage", "Oxygen", "Navigation", "Weapons"]),
    ("Cafeteria", ["Upper Engine", "Weapons", "Admin Room", "Storage"]),
    ("Oxygen", ["Shields"]),
    ("Navigation", ["Shields"]),
    ("Weapons", ["Cafeteria, Shields"]),
    ("Admin Room", ["Cafeteria"])]

startRooms :: [Room]
startRooms = ["Reactor", "Security", "Medbay", "Lower Engine", "Storage", "Upper Engine"]

move :: Room -> GameState -> GameState
move targetRoom state =
    if targetRoom `elem` neighbors
    then state { currentRoom = targetRoom}
    else state
  where
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []

readCommand :: IO String
readCommand = do
    putStr "> "
    xs <- getLine
    return xs

printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)

gameLoop :: GameState -> IO ()
gameLoop state = do
    printLines ["You are in: " ++ currentRoom state]
    printLines ["Available rooms: " ++ intercalate(", ") neighbors]
    cmd <- readCommand
    case words cmd of
        ("go" : "to" : rest) -> do
            let room = unwords(rest)
            let newState = move room state
            gameLoop newState
        ["quit"] -> return ()
        _ -> do
            printLines ["Unknown command.", ""]
            gameLoop state
  where
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []


main = do
    startRoom <- randomRIO (0, length startRooms - 1)
    let initialState = GameState (startRooms !! startRoom)
    gameLoop initialState

