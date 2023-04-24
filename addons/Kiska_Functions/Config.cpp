class CfgPatches
{
    class Kiska_Functions
    {
        units[]={};
        weapons[]={};
        requiredVersion=0.1;
        requiredAddons[]={
            "cba_main"
        };
    };
};

class CfgFunctions
{
    class KISKA
    {
        class ACE_FastRope
        {
            file = "KISKA_functions\ACE\Fast Rope";
            class ACE_deployFastRope
            {};
            class ACE_deployRopes
            {};
            class ACE_fastRope
            {};
        };
        class ACE
        {
            file = "KISKA_functions\ACE";
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
            file = "KISKA_functions\ACEX";
            class ACEX_setHCTransfer
            {};
        };
        class AI
        {
            file = "Kiska_functions\AI";
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
            file = "Kiska_functions\Animations";
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
            file = "Kiska_functions\Bases";
            class bases_createFromConfig
            {};
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
            class bases_getInfantryClasses
            {};
            class bases_getSide
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
            file = "Kiska_functions\CIWS";
            class ciwsInit
            {};
            class ciwsAlarm
            {};
            class ciwsSiren
            {};
        };

        class Convoy
        {
            file = "Kiska_functions\Convoy";
            
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
            file = "Kiska_functions\EventHandlers";
            class eventHandler_addFromConfig
            {};
            class eventHandler_createCBAStateMachine
            {};
            class eventHandler_remove
            {};
        };

        class Hashmap
        {
            file = "Kiska_functions\Hashmap";
            class hashmap_assignObjectOrGroupKey
            {};
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
            file = "Kiska_functions\Loadouts";
            class assignUnitLoadout
            {};
            class randomGear
            {};
            class randomLoadout
            {};
            class savePlayerLoadout
            {
                preInit = 1;
            };
        };

        class Music
        {
            file = "Kiska_functions\Music";
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
        class Rally
        {
            file = "Kiska_functions\Rally";
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
            file = "Kiska_functions\Music\Random Music";
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
            file = "Kiska_functions\Respawn";
            class keepInGroup
            {
                preInit = 1;
            };
        };
        class Sound
        {
            file = "Kiska_functions\Sound";
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
        class Supports
        {
            file="Kiska_functions\Supports";
            class arsenalSupplyDrop
            {};
            class CAS
            {};
            class CASAttack
            {};
            class cruiseMissileStrike
            {};
            class helicopterGunner
            {};
            class paratroopers
            {};
            class supplyDrop
            {};
            class supplyDrop_aircraft
            {};
            class virtualArty
            {};
        };
        class SupportFramework
        {
            file="Kiska_functions\Supports\Support Framework\Functions";
            class addCommMenuItem
            {};
            class buildCommandMenu
            {};
            class callingForArsenalSupplyDrop
            {};
            class callingForSupplyDrop_aircraft
            {};
            class callingForArty
            {};
            class callingForCAS
            {};
            class callingForHelicopterCAS
            {};
            class callingForSupportMaster
            {};
            class commandMenuTree
            {};
            class createVehicleSelectMenu
            {};
            class detectControlKeys
            {
                preInit = 1;
            };
            class getAmmoClassFromId
            {};
            class getAmmoTitleFromId
            {};
            class getCasTitleFromId
            {};
            class getSupportVehicleClasses
            {};
            class supportNotification
            {};
            class supportRadio
            {};
            class updateFlareEffects
            {};
        };
        class Tasks
        {
            file="Kiska_functions\Tasks";
            class createTaskFromConfig
            {};
            class endTask
            {};
        };
        class Timeline
        {
            file="KISKA_functions\Timeline";
            class executeTimelineEvent
            {};
            class getOverallTimelineMap
            {};
            class getTimelineMap
            {};
            class isTimelineRunning
            {};
            class startTimeline
            {};
            class stopTimeline
            {};
        };
        class Utilities
        {
            file="Kiska_functions\Utilities";
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
            class findConfigAny
            {};
            class findIfBool
            {};
            class getBumperPositionRelative
            {};
            class getContainerCargo
            {};
            class getFromNetId
            {};
            class getMissionLayerObjects
            {};
            class getMostSpecificCfgValue
            {};
            class getNearestIncriment
            {};
            class getRelativeVectorAndPos
            {};
            class getVariableTarget
            {};
            class getVariableTarget_sendBack
            {};
            class getVectorToTarget
            {};
            class hintDiary
            {};
            class idCounter
            {};
            class isGroupAlive
            {};
            class isAdminOrHost
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
            class selectLastIndex
            {};
            class selectRandom
            {};
            class setContainerCargo
            {};
            class setRelativeVectorAndPos
            {};
            class setupMultiKillEvent
            {};
            class showHide
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
    };
};


class CfgCommunicationMenu
{
    #include "Supports\Support Framework\Headers\Supports CfgCommMenu.hpp"
};


class KISKA_eventHandlers
{
    #include "EventHandlers\Headers\KISKA Behaviour EventHandlers.hpp"
    #include "EventHandlers\Headers\KISKA Combat Behaviour EventHandlers.hpp"
};

class KISKA_loadouts
{
    #include "Loadouts\Headers\Korea Winter Loadouts.hpp"
    #include "Loadouts\Headers\Korea Summer Loadouts.hpp"
    #include "Loadouts\Headers\Korea Ratnik Loadouts.hpp"
};

class Extended_PreInit_EventHandlers {
    class support_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Supports\Support Framework\Scripts\addSupportCbaSettings.sqf'];";
    };
    class coef_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Scripts\CBA Settings\addCoefCbaSettings.sqf'];";
    };
    class loadout_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Scripts\CBA Settings\addLoadoutCbaSettings.sqf'];";
    };
    class music_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Music\Scripts\addMusicCbaSettings.sqf'];";
    };
    class logging_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Scripts\CBA Settings\addLoggingCbaSettings.sqf'];";
    };
    class ACE_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\ACE\Scripts\addAceCbaSettings.sqf'];";
    };
    class enabledChannel_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Scripts\CBA Settings\addEnableChannelCbaSettings.sqf'];";    
    };
};

#include "Animations\Headers\Ambient Animations.hpp"
#include "GUIs\Common GUI Headers\KISKA GUI Classes.hpp"
#include "Sound\Headers\CfgSounds.hpp"
