class CfgPatches
{
	class KISKA_TraitManager
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={
			"KISKA_Functions",
            "KISKA_SimpleStore"
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
                postInit = 1;
            };
            class traitManager_addToPool
            {};
            class traitManager_open
            {};
            class traitManager_removeFromPool
            {};
		};
	};
};


class Extended_PreInit_EventHandlers {
	class traitManager_settings_preInitEvent {
        init = "call compileScript ['KISKA_TraitManager\Scripts\addTraitManagerCbaSettings.sqf'];";
    };
};
