class CfgPatches
{
	class KISKA_ViewDistanceLimiter
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={
			"cba_main",
			"KISKA_Functions"
		};
	};
};

class CfgFunctions
{
	class KISKA
	{
		class ViewDistanceLimiter
		{
			file="Kiska_ViewDistanceLimiter\Functions";
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

/*
class Extended_PreInit_EventHandlers {
	class traitManager_settings_preInitEvent {
        init = "call compileScript ['KISKA_TraitManager\Scripts\addTraitManagerCbaSettings.sqf'];";
    };
};
*/
