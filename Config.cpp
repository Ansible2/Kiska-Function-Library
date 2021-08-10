class CfgPatches
{
	class Kiska_Functions
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={};
	};
};

class CfgFunctions
{
	class KISKA
	{
		class ACE
		{
			file = "KISKA_functions\ACE"
			class ACE_addSupportMenuAction
			{
				preInit = 1;
			};
			class ACE_unconsciousIsCaptive
			{
				postInit = 1;
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
			class airAssault
			{};
			class arty
			{};
			class attack
			{};
			class changeAI
			{};
			class defend
			{};
			class driveTo
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
			class spawn
			{};
			class spawnGroup
			{};
			class spawnVehicle
			{};
			class vlsFireAt
			{};
		};
		class Buildings
		{
			file = "Kiska_functions\Buildings";
			class createAndSetObject
			{};
			class exportBuildingTemplate
			{};
			class getObjectProperties
			{};
			class selectAndSpawnBuildingTemplate
			{};
		};
		class CargoDrop
		{
			file = "Kiska_functions\Cargo Drop";
			class addCargoEvents
			{
				//postInit = 1;
			};
			class addCargoActions
			{};
			class cargoDrop
			{};
			class strapCargo
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
		class crateLoading
		{
			file = "Kiska_functions\Crate Loading";
			class addCrateActions
			{};
			class addUnloadCratesAction
			{};
			class baseVehicleInfo
			{};
			class dropCrate
			{};
			class getVehicleInfo
			{};
			class loadCrate
			{};
			class pickUpCrate
			{};
			class removeUnloadAction
			{};
			class unloadCrates
			{};
		};
		class GroupChanger
		{
			file = "KISKA_functions\GUIs\Group Changer\Functions";

