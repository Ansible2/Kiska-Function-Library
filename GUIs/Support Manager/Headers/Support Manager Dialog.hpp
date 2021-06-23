#include "Support Manager Common Defines.hpp"
#include "..\..\Common GUI Headers\GUI Styles.hpp"

#define PROFILE_BACKGROUND_COLOR(ALPHA)\
{\
	"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",\
	"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",\
	"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",\
	ALPHA\
}
//#define BORDER_COLOR(ALPHA) {0,0,0,ALPHA}
#define BACKGROUND_FRAME_COLOR(ALPHA) {0,0,0,ALPHA}
#define GREY_COLOR(PERCENT,ALPHA) {PERCENT,PERCENT,PERCENT,ALPHA}

/* -------------------------------------------------------------------------
	Dialog
------------------------------------------------------------------------- */
class KISKA_supportManager_Dialog
{
	idd = SM_IDD;
	enableSimulation = 1;
	movingEnabled = 1;
	onLoad = "[_this select 0] call KISKA_fnc_supportManager_onLoad";

	class controlsBackground
	{
	/*
		class supportManager_background_seperator_1: KISKA_RscText
		{
			idc = -1;
			x = 0.505859 * safezoneW + safezoneX;
			y = 0.291667 * safezoneH + safezoneY;
			w = 0.00585938 * safezoneW;
			h = 0.395833 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
	*/
		class supportManager_background_frame: KISKA_RscText
		{
			idc = -1;
			x = 0.330078 * safezoneW + safezoneX;
			y = 0.270833 * safezoneH + safezoneY;
			w = 0.339844 * safezoneW;
			h = 0.458333 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class supportManager_headerText: KISKA_RscText
		{
			idc = -1;
			moving = 1;
			text = "Support Manager"; //--- ToDo: Localize;
			x = 0.330077 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.328125 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
	};

	class controls
	{
		/* -------------------------------------------------------------------------
			List Controls
		------------------------------------------------------------------------- */
		class supportManager_pool_listBox: KISKA_RscListbox
		{
			idc = SM_POOL_LISTBOX_IDC;
			x = 0.335937 * safezoneW + safezoneX;
			y = 0.3125 * safezoneH + safezoneY;
			w = 0.158203 * safezoneW;
			h = 0.375 * safezoneH;
			colorBackground[] = GREY_COLOR(0.25,0.25);
			sizeEx = 0.0208333 * safezoneH;
		};
		class supportManager_current_listBox: KISKA_RscListbox
		{
			idc = SM_CURRENT_LISTBOX_IDC;
			x = 0.505859 * safezoneW + safezoneX;
			y = 0.3125 * safezoneH + safezoneY;
			w = 0.158203 * safezoneW;
			h = 0.375 * safezoneH;
			colorBackground[] = GREY_COLOR(0,0.35);
			sizeEx = 0.0208333 * safezoneH;
		};

		/* -------------------------------------------------------------------------
			Text Controls
		------------------------------------------------------------------------- */
		class supportManager_pool_headerText: KISKA_RscText
		{
			idc = -1;
			text = "Support Pool"; //--- ToDo: Localize;
			x = 0.335937 * safezoneW + safezoneX;
			y = 0.291667 * safezoneH + safezoneY;
			w = 0.158203 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
	/*
		class supportManager_pool_count_headerText: KISKA_RscText
		{
			idc = -1;
			text = "Count"; //--- ToDo: Localize;
			x = 0.464844 * safezoneW + safezoneX;
			y = 0.291667 * safezoneH + safezoneY;
			w = 0.0410156 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
	*/
		class supportManager_current_headerText: KISKA_RscText
		{
			idc = -1;
			text = "Current Supports"; //--- ToDo: Localize;
			x = 0.505859 * safezoneW + safezoneX;
			y = 0.291667 * safezoneH + safezoneY;
			w = 0.158203 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};

		/* -------------------------------------------------------------------------
			Button Controls
		------------------------------------------------------------------------- */
		class supportManager_take_button: KISKA_ctrlButton
		{
			idc = SM_TAKE_BUTTON_IDC;
			style = ST_CENTER;
			text = "Take"; //--- ToDo: Localize;
			x = 0.382812 * safezoneW + safezoneX;
			y = 0.697917 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
		class supportManager_store_button: KISKA_ctrlButton
		{
			idc = SM_STORE_BUTTON_IDC;
			style = ST_CENTER;
			text = "Store"; //--- ToDo: Localize;
			x = 0.558594 * safezoneW + safezoneX;
			y = 0.697917 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
		class supportManager_close_button: KISKA_RscButtonMenu
		{
			idc = SM_CLOSE_BUTTON_IDC;
			text = "";
			x = 0.658203 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.0117188 * safezoneW;
			h = 0.0208333 * safezoneH;

			textureNoShortcut = "\A3\3den\Data\Displays\Display3DEN\search_END_ca.paa";
			class ShortcutPos
			{
				left = 0;
				top = 0;
				w = 0.0117188 * safezoneW;
				h = 0.0208333 * safezoneH;
			};
			animTextureNormal = "#(argb,8,8,3)color(1,0,0,0.57)";
			animTextureDisabled = "";
			animTextureOver = "#(argb,8,8,3)color(1,0,0,0.57)";
			animTextureFocused = "";
			animTexturePressed = "#(argb,8,8,3)color(1,0,0,0.57)";
			animTextureDefault = "";
		};
	};
};
