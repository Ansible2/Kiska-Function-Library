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
			class configureConvoy
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
			class ambientAnim_createMapFromConfig
			{};
			class ambientAnim_isAnimated
			{};
			class ambientAnim_play
			{};
			class ambientAnim_stop
			{};
			class ambientAnim
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
			class hashmap_deleteAt
			{};
			class hashmap_get
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
			class ambientRadio
			{};
			class battleSound
			{};
			class playSoundNSub
			{};
			class playsound2D
			{};
			class playsound3D
			{};
			class radioChatter
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
		class Utilities
		{
			file="Kiska_functions\Utilities";
			class addArsenal
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
			class doMagRepack
			{};
			class errorNotification
			{};
			class exportSpawnPositions
			{};
			class findConfigAny
			{};
			class findIfBool
			{};
			class getContainerCargo
			{};
			class getFromNetId
			{};
			class getMissionLayerObjects
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
			class removeProximityPlayerAction
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
	#include "EventHandlers\Headers\KISKA Combat Mode EventHandlers.hpp"
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
};

#include "Animations\Headers\Ambient Animations.hpp"
#include "GUIs\Common GUI Headers\KISKA GUI Classes.hpp"
#include "Sound\Headers\CfgSounds.hpp"
