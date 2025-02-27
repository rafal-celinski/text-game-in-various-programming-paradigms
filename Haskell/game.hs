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
    previousRoom :: Room,
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
    ("Shields", False),
    ("Cafeteria", True),
    ("Oxygen", False),
    ("Navigation", False),
    ("Weapons", False),
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
        previousRoom = "",
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
    then state { 
                previousRoom = currentRoom state,
                objects = [(if obj == "blinded aliens" && room == currentRoom state then "aliens" else obj, room, unlocked) | (obj, room, unlocked) <- objects state],
                currentRoom = targetRoom}
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


setRoomUnlocked :: Room -> Unlocked -> GameState -> GameState
setRoomUnlocked room unlocked state = state {roomsStates = updatedRoomsStates}
    where
        updatedRoomsStates = [(r, if r == room then unlocked else s) | (r, s) <- roomsStates state]


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
        
useItem :: Item -> GameState -> IO GameState
useItem item state = do
    newState <- case item of 
        "encyclopedia" -> useEncyclopedia state
        _ -> do printItemDescription item >> return state
    return newState
    
useEncyclopedia :: GameState -> IO GameState
useEncyclopedia state = do 
    printItemDescription "encyclopedia"
    return $ addMilestone "encyclopedia" state
    

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

useItemOnObject :: Item -> Object -> GameState -> IO GameState
useItemOnObject item object state = do
    newState <- case (item, object) of
        ("gas canister", "gas engine") -> do useCanisterOnGasEngine objectUnlocked state
        ("petrol canister", "petrol engine") -> do useCanisterOnPetrolEngine objectUnlocked state
        ("v1 access card", "admin panel") -> do useAccessCardOnAdminPanel objectUnlocked state
        ("v2 access card", "admin panel") -> do useAccessCardOnAdminPanel objectUnlocked state
        ("medical report", "admin panel") -> do useMedicalReportOnAdminPanel objectUnlocked state
        ("wrench", "pipe") -> do useWrenchOnPipe objectUnlocked state
        ("flashlight", "aliens") -> do useFlashlightOnAliens state
        ("shotgun", "aliens") -> do useShotgunOnAliens state
        ("flashlight", "blinded aliens") -> do useFlashlightOnBlindedAliens state 
        ("shotgun", "blinded aliens") -> do useShotgunOnBlindedAliens state
        _ -> do printLines ["You can't do that"] >> return state
    return newState
    where
        objectUnlocked = maybe False id $ listToMaybe [unlocked | (obj, _, unlocked) <- objects state, obj == object]
            
useFlashlightOnAliens :: GameState -> IO GameState
useFlashlightOnAliens state = do
    printLines [
        "You flick on the flashlight, pointing it directly at the alien figures before you.",
        "The intense beam pierces through the darkness, and the creatures recoil, their hollow eyes blinking and limbs twitching in confusion.",
        "They stagger back, momentarily stunned and disoriented by the powerful light.",
        "It won’t hold them for long, but you have a chance to move or attack while they’re blinded."]
    return state { objects = [(if obj == "aliens" && room == currentRoom state then "blinded aliens" else obj, room, unlocked) | (obj, room, unlocked) <- objects state] }

useFlashlightOnBlindedAliens :: GameState -> IO GameState
useFlashlightOnBlindedAliens state = do
    printLines ["Don''t play with those things, at any moment flashlight can stop working and you stand no chance without it."]
    return state

useShotgunOnAliens :: GameState -> IO GameState
useShotgunOnAliens state = do
    printLines [
        "You raise the shotgun, heart pounding as you take aim at the alien figures.",
        "With a deafening blast, the shotgun kicks against your shoulder, the recoil intense but satisfying.",
        "The alien creatures stagger, their hollow eyes widening just before they collapse in twisted, unnatural heaps on the floor.",
        "Their forms begin to dissolve, revealing something even stranger beneath – twisted, sinewy masses that vaguely resemble what once might have been living beings."]
    let newState = addMilestone ("aliens " ++ (currentRoom state)) state
        updatedObjects = [(if obj == "aliens" && room == currentRoom state then "corpse" else obj, room, unlocked) 
                         | (obj, room, unlocked) <- objects newState]
        newStateWithObjects = newState { objects = updatedObjects }
    
    let finalState = tryUnlockNavigation newStateWithObjects

    return finalState

