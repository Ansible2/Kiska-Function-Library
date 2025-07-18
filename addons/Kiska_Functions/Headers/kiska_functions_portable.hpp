#ifdef KISKA_IS_MISSION_TEMPLATE
    __EXEC(KISKA_FUNCTIONS_ROOT_FOLDER = "KISKA Systems")
#else
    __EXEC(KISKA_FUNCTIONS_ROOT_FOLDER = "KISKA_functions")
#endif

class ACE_FastRope
{	
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\ACE\Fast Rope");

    class ACE_deployFastRope
    {};
    class ACE_deployRopes
    {};
    class ACE_fastRope
    {};
    class ACE_setOnPrepareFastrope
    {};
};
class ACE
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\ACE");
    class ACE_addSupportMenuAction
    {
        preInit = 1;
    };
    class ACE_unconsciousIsCaptive
    {
        preInit = 1;
    };
};
class ACEX
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\ACEX");
    class ACEX_setHCTransfer
    {};
};
class AI
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\AI");
    class AAAZone
    {};
    class arty
    {};
    class attack
    {};
    class clearWaypoints
    {};
    class defend
    {};
    class driveTo
    {};
    class dropOff
    {};
    class engageHeliTurretsLoop
    {};
    class hover
    {};
    class heliLand
    {};
    class heliPatrol
    {};
    class initDynamicSimConfig
    {
        postInit = 1;
    };
    class lookHere
    {};
    class patrolSpecific
    {};
    class setCrew
    {};
    class slingLoad
    {};
    class spawn
    {};
    class spawnGroup
    {};
    class spawnVehicle
    {};
    class stalk
    {};
    class vlsFireAt
    {};
};
class Animations
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Animations");
    class ambientAnim
    {};
    class ambientAnim_addAttachLogicGroup
    {};
    class ambientAnim_createMapFromConfig
    {};
    class ambientAnim_getNearestAttachLogicGroup
    {};
    class ambientAnim_getAttachLogicGroupsMap
    {};
    class ambientAnim_isAnimated
    {};
    class ambientAnim_play
    {};
    class ambientAnim_setStoredLoadout
    {};
    class ambientAnim_stop
    {};
};
class Bases
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Bases");
    class bases_createFromConfig_agents
    {};
    class bases_createFromConfig_landVehicles
    {};
    class bases_createFromConfig_infantry
    {};
    class bases_createFromConfig_patrols
    {};
    class bases_createFromConfig_simples
    {};
    class bases_createFromConfig_turrets
    {};
    class bases_getHashmap
    {};
    class bases_createFromConfig
    {};
    class bases_getClassConfig
    {};
    class bases_getPropertyValue
    {};
    class bases_initAmbientAnimFromClass
    {};
    class bases_initReinforceFromClass
    {};
    class bases_triggerReaction
    {};
    class bases_setupReactivity
    {};
};

class CIWS
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\CIWS");
    class ciwsInit
    {};
    class ciwsAlarm
    {};
    class ciwsSiren
    {};
};

class Configs
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Configs");
    class findConfigAny
    {};
    class getConditionalConfigClass
    {};
    class getConfigData
    {};
    class getConfigDataConditional
    {};
    class getMostSpecificCfgValue
    {};
    class hasConditionalConfig
    {};
};

