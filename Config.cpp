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
	class Kiska
	{
		class AI
		{
			file = "Kiska_functions\AI";
			class airAssault
			{};
			class arty
			{};
			class changeAI
			{};
			class defend
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
			class playMusic
			{};
			class randomMusic
			{};
		};
		class Respawn
		{
			file = "Kiska_functions\Respawn";
			class addRespawnEventHandlers
			{};
			class initializeRespawnSystem
			{};
			class updateRallyAction
			{};
			class updateRespawnMarker
			{};
		};
		class Sound
		{
			file = "Kiska_functions\Sound";
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
			class addContainerCargo
			{};
			class alivePlayers
			{};
			class balanceHeadless
			{};
			class dataLinkMsg
			{};
			class getContainerCargo
			{};
			class hintDiary
			{};
			class intel
			{};
			class isPatchLoaded
			{};
			class markPositions
			{};
			class podDrop
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
			class waitUntil
			{};
		};
			
	};
};