class CfgPatches
{
	class KISKA_Compass
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={
			"KISKA_Functions"
		};
	};
};


class ctrlStaticPicture;
class ctrlStaticPictureKeepAspect;
class ctrlControlsGroupNoScrollbars;
class RscTitles
{
	#include "Headers\Compass GUI Config.hpp"
};


class cfgFunctions
{
	class KISKA
	{

		class Compass
		{
			file = "KISKA_Compass\Functions";

			class compass_addIcon
			{};
			class compass_configure
			{};
			class compass_mainLoop
			{};
			class compass_parseConfig
			{};
			class compass_refresh
			{};
			class compass_updateColors
			{};
			class compass_updateConstants
			{};

		};
	};
};



class KISKA_compass
{

	class compass
	{
		class standard
		{
			title = "Standard";
			image = "\KISKA_Compass\Images\Compasses\Standard Compass.paa";
		};

		class ODST_compass
		{
			title = "ODST";
			image = "\KISKA_Compass\Images\Compasses\ODST Compass.paa";
		};
	};

	class center
	{
		class standard_center
		{
			title = "Standard";
			image = "\KISKA_Compass\Images\Centers\standard center.paa";
		};
	};
};


class Extended_PreInit_EventHandlers
{
    class compass_settings_preInitEvent
	{
        init = "call compileScript ['KISKA_Compass\Scripts\addCompassCbaSettings.sqf'];";
    };
};