useShotgunOnBlindedAliens :: GameState -> IO GameState
useShotgunOnBlindedAliens state = do
    printLines [
        "You take advantage of the aliens’ confusion, raising the shotgun with steady hands.",
        "The creatures, disoriented and staggering, barely react as you pull the trigger. The shotgun roars, filling the room with an explosive sound.",
        "The blinded aliens crumple, their strange, distorted forms dropping heavily to the ground, helpless under the onslaught.",
        "As they fall, their true forms begin to seep through the disguise – grotesque, sinewy masses twisted into shapes that vaguely hint at something once living.",
        "All that remains are eerie, unnatural corpses scattered on the floor, a disturbing testament to their failed mimicry of the crew."]
    
    let newState = addMilestone ("aliens " ++ (currentRoom state)) state
        updatedObjects = [(if obj == "blinded aliens" && room == currentRoom state then "corpse" else obj, room, unlocked) 
                         | (obj, room, unlocked) <- objects newState]
        newStateWithObjects = newState { objects = updatedObjects }
    
    let finalState = tryUnlockNavigation newStateWithObjects

    return finalState


useCanisterOnGasEngine :: Unlocked -> GameState -> IO GameState
useCanisterOnGasEngine unlocked state = do
    printLines ["You connect the gas canister to the right engine. The gauge stabilizes, indicating full fuel."]
    let newState = addMilestone "gas engine" $ addItem "empty canister" $ deleteItem "gas canister" state
    newState <- unlockElectrical newState
    return newState


useCanisterOnPetrolEngine :: Unlocked -> GameState -> IO GameState
useCanisterOnPetrolEngine unlocked state = do
    printLines ["You carefully pour the petrol into the left engine. The fuel gauge rises to full!"]
    let newState = addMilestone "petrol engine" $ addItem "empty canister" $ deleteItem "petrol canister" state
    newState <- unlockElectrical newState
    return newState


unlockElectrical :: GameState -> IO GameState
unlockElectrical state = do
    if "gas engine" `elem` milestones state && "petrol engine" `elem` milestones state then do
        printLines ["You managed to unlock Electrical"]
        let newState = setRoomUnlocked "Electrical" True state
        return newState
    else do return state


useMedicalReportOnAdminPanel :: Unlocked -> GameState -> IO GameState
useMedicalReportOnAdminPanel unlocked state = do
    if not unlocked then do
        printLines ["To use it, you need to authenticate using your access_card."]
        return state
    else if "v2 access card" `elem` holding state then do
        printLines ["You already have your v2 access card.", "You don't need another one."]
        return $ setObjectUnlocked "admin panel" False state
    else if "v1 access card" `elem` holding state then do
        printLines [
            "Your medical report flashes on the screen, confirming that you are indeed human.",
            "As the information sinks in, a new message appears, offering a glimmer of hope.",
            "In case of emergency, you are granted a higher-level access card, allowing you to unlock more secure areas of the ship.",
            "As you obtain the higher-level access card, an alarm suddenly blares through the ship.",
            "\"Warning! Oxygen levels critical. Immediate repair needed to maintain safe breathing conditions.\"",
            "The system message echoes ominously, sending a chill down your spine.",
            "",
            "To reach the oxygen installations, you will need to pass through storage and shields. The path won’t be easy..."]
        return $ addMilestone "v2 access card"
                $ addItem "v2 access card"
                $ deleteItem "v1 access card"
                $ setRoomUnlocked "Weapons" True
                $ setRoomUnlocked "Oxygen" True
                $ setRoomUnlocked "Shields" True
                $ setObjectUnlocked "admin panel" False state
    else do
        printLines ["You need the access card for the medical report to be valid."]
        return $ setObjectUnlocked "admin panel" False state

useAccessCardOnAdminPanel :: Unlocked -> GameState -> IO GameState
useAccessCardOnAdminPanel unlocked state = do
    printLines [
        "Your access card hums softly as it validates your credentials, granting you a fleeting moment of control.",
        "With the system poised for your commands, you can execute one critical operation before the terminal locks out once more."]
    let newState = setObjectUnlocked "admin panel" True state
    return newState

