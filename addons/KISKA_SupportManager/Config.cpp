class CfgPatches
{
	class KISKA_SupportManager
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
		class SupportManager
		{
			file="KISKA_SupportManager\Functions";
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

	};
};


class Extended_PreInit_EventHandlers {
	class supportManager_settings_preInitEvent {
        init = "call compileScript ['KISKA_SupportManager\Scripts\addSupportManagerCbaSettings.sqf'];";
    };
};

#include "Headers\Support Manager Dialog.hpp"
