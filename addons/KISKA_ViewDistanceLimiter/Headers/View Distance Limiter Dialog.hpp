#include "View Distance Limiter Common Defines.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\KISKA GUI Grid.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\KISKA GUI Colors.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\GUI Styles.hpp"

class ctrlButton;
class RscXSliderH;
class RscText;
class KISKA_RscCloseButton;
class RscCheckBox;
class RscControlsGroupNoScrollbars;
class RscEdit;


class KISKA_VDL_setting_ctrlGrp: RscControlsGroupNoScrollbars
{
	idc = -1;

	x = POS_X(-7.75);
	y = POS_Y(1);
	w = POS_W(15.5);
	h = POS_H(2.5);
	class controls
	{
		class setButton : ctrlButton
		{
			idc = BUTTON_IDC;
			text = "Button";
			x = POS_W(0.75);
			y = POS_H(0);
			w = POS_W(10.75);
			h = POS_H(1);
		};
		class settingEditBox: RscEdit
		{
			idc = EDIT_IDC;
			text = "123";
			x = POS_W(11.5);
			y = POS_H(0);
			w = POS_W(4);
			h = POS_H(1);
		};
		class settingSlider: RscXSliderH
		{
			idc = SLIDER_IDC;
			x = POS_W(0.75);
			y = POS_H(1);
			w = POS_W(14.75);
			h = POS_H(1);
		};

	};
};


class KISKA_viewDistanceLimiter_dialog
{
	idd = VDL_IDD;
	movingEnabled = 1;
	enableSimulation = 1;
	onLoad = "[_this select 0] call KISKA_fnc_VDL_onLoad";

	class controlsBackground
	{
		class KISKA_VDL_mainFrame: Rsctext
		{
			idc = -1;

            x = POS_X(-7.5);
        	y = POS_Y(-8);
        	w = POS_W(16);
        	h = POS_H(18.5);
			colorBackground[] = GREY_COLOR(0,0.25);
		};
		class KISKA_VDL_mainHeaderText: Rsctext
		{
			idc = -1;

			moving = 1;
			text = "View Distance Limiter";
            x = POS_X(-7.5);
        	y = POS_Y(-10);
        	w = POS_W(15);
        	h = POS_H(1);
			colorBackground[] = PROFILE_BACKGROUND_COLOR(0.65);
			style = ST_CENTER;
		};
		class KISKA_VDL_systemOn_headerText: RscText
		{
			idc = -1;

			text = "System On:";
            x = POS_X(-7.5);
        	y = POS_Y(-9);
        	w = POS_W(3);
        	h = POS_H(1);
			colorBackground[] = GREY_COLOR(0,1);
		};
		class KISKA_VDL_tiedViewDistance_headerText: RscText
		{
			idc = -1;

			text = "Tied View Distance:";
            x = POS_X(2.5);
        	y = POS_Y(-9);
        	w = POS_W(5);
        	h = POS_H(1);
			colorBackground[] = GREY_COLOR(0,1);
		};
	};

	class controls
	{
		/* -------------------------------------------------------------------------
			General Controls
		------------------------------------------------------------------------- */
		class KISKA_VDL_close_button: KISKA_RscCloseButton
		{
			idc = VDL_CLOSE_BUTTON_IDC;
            x = POS_X(7.5);
        	y = POS_Y(-10);
        	w = POS_W(1);
        	h = POS_H(1);
		};
		class KISKA_VDL_setAll_button: ctrlButton
		{
			idc = VDL_SET_ALL_BUTTON_IDC;

			text = "Set All Changes";
            x = POS_X(-3.5);
        	y = POS_Y(-9);
        	w = POS_W(6);
        	h = POS_H(1);
			sizeEx = GUI_TEXT_SIZE(1);
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
		};
		class KISKA_VDL_tiedViewDistance_checkBox: RscCheckBox
		{
			idc = VDL_TIED_DISTANCE_CHECKBOX_IDC;

            x = POS_X(7.5);
        	y = POS_Y(-9);
        	w = POS_W(1);
        	h = POS_H(1);
			colorText[] = GREY_COLOR(0,1);
			colorActive[] = GREY_COLOR(0,1);
		};