useWrenchOnPipe :: Unlocked -> GameState -> IO GameState
useWrenchOnPipe unlocked state = do
    if "pipe" `elem` milestones state then do
        printLines ["Now it looks way better."]
        return state
    else do
        printLines [ 
            "You position the wrench over the loose bolts near the cracked joint, gripping tightly.",
            "With a few strong turns, you feel the bolts begin to tighten, pulling the pipe’s sections securely together.",
            "The hissing sound gradually fades as the leak closes, and the air in the room feels more stable.", 
            "Satisfied with the makeshift repair, you step back, knowing this should hold long enough to restore the oxygen flow."]
        return $ tryUnlockNavigation $ addMilestone "pipe" state


tryUnlockNavigation :: GameState -> GameState
tryUnlockNavigation state =
    let milestonesToCheck = ["aliens Cafeteria", "aliens Shields", "pipe", "v2 access card"]
    in if all (`elem` milestones state) milestonesToCheck
        then setRoomUnlocked "Navigation" True state
        else state

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
    printRoomInfo (currentRoom state) aliensInRoom
    if aliensInRoom then do
        printLines ["You are in grave danger. You can 'run' or figure out if there is a way to deal with monsters."]
        if "shotgun" `elem` holding state then
            printLines ["You grip the shotgun firmly, its weight solid and reassuring in your hands. Whatever these things are, you’re ready."]
        else if "encyclopedia" `elem` milestones state && "flashlight" `elem` holding state then
            printLines ["You feel the weight of the flashlight in your pocket, its cool metal a reminder of the creatures’ one known weakness."]
        else
            return ()
    else do
        printLines ["", "You can go to: " ++ intercalate(", ") neighbors]
        when (not (null itemsInRoom)) $
            printLines ["There are many items around: " ++ intercalate(", ") itemsInRoom]
        when (not (null objectsInRoom)) $
            printLines ["You can use: " ++ intercalate(", ") objectsInRoom]
  where
    aliensInRoom = objectInRoom "aliens" (currentRoom state) state
    neighbors = case lookup (currentRoom state) rooms of
        Just ns -> ns
        Nothing -> []
    itemsInRoom = [item | (item, room) <- items state, room == currentRoom state]
    objectsInRoom = [object | (object, room, _) <- objects state, room == currentRoom state]

    

