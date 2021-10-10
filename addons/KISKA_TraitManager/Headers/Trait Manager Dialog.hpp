#include "Trait Manager Common Defines.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\KISKA GUI Grid.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\KISKA GUI Colors.hpp"
#include "\KISKA_Functions\GUIs\Common GUI Headers\GUI Styles.hpp"

class RscText;
class RscListbox;
class ctrlButton;
class RscButtonMenu;

/* -------------------------------------------------------------------------
	Dialog
------------------------------------------------------------------------- */
class KISKA_traitManager_Dialog
{
	idd = TM_IDD;
	enableSimulation = 1;
	movingEnabled = 1;
	onLoad = "[_this select 0] call KISKA_fnc_traitManager_onLoad";

	class controlsBackground
	{
		class traitManager_background_frame: RscText
		{
			idc = -1;
            x = POS_X(-14.5);
			y = POS_Y(-11);
			w = POS_W(29);
			h = POS_H(22);
			colorBackground[] = GREY_COLOR(0.1,0.65);
		};
		class traitManager_headerText: RscText
		{
			idc = -1;
			text = "Trait Manager"; //--- ToDo: Localize;
			moving = 1;
			x = POS_X(-14.5);
			y = POS_Y(-12);
			w = POS_W(28);
			h = POS_H(1);
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
	};

	class controls
	{
		/* -------------------------------------------------------------------------
			List Controls
		------------------------------------------------------------------------- */
		class traitManager_pool_listBox: RscListbox
		{
			idc = TM_POOL_LISTBOX_IDC;
            x = POS_X(-14);
			y = POS_Y(-9);
			w = POS_W(13.5);
			h = POS_H(18);
			colorBackground[] = GREY_COLOR(0,0.25);
			sizeEx = 0.0208333 * safezoneH;
		};
		class traitManager_current_listBox: traitManager_pool_listBox
		{
			idc = TM_CURRENT_LISTBOX_IDC;
            x = POS_X(0.5);
			colorBackground[] = GREY_COLOR(0,0.35);
		};

		/* -------------------------------------------------------------------------
			Text Controls
		------------------------------------------------------------------------- */
		class traitManager_pool_headerText: RscText
		{
			idc = -1;
			text = "Trait Pool";
            x = POS_X(-14);
			y = POS_Y(-10);
			w = POS_W(13.5);
			h = POS_H(1);
			colorBackground[] = GREY_COLOR(0,1);
		};

		class traitManager_current_headerText: traitManager_pool_headerText
		{
			text = "Current Traits";
            x = POS_X(0.5);
		};

		/* -------------------------------------------------------------------------
			Button Controls
		------------------------------------------------------------------------- */
		class traitManager_take_button: ctrlButton
		{
			idc = TM_TAKE_BUTTON_IDC;
			style = ST_CENTER;
			text = "Take";
            x = POS_X(-10);
			y = POS_Y(9.5);
			w = POS_W(5);
			h = POS_H(1);
		};
		class traitManager_store_button: traitManager_take_button
		{
			idc = TM_STORE_BUTTON_IDC;
			text = "Store";
            x = POS_X(5);
		};
		class traitManager_close_button: RscButtonMenu
		{
			idc = TM_CLOSE_BUTTON_IDC;
			text = "";
            x = POS_X(13.5);
			y = POS_Y(-12);
			w = POS_W(1);
			h = POS_H(1);

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
	};
};
