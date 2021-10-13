#include "View Distance Limiter Common Defines.hpp"
//#include "\KISKA_Functions\guis\view distance limiter\viewdistancelimitercommondefines.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\KISKA GUI Grid.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\KISKA GUI Colors.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\GUI Styles.hpp"

#define GUI_TEXT_SIZE(MULTIPLIER) 0.0208333 * safezoneH * MULTIPLIER

#define BUTTON_IDC 562700
#define SLIDER_IDC 562701
#define EDIT_IDC 562702


class ctrlButton;
class RscXSliderH;
class RscText;
class RscButtonMenu;
class RscCheckBox;
class RscControlsGroupNoScrollbars;
class RscEdit;


class KISKA_VDL_setting_ctrlGrp: RscControlsGroupNoScrollbars
{
	idc = -1;

	x = POS_X(-7);
	y = POS_Y(0);
	w = POS_W(15);
	h = POS_H(2.5);

	class setButton : ctrlButton
	{
		idc = BUTTON_IDC;
		text = "Button";
		x = POS_W(0);
	    y = POS_H(0);
	    w = POS_W(11.5);
	    h = POS_H(1);
		sizeEx = GUI_TEXT_SIZE(1);
	};

	class settingSlider: RscXSliderH
	{
		idc = SLIDER_IDC;
		x = POS_W(0);
	    y = POS_H(1);
	    w = POS_W(15);
	    h = POS_H(1.5);
	};
	class settingEditBox: RscEdit
	{
		idc = EDIT_IDC;
		text = "123";
		x = POS_W(11.5);
	    y = POS_H(0);
	    w = POS_W(3.5);
	    h = POS_H(1);
		sizeEx = GUI_TEXT_SIZE(1);
	};
};


class KISKA_viewDistanceLimiter_Dialog
{
	idd = VIEW_DISTANCE_LIMITER_DIALOG_IDD;
	movingEnabled = true;
	enableSimulation = true;
	onLoad = "[_this select 0] call KISKA_fnc_VDL_dialogOnLoad";

	class controlsBackground
	{
		class KISKA_VDL_mainFrame: Rsctext
		{
			idc = VDL_FRAME_IDC;

            x = POS_X(-7.5);
        	y = POS_Y(-8);
        	w = POS_W(16);
        	h = POS_H(18.5);
		};
		class KISKA_VDL_mainHeaderText: Rsctext
		{
			idc = VDL_HEADER_TEXT_IDC;
			moving = 1;
			text = "View Distance Limiter";
            x = POS_X(-7.5);
        	y = POS_Y(-10);
        	w = POS_W(15);
        	h = POS_H(1);
			colorBackground[] = PROFILE_BACKGROUND_COLOR(0.65);
			style = ST_CENTER;
			sizeEx = GUI_TEXT_SIZE(1);
		};
		class KISKA_VDL_systemOn_headerText: RscText
		{
			idc = VDL_SYSTEM_ON_TEXT_IDC;

			text = "System On:";
            x = POS_X(-7.5);
        	y = POS_Y(-9);
        	w = POS_W(3);
        	h = POS_H(1);
			colorBackground[] = GREY_COLOR(0,1);
		};
	};

	class controls
	{
		/* -------------------------------------------------------------------------
			General Controls
		------------------------------------------------------------------------- */
		class KISKA_VDL_close_button: RscButtonMenu
		{
			idc = VDL_SYSTEM_ON_CHECKBOX_IDC;
			text = "";
            x = POS_X(7.5);
        	y = POS_Y(-10);
        	w = POS_W(1);
        	h = POS_H(1);
			colorText[] = GREY_COLOR(0,1);
			colorActive[] = GREY_COLOR(0,1);
			textureNoShortcut = "\A3\3den\Data\Displays\Display3DEN\search_END_ca.paa";
			class ShortcutPos
			{
				left = 0;
				top = 0;
                w = POS_W(1);
    			h = POS_H(1);
			};
			animTextureNormal = "#(argb,8,8,3)color(1,0,0,0.57)";
			animTextureDisabled = "";
			animTextureOver = "#(argb,8,8,3)color(1,0,0,0.57)";
			animTextureFocused = "";
			animTexturePressed = "#(argb,8,8,3)color(1,0,0,0.57)";
			animTextureDefault = "";
		};
		class KISKA_VDL_setAll_button: ctrlButton
		{
			idc = VDL_SET_ALL_BUTTON_IDC;

