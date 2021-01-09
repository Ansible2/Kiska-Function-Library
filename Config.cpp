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
			
			class GCH_groupDeleteQuery
			{};
			class GCH_isAllowedToEdit
			{};
			class GCH_updateCurrentGroupList
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
			class GCHOnLoad_showAiCheckbox
			{};
			class GCHOnLoad_sideGroupsList
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
			class supportRadioGlobal
			{};
		};
		class Supports
		{
			file="Kiska_functions\Supports";
			class callForArtillery
			{};
			class CAS
			{};
			class paratroopers
			{};
		};
		class Utilities
		{
			file="Kiska_functions\Utilities";
			class addArsenal
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
			class cruiseMissileStrike
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

#include "GUIs\Common GUI Headers\commonBaseClasses.hpp"
#include "GUIs\View Distance Limiter\ViewDistanceLimiterDialog.hpp"
#include "GUIs\Group Changer\GroupChangerDialog.hpp"