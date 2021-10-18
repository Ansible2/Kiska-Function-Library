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
				preinit = 1;
			};
			class viewDistanceLimiter
			{};
		};
	};
};


class Extended_PreInit_EventHandlers {
	class viewDistanceLimiter_settings_preInitEvent {
        init = "call compileScript ['KISKA_ViewDistanceLimiter\Scripts\addViewDistanceLimiterCbaSettings.sqf'];";
    };
};