		/* -------------------------------------------------------------------------
			Target FPS
		------------------------------------------------------------------------- */
		class KISKA_VDL_targetFPS_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = VDL_TARGET_FPS_CTRL_GRP_IDC;
			y = POS_Y(-7.5);

			class controls : controls
			{
				class setButton: setButton
				{
					text = "Set Target FPS";
					tooltip = "The FPS that you want to achieve to have while the system is running";
				};
				class settingSlider: settingSlider
				{
					sliderPosition = 60;
		            sliderRange[] = {15,144};
		            sliderStep = 1;
					lineSize = 1;
				};
				class settingEditBox: settingEditBox
				{
				};
			};
		};

		/* -------------------------------------------------------------------------
			Min Obj View Distance
		------------------------------------------------------------------------- */
		class KISKA_VDL_minObjectDist_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = VDL_MIN_OBJECT_DIST_CTRL_GRP_IDC;

			y = POS_Y(-4.5);

			class controls : controls
			{
				class setButton: setButton
				{
					text = "Set Min Object Distance";
					tooltip = "The minimum distance your Object View Distance can be set to";
				};
				class settingSlider: settingSlider
				{
					sliderPosition = 500;
					sliderRange[] = {100,3000};
					sliderStep = 1;
					lineSize = 10;
				};
				class settingEditBox: settingEditBox
				{
				};
			};
		};

		/* -------------------------------------------------------------------------
			Max Obj View Distance
		------------------------------------------------------------------------- */
		class KISKA_VDL_maxObjectDist_ctrlGrp: KISKA_VDL_minObjectDist_ctrlGrp
		{
			idc = VDL_MAX_OBJECT_DIST_CTRL_GRP_IDC;
			y = POS_Y(-1.5);

			class controls : controls
			{
				class setButton: setButton
				{
					text = "Set Max Object Distance";
					tooltip = "The maximum distance your Object View Distance can be set to";
				};
				class settingSlider: settingSlider
				{
				};
				class settingEditBox: settingEditBox
				{
				};
			};
		};

		/* -------------------------------------------------------------------------
			Terrain View Distance
		------------------------------------------------------------------------- */
		class KISKA_VDL_terrainDist_ctrlGrp: KISKA_VDL_minObjectDist_ctrlGrp
		{
			idc = VDL_TERRAIN_DIST_CTRL_GRP_IDC;

			y = POS_Y(1.5);
			class controls : controls
			{
				class setButton: setButton
				{
					text = "Set Terrain View Distance";
					tooltip = "The overall (static) view distance; this can be rather high without an issue.";
				};
				class settingSlider: settingSlider
				{
				};
				class settingEditBox: settingEditBox
				{
				};
			};
		};

		/* -------------------------------------------------------------------------
			Check Frequency
		------------------------------------------------------------------------- */
		class KISKA_VDL_checkFreq_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = VDL_CHECK_FREQ_CTRL_GRP_IDC;
			y = POS_Y(4.5);
			class controls : controls
			{
				class setButton: setButton
				{
					text = "Set Check Frequency";
					tooltip = "This is how often the view distance will be adjusted in seconds";
				};
				class settingSlider: settingSlider
				{
					sliderPosition = 1;
		            sliderRange[] = {0.01,10};
		            sliderStep = 0.01;
					lineSize = 0.05;
				};
				class settingEditBox: settingEditBox
				{
				};
			};
		};

		/* -------------------------------------------------------------------------
			Increment Size
		------------------------------------------------------------------------- */
		class KISKA_VDL_incriment_ctrlGrp: KISKA_VDL_setting_ctrlGrp
		{
			idc = VDL_INCRIMENT_CTRL_GRP_IDC;
			y = POS_Y(7.5);

			class controls : controls
			{
				class setButton: setButton
				{
					text = "Set Increment Size";
					tooltip = "By how much will the view distance be adjusted in meters to achieve the target FPS each check frequency?"
				};
				class settingSlider: settingSlider
				{
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
};
