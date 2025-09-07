class CfgPatches
{
	class KISKA_ViewDistanceLimiter
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={
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
			class VDL_addOpenGuiDiaryEntry
			{
				preinit = 1;
			};
			class VDL_controlsGroup_onLoad
			{};
			class VDL_onLoad
			{};
			class VDL_openDialog
			{};
			class viewDistanceLimiter
			{};
		};
	};
};

#include "Headers\View Distance Limiter Dialog.hpp"

class Extended_PreInit_EventHandlers {
	class viewDistanceLimiter_settings_preInitEvent {
        init = "call compileScript ['KISKA_ViewDistanceLimiter\Scripts\addViewDistanceLimiterCbaSettings.sqf'];";
    };
};