class Convoy
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Convoy");
    
    class convoy_addVehicle
    {};
    class convoy_addVehicleKilledEvent
    {};
    class convoy_clearVehicleDebugFollowedPath
    {};
    class convoy_clearVehicleDebugFollowPath
    {};
    class convoy_create
    {};
    class convoy_delete
    {};
    class convoy_getBumperPosition
    {};
    class convoy_getConvoyHashMapFromVehicle
    {};
    class convoy_getConvoyLeader
    {};
    class convoy_getConvoyStatemachine
    {};
    class convoy_getConvoyVehicles
    {};
    class convoy_getDefaultSeperation
    {};
    class convoy_getPointBuffer
    {};
    class convoy_getVehicleAtIndex
    {};
    class convoy_getVehicleDebugFollowedPath
    {};
    class convoy_getVehicleDebugFollowPath
    {};
    class convoy_getVehicleDebugMarkerType_followedPath
    {};
    class convoy_getVehicleDebugMarkerType_followPath
    {};
    class convoy_getVehicleDrivePath
    {};
    class convoy_getVehicleIndex
    {};
    class convoy_getVehicleKilledEvent
    {};
    class convoy_getVehicleLastAddedPoint
    {};
    class convoy_getVehicleSeperation
    {};
    class convoy_handleDeadDriver_default
    {};
    class convoy_handleUnconsciousDriver_default
    {};
    class convoy_handleVehicleCantMove_default
    {};
    class convoy_handleVehicleKilled_default
    {};
    class convoy_isVehicleInDebug
    {};
    class convoy_modifyVehicleDrivePath
    {};
    class convoy_onEachFrame
    {};
    class convoy_removeVehicle
    {};
    class convoy_removeVehicleKilledEvent
    {};
    class convoy_setDefaultSeperation
    {};
    class convoy_setPointBuffer
    {};
    class convoy_setVehicleDebug
    {};
    class convoy_setVehicleDebugMarkerType_followedPath
    {};
    class convoy_setVehicleDebugMarkerType_followPath
    {};
    class convoy_setVehicleDriveOnPath
    {};
    class convoy_setVehicleKilledEvent
    {};
    class convoy_setVehicleSeperation
    {};
    class convoy_shouldVehicleDriveOnPath
    {};
    class convoy_stopVehicle
    {};
    class convoy_syncLatestDrivePoint
    {};
};

class EventHandlers
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\EventHandlers");
    class eventHandler_addFromConfig
    {};
    class eventHandler_createCBAStateMachine
    {};
    class eventHandler_remove
    {};
};

class Hashmap
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Hashmap");
    class hashmap_deleteAt
    {};
    class hashmap_get
    {};
    class hashmap_getKiskaObjectGroupKeyMap
    {};
    class hashmap_getObjectOrGroupFromRealKey
    {};
    class hashmap_getRealKey
    {};
    class hashmap_in
    {};
    class hashmap_set
    {};
};

class Loadouts
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Loadouts");
    class assignUnitLoadout
    {};
    class randomGear
    {};
    class randomGearFromConfig
    {};
    class randomLoadout
    {};
    class savePlayerLoadout
    {
        preInit = 1;
    };
};

class ManagedRun
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Managed Run");
    class managedRun_execute
    {};
    class managedRun_isDefined
    {};
    class managedRun_updateCode
    {};
};

class MultiKillEvent
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Multi Kill Event");
    class multiKillEvent_addObjects
    {};
    class multiKillEvent_create
    {};
    class multiKillEvent_delete
    {};
    class multiKillEvent_getContainerMap 
    {};
    class multiKillEvent_getEventMap
    {};
    class multiKillEvent_getKilledCount 
    {};
    class multiKillEvent_getTotal 
    {};
    class multiKillEvent_getType 
    {};
    class multiKillEvent_isObjectInEvent 
    {};
    class multiKillEvent_isThresholdMet 
    {};
    class multiKillEvent_onKilled 
    {};
    class multiKillEvent_onThresholdMet 
    {};
    class multiKillEvent_removeObjects 
    {};
    class multiKillEvent_threshold 
    {};
};

class Music
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Music");
    class getLatestPlayedMusicID
    {};
    class getMusicDuration
    {};
    class getMusicFromClass
    {};
    class getPlayingMusic
    {};
    class isMusicPlaying
    {};
    class musicEventHandlers
    {
        preInit = 1;
    };
    class musicStartEvent
    {};
    class musicStopEvent
    {};
    class playMusic
    {};
    class stopMusic
    {};
};

class Position
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Positions");
    class drawBoundingBox
    {};
    class drawLookingAtMarker_start
    {};
    class drawLookingAtMarker_stop
    {};
    class getBoundingBoxCenter
    {};
    class getMapCursorPosition
    {};
    class getPositionPlayerLookingAt
    {};
    class getPosRelativeASL
    {};
    class removeBoundingBoxDraw
    {};
};

