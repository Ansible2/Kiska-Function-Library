#include "GroupChangerCommonDefines.hpp"

#define CHANGER_TRANSPARENCY 0.25
#define LISTBOX_TRANSPARENCY 0.35
#define GREY_COLOR(PERCENT,ALPHA) {PERCENT,PERCENT,PERCENT,ALPHA}

class KISKA_GCH_button : KISKA_RscButton
{
	colorBackground[] = {-1,-1,-1,1};
	colorBackgroundActive[] = PROFILE_BACKGROUND_COLOR(0.5);
	colorFocused[] = {-1,-1,-1,1};
	font = "RobotoCondensedLight";
};

class KISKA_GCH_dialog
{
	idd = GCH_DIALOG_IDD;
	movingEnabled = true;
	enableSimulation = true;
	onLoad = "[_this select 0] call KISKA_fnc_GCH_dialogOnLoad";

	class controlsBackground
	{
		class KISKA_GCH_background: KISKA_RscText
		{
			idc = -1;
			x = 0.347656 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.304688 * safezoneW;
			h = 0.520833 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class KISKA_GCH_headerText: KISKA_RscText
		{
			idc = -1;
			text = "Group Changer"; //--- ToDo: Localize;
			x = 0.347657 * safezoneW + safezoneX;
			y = 0.229167 * safezoneH + safezoneY;
			w = 0.292969 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_sideGroups_headerText: KISKA_RscText
		{
			idc = -1;
			text = "Side's Groups"; //--- ToDo: Localize;
			x = 0.353516 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_currentGroup_headerText: KISKA_RscText
		{
			idc = -1;
			text = "Current Group's Units"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.09375 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_canRally_text: KISKA_RscText
		{
			idc = -1;
			text = "Group Can Rally:"; //--- ToDo: Localize;
			
			x = 0.5 * safezoneW + safezoneX;
			y = 0.708333 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_showAI_text: KISKA_RscText
		{
			idc = -1;
			text = "Show AI:"; //--- ToDo: Localize;
			x = 0.59375 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.0410156 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_groupLeader_text: KISKA_RscText
		{
			idc = -1;
			text = "Group Leader:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.28125 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_canBeDeleted_text: KISKA_RscText
		{
			idc = -1;
			text = "Group Can Be Deleted:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.6875 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
	};

	class controls
	{
		/* -------------------------------------------------------------------------
			Button Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_joinGroup_button: KISKA_GCH_button
		{
			idc = GCH_JOIN_GROUP_BUTTON_IDC;
			text = "Join Group"; //--- ToDo: Localize;
			x = 0.394531 * safezoneW + safezoneX;
			y = 0.739583 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
		class KISKA_GCH_leaveGroup_button: KISKA_GCH_button
		{
			idc = GCH_LEAVE_GROUP_BUTTON_IDC;
			text = "Leave Group"; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.739583 * safezoneH + safezoneY;
			w = 0.0527344 * safezoneW;
			h = 0.0208333 * safezoneH;
			tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
		};
		class KISKA_GCH_close_button: KISKA_RscButtonMenu
		{
			idc = GCH_CLOSE_BUTTON_IDC;
			text = ""; //--- ToDo: Localize;
			x = 0.640625 * safezoneW + safezoneX;
			y = 0.229167 * safezoneH + safezoneY;
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
		class KISKA_GCH_setLeader_button: KISKA_GCH_button
		{
			idc = GCH_SET_LEADER_BUTTON_IDC;

			text = "Set Leader"; //--- ToDo: Localize;
			x = 0.505859 * safezoneW + safezoneX;
			y = 0.739583 * safezoneH + safezoneY;
			w = 0.046875 * safezoneW;
			h = 0.0208333 * safezoneH;
			//tooltip = ""; //--- ToDo: Localize;
		};
		class KISKA_GCH_setGroupID_button: KISKA_GCH_button
		{
			idc = GCH_SET_GROUP_ID_BUTTON_IDC;

			text = "Set Group ID"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.666667 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
		};

		/* -------------------------------------------------------------------------
			Listbox Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_sideGroups_listBox: KISKA_RscListbox
		{
			idc = GCH_SIDE_GROUPS_LISTBOX_IDC;
			x = 0.353516 * safezoneW + safezoneX;
			y = 0.28125 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.447917 * safezoneH;
			colorBackground[] = {-1,-1,-1,LISTBOX_TRANSPARENCY};
		};
		class KISKA_GCH_currentGroup_listBox: KISKA_RscListbox
		{
			idc = GCH_CURRENT_GROUP_LISTBOX_IDC;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.302084 * safezoneH + safezoneY;
			w = 0.146484 * safezoneW;
			h = 0.364583 * safezoneH;
			colorBackground[] = {-1,-1,-1,LISTBOX_TRANSPARENCY};
		};

		/* -------------------------------------------------------------------------
			Edit Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_setGroupID_edit: KISKA_RscEdit
		{
			idc = GCH_SET_GROUP_ID_EDIT_IDC;

			text = "Some Group ID"; //--- ToDo: Localize;
			x = 0.558594 * safezoneW + safezoneX;
			y = 0.666667 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,CHANGER_TRANSPARENCY};
		};

		/* -------------------------------------------------------------------------
			Combo Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_groupCanBeDeletedCombo: KISKA_RscCombo
		{
			idc = GCH_CAN_BE_DELETED_COMBO_IDC;

			x = 0.587891 * safezoneW + safezoneX;
			y = 0.6875 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.75};
		};
		class KISKA_GCH_groupCanRallyCombo: KISKA_RscCombo
		{
			idc = GCH_CAN_RALLY_COMBO_IDC;

			x = 0.587891 * safezoneW + safezoneX;
			y = 0.708333 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.75};
		};


		/* -------------------------------------------------------------------------
			Indicator Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_groupLeaderName_indicator: KISKA_RscText
		{
			idc = GCH_LEADER_NAME_INDICATOR_IDC;
			text = "Some Unit Name"; //--- ToDo: Localize;
			x = 0.558594 * safezoneW + safezoneX;
			y = 0.28125 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,CHANGER_TRANSPARENCY};
		};

		/* -------------------------------------------------------------------------
			Misc Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_showAI_checkBox: KISKA_RscCheckbox
		{
			idc = GCH_SHOW_AI_CHECKBOX_IDC;
			x = 0.634766 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.0117188 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
	};
};










/*
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Gill, v1.063, #Cocizo)
////////////////////////////////////////////////////////

class KISKA_GCH_background: KISKA_RscText
{
	idc = 1000;
	x = 0.347656 * safezoneW + safezoneX;
	y = 0.25 * safezoneH + safezoneY;
	w = 0.304688 * safezoneW;
	h = 0.520833 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.25};
};
class KISKA_GCH_headerText: KISKA_RscText
{
	idc = 1001;
	text = "Group Changer"; //--- ToDo: Localize;
	x = -13 * UI_GRID_W + UI_GRID_X;
	y = -13 * UI_GRID_H + UI_GRID_Y;
	w = 25 * UI_GRID_W;
	h = 0.999998 * UI_GRID_H;
	colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
};
class KISKA_GCH_sideGroups_headerText: KISKA_RscText
{
	idc = 1002;
	text = "Side's Groups"; //--- ToDo: Localize;
	x = -12.5 * UI_GRID_W + UI_GRID_X;
	y = -11.5 * UI_GRID_H + UI_GRID_Y;
	w = 12 * UI_GRID_W;
	h = 0.999998 * UI_GRID_H;
	colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
};
class KISKA_GCH_currentGroup_headerText: KISKA_RscText
{
	idc = 1003;
	text = "Current Group's Units"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.260417 * safezoneH + safezoneY;
	w = 0.09375 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
};
class KISKA_GCH_canRally_text: KISKA_RscText
{
	idc = 1004;
	text = "Group Can Rally:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.708333 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_showAI_text: KISKA_RscText
{
	idc = 1005;
	text = "Show AI:"; //--- ToDo: Localize;
	x = 8 * UI_GRID_W + UI_GRID_X;
	y = -11.5 * UI_GRID_H + UI_GRID_Y;
	w = 3.5 * UI_GRID_W;
	h = 0.999998 * UI_GRID_H;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_groupLeader_text: KISKA_RscText
{
	idc = 1006;
	text = "Group Leader:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.28125 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_canBeDeleted_text: KISKA_RscText
{
	idc = 1007;
	text = "Group Can Be Deleted:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.6875 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_joinGroup_button: KISKA_RscButton
{
	idc = 5281;

	text = "Join Group"; //--- ToDo: Localize;
	x = 0.394531 * safezoneW + safezoneX;
	y = 0.739583 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_leaveGroup_button: KISKA_RscButton
{
	idc = 5282;

	text = "Leave Group"; //--- ToDo: Localize;
	x = 0.587891 * safezoneW + safezoneX;
	y = 0.739583 * safezoneH + safezoneY;
	w = 0.0527344 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
	tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
};
class KISKA_GCH_close_button: KISKA_RscButtonMenu
{
	idc = 5283;
	textureNoShortcut = "\A3\3den\Data\Displays\Display3DEN\search_END_ca.paa";
	animTextureNormal = "#(argb,8,8,3)color(1,0,0,0.57)";
	animTextureDisabled = "";
	animTextureOver = "#(argb,8,8,3)color(1,0,0,0.57)";
	animTextureFocused = "";
	animTexturePressed = "#(argb,8,8,3)color(1,0,0,0.57)";
	animTextureDefault = "";

	x = 12 * UI_GRID_W + UI_GRID_X;
	y = -13 * UI_GRID_H + UI_GRID_Y;
	w = 1 * UI_GRID_W;
	h = 0.999998 * UI_GRID_H;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0,0,0,0.8};
};
class KISKA_GCH_sideGroups_listBox: KISKA_RscListBox
{
	idc = 5284;

	x = 0.353516 * safezoneW + safezoneX;
	y = 0.28125 * safezoneH + safezoneY;
	w = 0.140625 * safezoneW;
	h = 0.447917 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.5};
};
class KISKA_GCH_currentGroup_listBox: KISKA_RscListBox
{
	idc = 5285;

	x = 0.5 * safezoneW + safezoneX;
	y = 0.302084 * safezoneH + safezoneY;
	w = 0.146484 * safezoneW;
	h = 0.364583 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.5};
};
class KISKA_GCH_groupLeaderName_indicator: KISKA_RscText
{
	idc = 5287;

	text = "Some Unit Name"; //--- ToDo: Localize;
	x = 0.558594 * safezoneW + safezoneX;
	y = 0.28125 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.5};
};
class KISKA_GCH_showAI_checkBox: KISKA_RscCheckBox
{
	idc = 5290;

	x = 0.634766 * safezoneW + safezoneX;
	y = 0.260417 * safezoneH + safezoneY;
	w = 0.0117188 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_setLeader_button: KISKA_RscButton
{
	idc = 5282;

	text = "Set Leader"; //--- ToDo: Localize;
	x = 0.505859 * safezoneW + safezoneX;
	y = 0.739583 * safezoneH + safezoneY;
	w = 0.046875 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
	tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
};
class KISKA_GCH_setGroupID_button: KISKA_RscButton
{
	idc = 5282;

	text = "Set Group ID"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.666667 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
	tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
};
class KISKA_GCH_groupCanBeDeletedCombo: RscText
{
	idc = 5285;

	x = 0.587891 * safezoneW + safezoneX;
	y = 0.6875 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.5};
};
class KISKA_GCH_groupCanRallyCombo: RscText
{
	idc = 5285;

	x = 0.587891 * safezoneW + safezoneX;
	y = 0.708333 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.5};
};
class KISKA_GCH_setGroupID_edit: RscText
{
	idc = 5287;

	text = "Some Group Name"; //--- ToDo: Localize;
	x = 0.558594 * safezoneW + safezoneX;
	y = 0.666667 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.5};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
*/