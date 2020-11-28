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
			class heliPatrol
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
			class getBuildingTemplate
			{};
			class getObjectOffsets
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
		class Respawn
		{
			file = "Kiska_functions\Respawn";
			class addRespawnEventHandlers
			{};
			class initializeRespawnSystem
			{};
			class keepInGroup
			{
				postInit = 1;
			};
			class rallyPointActionLoop
			{};
			class respawnStateMachine
			{};
			class updateRallyAction
			{};
			class updateRespawnMarker
			{};
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
		class Utilities
		{
			file="Kiska_functions\Utilities";
			class addArsenal
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
			class findConfigAny
			{};
			class getPlayerObject
			{};
			class getVariableTarget
			{};
			class getVariableTarget_sendBack
			{};
			class hintDiary
			{};
			class intel
			{};
			class isPatchLoaded
			{};
			class markPositions
			{};
			class pasteContainerCargo
			{};
			class podDrop
			{};
			class pushBackToArray
			{};
			class removeArsenal
			{};
			class lookHere
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
		class DynamicViewDistance
		{
			file = "KISKA_functions\View Distance Limiter\Functions";
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