class Rally
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Rally");
    class addRallyPointDiaryEntry
    {
        preInit = 1;
    };
    class allowGroupRally
    {};
    class disallowGroupRally
    {};
    class isGroupRallyAllowed
    {};
    class updateRallyPointNotification
    {};
    class updateRespawnMarker
    {};
    class updateRespawnMarkerQuery
    {};
};

class RandomMusic
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Music\Random Music");
    class randomMusic_getCurrentTrack
    {};
    class randomMusic_getTrackInterval
    {};
    class randomMusic_getUnusedTracks
    {};
    class randomMusic_getUsedTracks
    {};
    class randomMusic_getVolume
    {};
    class randomMusic_isSystemRunning
    {};
    class randomMusic_setCurrentTrack
    {};
    class randomMusic_setSystemRunning
    {};
    class randomMusic_setTrackInterval
    {};
    class randomMusic_setUnusedTracks
    {};
    class randomMusic_setUsedTracks
    {};
    class randomMusic_setVolume
    {};
    class randomMusic_stopClient
    {};
    class randomMusic_stopServer
    {};
    class randomMusic
    {};
};

class Respawn
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Respawn");
    class keepInGroup
    {
        preInit = 1;
    };
};
class Sound
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Sound");
    class ambientNewsRadio
    {};
    class battleSound
    {};
    class stopBattleSound
    {};
    class playRandom3dSoundLoop
    {};
    class stopRandom3dSoundLoop
    {};
    class playsound2D
    {};
    class playsound3D
    {};
    class radioChatter
    {};
    class stopRadioChatter
    {};
};

class SpectrumDevice
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Spectrum Device");
    class spectrum_addSignal
    {};
    class spectrum_deleteSignal
    {};
    class spectrum_getMaxDecibels
    {};
    class spectrum_getMaxFrequency
    {};
    class spectrum_getMinDecibels
    {};
    class spectrum_getMinFrequency
    {};
    class spectrum_getSelection
    {};
    class spectrum_getSignalMap
    {};
    class spectrum_isInitialized
    {};
    class spectrum_isTransmitting
    {};
    class spectrum_setMaxDecibels
    {};
    class spectrum_setMaxFrequency
    {};
    class spectrum_setMinDecibels
    {};
    class spectrum_setMinFrequency
    {};
    class spectrum_setSelectionWidth
    {};
    class spectrum_setSignalDecibels
    {};
    class spectrum_setSignalDistance
    {};
    class spectrum_setSignalFrequency
    {};
    class spectrum_setSignalPosition
    {};
    class spectrum_setTransmitting
    {};
    class spectrum_signalExists
    {};
    class spectrum_startSignalLoop
    {};
    class spectrum_updateSignal
    {};
};

class Speech
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Speech");
    class speech_addTopic
    {};
    class speech_getBikbPath
    {};
    class speech_getDefaultConfigRoot
    {};
    class speech_getFsmPath
    {};
    class speech_say
    {};
    class speech_showSubtitles
    {};
    class speech_getTopicEventHandler
    {};
    class speech_getTopicName
    {};
};

