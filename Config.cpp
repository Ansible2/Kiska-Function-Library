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
				postInit = 1;
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
				postInit = 1;
			};
			class GCH_groupDeleteQuery
			{};
			class GCH_isAllowedToEdit
			{};
			class GCH_setLeaderRemote
			{};
			class GCH_updateCurrentGroupSection
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
				postInit = 1;
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
			class getMusicPlaying
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
				postInit = 1;
			};
			class allowGroupRally
			{};
			class disallowGroupRally
			{};
			class isGroupRallyAllowed
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
				postInit = 1;
			};
			/*
			class rallyPointActionLoop
			{};
			*/
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
			class cruiseMissileStrike
			{};
			class helicopterGunner
			{};
			class paratroopers
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
			class callingForSupportMaster
			{};
			class callingForArty
			{};
			class callingForCAS
			{};
			class callingForHelicopterCAS
			{};
			class commandMenuTree
			{};
			class createVehicleSelectMenu
			{};
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
			class supportManager_onLoad
			{};
			class supportManager_onLoad_supportPool
			{};
			class supportManager_openDialog
			{};
			class supportManager_removeFromPool
			{};
			class supportManager_store_buttonClickEvent
			{};
			class supportManager_take_buttonClickEvent
			{};
			class supportManager_updateCurrentList
			{};
		};
		class TraitManager
		{
			file="Kiska_functions\GUIs\Trait Manager";
			class traitManager_addDiaryEntry
			{
				postInit = 1;
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
			class copyContainerCargo
			{};
			class cruiseMissile
			{};
			class dataLinkMsg
			{};
			class deleteAtArray
			{};
			class doMagRepack
			{};
			class findConfigAny
			{};
			class findIfBool
			{};
			class getPlayerObject
			{};
			class getVariableTarget
			{};
			class getVariableTarget_sendBack
			{};
			class hintDiary
			{};
			class isAdminOrHost
			{};
			class intel
			{};
			class isPatchLoaded
			{};
			class log
			{};
			class markPositions
			{};
			class pasteContainerCargo
			{};
			class podDrop
			{};
			class pushBackToArray
			{};
			class reassignCurator
			{};
			class remoteReturn_receive
			{};
			class remoteReturn_send
			{};
			class removeArsenal
			{};
			class setTaskComplete
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
			class supplyDrop
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
};


#include "GUIs\Common GUI Headers\commonBaseClasses.hpp"
#include "GUIs\View Distance Limiter\ViewDistanceLimiterDialog.hpp"
#include "GUIs\Group Changer\GroupChangerDialog.hpp"
#include "GUIs\Support Manager\Headers\Support Manager Dialog.hpp"
#include "GUIs\Trait Manager\Headers\Trait Manager Dialog.hpp"
