class CfgPatches
{
	class KISKA_TraitManager
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
		class TraitManager
		{
			file="Kiska_TraitManager\Functions";
			class traitManager_addDiaryEntry
			{
				preInit = 1;
			};
			class traitManager_addToPool
			{};
			class traitManager_addToPool_global
			{};
			class traitManager_onLoad
			{};
			class traitManager_openDialog
			{};
			class traitManager_removeFromPool
			{};
			class traitManager_removeFromPool_global
			{};
			class traitManager_store_buttonClickEvent
			{};
			class traitManager_take_buttonClickEvent
			{};
			class traitManager_updateCurrentList
			{};
			class traitManager_updatePoolList
			{};
		};
	};
};


class Extended_PreInit_EventHandlers {
	class traitManager_settings_preInitEvent {
        init = "call compileScript ['KISKA_TraitManager\Scripts\addTraitManagerCbaSettings.sqf'];";
    };
};

#include "Headers\Trait Manager Dialog.hpp"