printRoomInfo :: Room -> Bool -> IO ()
printRoomInfo room aliensInRoom = do
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
        "Cafeteria" -> if aliensInRoom then 
                printLines [
                "You step into the dimly lit room, and a chill immediately runs down your spine",
                "Figures stand scattered across the room, moving with a strange", 
                "unnatural grace. At first glance, they look like members of your crew",
                "But as they turn toward you, you notice their eyes: empty, hollow, and unblinking, devoid of any humanity.",
                "Their movements are jerky, almost as if they’re struggling to control the forms they’ve taken.",
                "A faint, low hiss fills the air as they begin to advance, recognizing you as an outsider.",
                "If you are not prepared - prepare to run for your life!"]
            else
                printLines ["Long tables and empty food trays fill the cafeteria, once bustling with crew.", 
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
        "Shields" -> if aliensInRoom then
                    printLines ["You step cautiously into the shields room, but freeze as a pair of low, guttural growls emerges from the darkness.",
                    "Two alien figures shift in the shadows, their twisted forms barely visible in the dim, flickering lights.",
                    "Both turn towards you, hollow eyes reflecting a strange glint as they advance, their movements synchronized and predatory.",
                    "You lift whatever you have in hand, desperately hoping to hold them at bay. The aliens hesitate, momentarily recoiling, their limbs twitching as if repelled.",
                    "It’s only a brief reprieve, and you can feel the tension building—their hesitation won’t last."]
                else
                    printLines ["Shield generators hum softly here, their power keeping the ship protected in space.",
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

printItemDescription :: Item -> IO ()
printItemDescription item = do
    case item of
        "v1 access card" -> printLines [
            "You hold the v1 access card, granting you access to basic areas of the ship.", 
            "It’s the first level of security, crucial for unlocking admin panel."]
        "v2 access card" -> printLines [
            "The v2 access card glows faintly, indicating a higher level of security.", 
            "With it, you can access more sensitive areas of the ship."]
        "encyclopedia" -> printLines [
            "You open the worn pages of the encyclopedia, flipping through information on various alien species.", 
            "One entry catches your attention: it describes a species known for its shape-shifting abilities and hostile nature.", 
            "A critical line reads: 'Though formidable, this species has one weakness—intense, direct light can disorient or even harm it.'", 
            "Maybe bringing a flashlight to the battlefield wouldn't be a bad idea."]
        "flashlight" -> printLines ["You don't know how long the battery will last, but the light could easily blind someone."]
        "wrench" -> printLines ["A sturdy wrench. It could be useful for repairs or as a makeshift weapon."]
        "plushie" -> printLines ["A soft, well-loved plushie. It might not be useful, but it could be comforting."]
        "empty canister" -> printLines ["An empty canister that could be refilled with something useful later."]
        "pokemon card" -> printLines ["A pristine Pokémon card from 1995 with holographic Charizard—it’s probably worth a fortune!"]
        "petrol canister" -> printLines ["A heavy canister filled with petrol. It might come in handy if you need fuel."]
        "rope" -> printLines ["A strong rope that could be useful for climbing or tying things down."]
        "carton" -> printLines ["An empty carton. Not very useful on its own, but maybe it could hold something."]
        "lightbulbs" -> printLines ["A box of lightbulbs. They might be useful to replace a broken one."]
        "gas canister" -> printLines ["A pressurized gas canister. It could be dangerous if used improperly."]
        "shotgun" -> printLines ["A powerful shotgun with a full magazine. It could be your best defense in a fight."]
        "medical report" -> printLines [
            "MEDICAL REPORT",
            "--------------",
            "Date: 06.04.2124", 
            "", 
            "The examined entity is a human.",
            "",
            "Valid only with v1_access_card."]
        _ -> printLines ["It is " ++ item]



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
    "use [item] on [object] - you can use some of the items to accomplish many things",
    "use [item/object] - use things that don't have specific target",
    "For better understanding of the last two commands we will look at the example below",
    "If you want to destroy the door with the bat you should write 'use bat on door' but if you wanted to turn on the flashlight you would write 'use flashlight'",
    "Simple, right?"]

printEnding :: IO ()
printEnding = printLines [
        "As they gather in the navigation room, the crew exchanges weary but relieved glances.",
        "One by one, they take turns recounting the harrowing events, voices hushed but tinged with disbelief and gratitude.",
        "They lean in, nodding as each person speaks, sharing quick smiles and soft laughs that cut through the tension.",
        "A faint warmth returns to their expressions, a camaraderie solidified by survival. They stand a little taller, knowing the danger is finally behind them.",
        "",
        "Their reaction means one more thing. Your journey with the game ends. Congratulations!",
        "As developers we hope you enjoyed your time here. Have a good one!"]


gameLoop :: GameState -> IO ()
gameLoop state = do
    cmd <- readCommand
    if aliensInRoom 
        then
            case words cmd of
                ["list", "my", "inventory"] -> do
                    printLines["You are holding " ++ intercalate(", ") (holding state)]
                    gameLoop state
                ["quit"] -> return ()
                ["run"] -> do
                    newState <- goTo (previousRoom state) state
                    gameLoop newState
                ("use" : item : "on" : "aliens" : []) ->
                    if item `elem` holding state then do
                        newState <- useItemOnObject item "aliens" state
                        gameLoop newState
                    else do 
                        printLines ["You can't do that"]
                        gameLoop state
                
                _ -> do 
                    printLines ["You can't do that"]
                    gameLoop state
        else
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
                ["talk"] -> do
                    if currentRoom state == "Navigation" then do 
                        printEnding
                        gameLoop state
                    else do
                        printLines ["Already talking to yourself?"]
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
                            newState <- useItem itemObject state
                            gameLoop newState
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
    where
        aliensInRoom = objectInRoom "aliens" (currentRoom state) state


main = do
    initialState <- generateGameState
    printStartGame initialState
    gameLoop initialState
