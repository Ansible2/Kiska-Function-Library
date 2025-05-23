#include "Support Manager Common Defines.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Grid.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Colors.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Styles.hpp"

class RscText;
class RscListbox;
class ctrlButton;
class KISKA_RscCloseButton;

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
		class supportManager_background_frame: RscText
		{
			idc = -1;
			x = KISKA_POS_X(-14.5);
			y = KISKA_POS_Y(-11);
			w = KISKA_POS_W(29);
			h = KISKA_POS_H(22);
			colorBackground[] = KISKA_GREY_COLOR(0,0.5);
		};
		class supportManager_headerText: RscText
		{
			idc = -1;
			moving = 1;
			text = "Support Manager";
            x = KISKA_POS_X(-14.5);
			y = KISKA_POS_Y(-12);
			w = KISKA_POS_W(28);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
        /* -------------------------------------------------------------------------
			Text Controls
		------------------------------------------------------------------------- */
		class supportManager_pool_headerText: RscText
		{
			idc = -1;
			text = "Support Pool";
            x = KISKA_POS_X(-14);
			y = KISKA_POS_Y(-10);
			w = KISKA_POS_W(13.5);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_GREY_COLOR(0,1);
		};
		class supportManager_current_headerText: supportManager_pool_headerText
		{
			text = "Current Supports";
            x = KISKA_POS_X(0.5);
		};
	};

	class controls
	{
		/* -------------------------------------------------------------------------
			List Controls
		------------------------------------------------------------------------- */
		class supportManager_pool_listBox: RscListbox
		{
			idc = SM_POOL_LISTBOX_IDC;
            x = KISKA_POS_X(-14);
			y = KISKA_POS_Y(-9);
			w = KISKA_POS_W(13.5);
			h = KISKA_POS_H(18);
			colorBackground[] = KISKA_GREY_COLOR(0.25,0.35);
			sizeEx = KISKA_GUI_TEXT_SIZE(2.5);
		};
		class supportManager_current_listBox: supportManager_pool_listBox
		{
			idc = SM_CURRENT_LISTBOX_IDC;
            x = KISKA_POS_X(0.5);
		};

		/* -------------------------------------------------------------------------
			Button Controls
		------------------------------------------------------------------------- */
		class supportManager_take_button: ctrlButton
		{
			idc = SM_TAKE_BUTTON_IDC;
			style = KISKA_ST_CENTER;
			text = "Take";
            x = KISKA_POS_X(-10);
			y = KISKA_POS_Y(9.5);
			w = KISKA_POS_W(5);
			h = KISKA_POS_H(1);
		};
		class supportManager_store_button: supportManager_take_button
		{
			idc = SM_STORE_BUTTON_IDC;
			style = KISKA_ST_CENTER;
			text = "Store";
            x = KISKA_POS_X(5);
		};
		class supportManager_close_button: KISKA_RscCloseButton
		{
			idc = SM_CLOSE_BUTTON_IDC;
            x = KISKA_POS_X(13.5);
			y = KISKA_POS_Y(-12);
			w = KISKA_POS_W(1);
			h = KISKA_POS_H(1);
		};
	};
};