class Supports
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Supports");
    class CAS
    {};
    class CASAttack
    {};
    class closeAirSupport
    {};
    class closeAirSupport_fire
    {};
    class closeAirSupport_parseFireOrders
    {};
    class cruiseMissileStrike
    {};
    class helicopterGunner
    {};
    class paratroopers
    {};
    class supplyDrop
    {};
    class supplyDropWithAircraft
    {};
    class virtualArty
    {};
    class updateFlareEffects
    {};
};
class CommandMenuSupportCaller
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Support Framework\Command Menu Support Caller");
    class commMenu_detectControlKeys
    {
        preInit = 1;
    };
    class commMenu_onSupportAdded
    {};
    class commMenu_onSupportRemoved
    {};
    class commMenu_onSupportSelected
    {};
    class commMenu_openArty
    {};
    class commMenu_openCAS
    {};
    class commMenu_openHelicopterCAS
    {};
    class commMenu_openSupplyDrop
    {};
    class commMenu_refresh
    {};
};
class SupportFramework
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Support Framework\Common");
    class supports_add
    {};
    class supports_call
    {};
    class supports_genericNotification
    {};
    class supports_genericRadioMessage
    {};
    class supports_getCommonTargetPosition
    {};
    class supports_getMap
    {};
    class supports_getNumberOfUsesLeft
    {};
    class supports_remove
    {};
};
class StandardSupportEvents
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Support Framework\Standard Support Events");
    class supports_onCalledCloseAirSupport
    {};
    class supports_onCalledHelicopterGunner
    {};
    class supports_onCalledSupplyDrop
    {};
    class supports_onCalledVirtualArty
    {};
};
class Tasks
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Tasks");
    class createTaskFromConfig
    {};
    class endTask
    {};
};
class Timeline
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Timeline");
    class timeline_executeEvent
    {};
    class timeline_getMainMap
    {};
    class timeline_getInfoMap
    {};
    class timeline_isRunning
    {};
    class timeline_setIsRunning
    {};
    class timeline_getIsRunningMap
    {};
    class timeline_start
    {};
    class timeline_stop
    {};
};
class Utilities
{
    file = __EVAL(KISKA_FUNCTIONS_ROOT_FOLDER + "\Functions\Utilities");
    class addArsenal
    {};
    class addEntityKilledEventHandler
    {};
    class addKiskaDiaryEntry
    {};
    class addMagRepack
    {};
    class addProximityPlayerAction
    {};
    class addTeleportAction
    {};
    class alivePlayers
    {};
    class balanceHeadless
    {};
    class callBack
    {};
    class classTurretsWithGuns
    {};
    class clearCargoGlobal
    {};
    class createAssetAtPosition
    {};
    class countdown
    {};
    class dataLinkMsg
    {};
    class deleteAtArray
    {};
    class deleteAtArray_interface
    {};
    class deleteRandomIndex
    {};
    class doMagRepack
    {};
    class errorNotification
    {};
    class exportLoadouts
    {};
    class exportSpawnPositions
    {};
    class findIfBool
    {};
    class generateUniqueId
    {};
    class getBoundingBoxDimensions
    {};
    class getBumperPositionRelative
    {};
    class getContainerCargo
    {};
    class getFromNetId
    {};
    class getLoadedModsInfo
    {};
    class getMissionLayerObjects
    {};
    class getNearestIncriment
    {};
    class getOrDefaultSet
    {};
    class getRelativeVectorAndPos
    {};
    class getVariableTarget
    {};
    class getVariableTarget_sendBack
    {};
    class getVectorToTarget
    {};
    class hashMapParams
    {};
    class hintDiary
    {};
    class idCounter
    {};
    class isGroupAlive
    {};
    class isAdminOrHost
    {};
    class isEmptyCode
    {};
    class isMainMenu
    {};
    class isPatchLoaded
    {};
    class log
    {};
    class markPositions
    {};
    class markBorder
    {};
    class monitorFPS
    {};
    class netId
    {};
    class notification
    {};
    class notify
    {};
    class openCommandingMenuPath
    {};
    class playDrivePath
    {};
    class pushBackToArray
    {};
    class pushBackToArray_interface
    {};
    class randomIndex
    {};
    class recordDrivePath
    {};
    class reassignCurator
    {};
    class remoteReturn_receive
    {};
    class remoteReturn_send
    {};
    class removeArsenal
    {};
    class removeBISArsenalAction
    {};
    class removeEntityKilledEventHandler
    {};
    class removeMagRepack
    {};
    class removeProximityPlayerAction
    {};
    class resetMove
    {};
    class selectRandom
    {};
    class setContainerCargo
    {};
    class setRelativeVectorAndPos
    {};
    class setWaypointExecStatement
    {};
    class showHide
    {};
    class showNotification
    {};
    class sortStringsNumerically
    {};
    class staticLine
    {};
    class staticLine_eject
    {};
    class str
    {};
    class vehicleFactory
    {};
    class waitUntil
    {};
};