			text = "Set All Changes";
            x = POS_X(-3.5);
        	y = POS_Y(-9);
        	w = POS_W(12);
        	h = POS_H(1);
			//onButtonClick = "_this call KISKA_fnc_setAllVDLButton";
			//sizeEx = 0.03125 * safezoneH;
		};
		class KISKA_VDL_systemOn_checkBox: RscCheckBox
		{
			idc = VDL_SYSTEM_ON_CHECKBOX_IDC;

            x = POS_X(-4.5);
        	y = POS_Y(-9);
        	w = POS_W(1);
        	h = POS_H(1);
			colorText[] = GREY_COLOR(0,1);
			colorActive[] = GREY_COLOR(0,1);
			//onCheckedChanged = "_this call KISKA_fnc_handleVdlGUICheckBox";
			//onload = "(_this select 0) cbSetChecked (call KISKA_fnc_isVDLSystemRunning)";
		};

		/* -------------------------------------------------------------------------
			Target FPS
		------------------------------------------------------------------------- */
		class KISKA_VDL_targetFPS_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = 520007;
			y = POS_Y(-7.5);

			class setButton: setButton
			{
				text = "Set Target FPS";
			};
			class settingSlider: settingSlider
			{
				tooltip = "The FPS that you want to achieve to have while the system is running";
				sliderPosition = 60;
	            sliderRange[] = {15,144};
	            sliderStep = 1;
				lineSize = 1;
			};
			class settingEditBox: settingEditBox
			{
			};
		};

		/* -------------------------------------------------------------------------
			Min Obj View Distance
		------------------------------------------------------------------------- */
		class KISKA_VDL_minObjectDist_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = 520009;

			y = POS_Y(-4.5);

			class setButton: setButton
			{
				text = "Set Min Object Distance";
			};
			class settingSlider: settingSlider
			{
				tooltip = "The minimum distance your Object View Distance can be set to";
				sliderPosition = 500;
	            sliderRange[] = {100,3000};
	            sliderStep = 1;
				lineSize = 10;
			};
			class settingEditBox: settingEditBox
			{
			};
		};

		/* -------------------------------------------------------------------------
			Max Obj View Distance
		------------------------------------------------------------------------- */
		class KISKA_VDL_maxObjectDist_ctrlGrp: KISKA_VDL_minObjectDist_ctrlGrp
		{
			idc = 520010;

			y = POS_Y(-1.5);

			class setButton: setButton
			{
				text = "Set Max Object Distance";
			};
			class settingSlider: settingSlider
			{
				tooltip = "The maximum distance your Object View Distance can be set to";
			};
			class settingEditBox: settingEditBox
			{
			};
		};

		/* -------------------------------------------------------------------------
			Terrain View Distance
		------------------------------------------------------------------------- */
		class KISKA_VDL_terrainDist_ctrlGrp: KISKA_VDL_minObjectDist_ctrlGrp
		{
			idc = 520010;

			y = POS_Y(0.5);

			class setButton: setButton
			{
				text = "Set Terrain View Distance";
			};
			class settingSlider: settingSlider
			{
				tooltip = "The overall (static) view distance; this can be rather high without an issue.";
			};
			class settingEditBox: settingEditBox
			{
			};
		};

		/* -------------------------------------------------------------------------
			Check Frequency
		------------------------------------------------------------------------- */
		class KISKA_VDL_checkFreq_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = 520008;

			y = POS_Y(2.5);

			class setButton: setButton
			{
				text = "Set Check Frequency";
			};
			class settingSlider: settingSlider
			{
				tooltip = "This is how often the view distance will be adjusted in seconds";
				sliderPosition = 1;
	            sliderRange[] = {0.01,10};
	            sliderStep = 0.01;
				lineSize = 0.05;
			};
			class settingEditBox: settingEditBox
			{
			};
		};

		/* -------------------------------------------------------------------------
			Increment Size
		------------------------------------------------------------------------- */
		class KISKA_VDL_incriment_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = 520011;

			y = POS_Y(4.5);

			class setButton: setButton
			{
				text = "Set Increment Size";
			};
			class settingSlider: settingSlider
			{
				tooltip = "By how much will the view distance be adjusted in meters to achieve the target FPS each check frequency?"
				sliderPosition = 25;
	            sliderRange[] = {1,500};
	            sliderStep = 5;
				lineSize = 10;
			};
			class settingEditBox: settingEditBox
			{
			};
		};

	};
};