			class GCH_addDiaryEntry
			{
				preInit = 1;
			};
			class GCH_addMissionEvents
			{
				preInit = 1;
			};
			class GCH_getSideGroups
			{};
			class GCH_groupDeleteQuery
			{};
			class GCH_isAllowedToEdit
			{};
			class GCH_setLeaderRemote
			{};
			class GCH_updateCurrentGroupSection
			{};
			class GCH_updateSideGroupsList
			{};
			class GCHOnLoad
			{};
			class GCHOnLoad_canBeDeletedCombo
			{};
			class GCHOnLoad_canRallyCombo
			{};
			class GCHOnLoad_closeButton
			{};
			class GCHOnLoad_joinGroupButton
			{};
			class GCHOnLoad_leaveGroupButton
			{};
			class GCHOnLoad_setGroupIdButton
			{};
			class GCHOnLoad_setLeaderButton
			{};
			class GCHOnLoad_showAiCheckbox
			{};
			class GCHOnLoad_sideGroupsList
			{};
			class openGCHDialog
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
		class MAC
		{
			file="Kiska_functions\MAC";
			class homing
			{};
			class MACStrike
			{};
			class MACStrike_ADD
			{};
			class MACStrike_REM
			{};
		};
		class Music
		{
			file = "Kiska_functions\Music";
			class getCurrentRandomMusicTrack
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
			class randomMusic
			{};
			class setCurrentRandomMusicTrack
			{};
			class setRandomMusicTime
			{};
			class stopRandomMusicServer
			{};
			class stopRandomMusicClient
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
			file="Kiska_functions\Supports\Support Framework";
			class addCommMenuItem
			{};
			class buildCommandMenu
			{};
			class callingForArsenalSupplyDrop
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
		class SupportManager
		{
			file="Kiska_functions\GUIs\Support Manager";
			class supportManager_addDiaryEntry
			{
				postInit = 1;
			};
			class supportManager_addToPool
			{};
			class supportManager_addToPool_global
			{};
			class supportManager_onLoad
			{};
			class supportManager_onLoad_supportPool
			{};
			class supportManager_openDialog
			{};
			class supportManager_removeFromPool
			{};
			class supportManager_removeFromPool_global
			{};
			class supportManager_store_buttonClickEvent
			{};
			class supportManager_take_buttonClickEvent
			{};
			class supportManager_updateCurrentList
			{};
			class supportManager_updatePoolList
			{};
		};
		class TraitManager
		{
			file="Kiska_functions\GUIs\Trait Manager";
			class traitManager_addDiaryEntry
			{
				preInit = 1;
			};
			class traitManager_addToPool
			{};
			class traitManager_onLoad
			{};
			class traitManager_onLoad_traitPool
			{};
			class traitManager_openDialog
			{};
			class traitManager_removeFromPool
			{};
			class traitManager_store_buttonClickEvent
			{};
			class traitManager_take_buttonClickEvent
			{};
			class traitManager_updateCurrentList
			{};
		};
		class Tasks
		{
			file="Kiska_functions\Tasks";
			class createTaskFromConfig
			{};
			class endTask
			{};
			class setTaskComplete
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
			class addTeleportAction
			{};
			class alivePlayers
			{};
			class balanceHeadless
			{};
			class classTurretsWithGuns
			{};
			//class copyContainerCargo
			//{};
			class cruiseMissile
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
			class findConfigAny
			{};
			class findIfBool
			{};
			class getContainerCargo
			{};
			class getMissionLayerObjects
			{};
			class getNearestIncriment
			{};
			class getPlayerObject
			{};
			class getVariableTarget
			{};
			class getVariableTarget_sendBack
			{};
			class getVectorToTarget
			{};
			class hintDiary
			{};
			class isAdminOrHost
			{};
			class isMainMenu
			{};
			class intel
			{};
			class isPatchLoaded
			{};
			class log
			{};
			class markPositions
			{};
			class monitorFPS
			{};
			class notification
			{};
			//class pasteContainerCargo
			//{};
			class podDrop
			{};
			class pushBackToArray
			{};
			class pushBackToArray_interface
			{};
			class reassignCurator
			{};
			class remoteReturn_receive
			{};
			class remoteReturn_send
			{};
			class removeArsenal
			{};
			class setContainerCargo
			{};
			class showHide
			{};
			class skipBrief
			{
				//preInit=1;
			};
			class staticLine
			{};
			class str
			{};
			class triggerWait
			{};
			class vehicleFactory
			{};
			class waitUntil
			{};
		};
		class ViewDistanceLimiter
		{
			file = "KISKA_functions\GUIs\View Distance Limiter\Functions";
			class addOpenVdlGuiDiary
			{
				postInit = 1;
			};
			class adjustVdlControls
			{};
			class findVdlPartnerControl
			{};
			class handleVdlDialogOpen
			{};
			class handleVdlGuiCheckbox
			{};
			class isVdlSystemRunning
			{};
			class openVdlDialog
			{};
			class setAllVdlButton
			{};
			class setVdlValue
			{};
			class viewDistanceLimiter
			{};
		};

	};
};


class CfgCommunicationMenu
{
	#include "Supports\Support Framework\Headers\Supports CfgCommMenu.hpp"
};


class Extended_PreInit_EventHandlers {
    class support_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\Supports\Support Framework\Scripts\addSupportCbaSettings.sqf'];";
    };
	class supportManager_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\GUIs\Support Manager\Scripts\addSupportManagerCbaSettings.sqf'];";
    };
	class traitManager_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\GUIs\Trait Manager\Scripts\addTraitManagerCbaSettings.sqf'];";
    };
	class groupChanger_settings_preInitEvent {
        init = "call compileScript ['KISKA_functions\GUIs\Group Changer\Scripts\addGroupChangerCbaSettings.sqf'];";
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


#include "GUIs\Common GUI Headers\commonBaseClasses.hpp"
#include "GUIs\View Distance Limiter\ViewDistanceLimiterDialog.hpp"
#include "GUIs\Group Changer\GroupChangerDialog.hpp"
#include "GUIs\Support Manager\Headers\Support Manager Dialog.hpp"
#include "GUIs\Trait Manager\Headers\Trait Manager Dialog.hpp"
