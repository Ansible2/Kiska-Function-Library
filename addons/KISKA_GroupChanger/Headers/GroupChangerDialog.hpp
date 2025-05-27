#include "GroupChangerCommonDefines.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Grid.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Colors.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Styles.hpp"

#define CHANGER_TRANSPARENCY 0.25
#define LISTBOX_TRANSPARENCY 0.35
#define COMBO_TRANSPARENCY 0.75

class ctrlButton;
class RscText;
class KISKA_RscCloseButton;
class RscListbox;
class RscEdit;
class RscCombo;
class RscCheckbox;

class KISKA_GCH_button : ctrlButton
{
	style = KISKA_ST_CENTER;
};

class KISKA_GCH_dialog
{
	idd = GCH_DIALOG_IDD;
	movingEnabled = 1;
	enableSimulation = 1;
	onLoad = "[_this select 0] call KISKA_fnc_GCHOnload";

	class controlsBackground
	{
		class KISKA_GCH_background: RscText
		{
			idc = -1;
            x = KISKA_POS_X(-16);
			y = KISKA_POS_Y(-12);
			w = KISKA_POS_W(32);
			h = KISKA_POS_H(25);
			colorBackground[] = KISKA_GREY_COLOR(0,0.5);
		};
		class KISKA_GCH_headerText: RscText
		{
			idc = -1;
			text = "Group Manager";
			moving = 1;
            x = KISKA_POS_X(-16);
			y = KISKA_POS_Y(-13);
			w = KISKA_POS_W(31);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_sideGroups_headerText: RscText
		{
			idc = -1;
			text = "Side's Groups";
            x = KISKA_POS_X(-15.5);
			y = KISKA_POS_Y(-11.5);
			w = KISKA_POS_W(15);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_currentGroup_headerText: RscText
		{
			idc = -1;
			text = "Current Group's Units";
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(-10.5);
			w = KISKA_POS_W(10.5);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};

		class KISKA_GCH_showAI_text: RscText
		{
			idc = -1;
			text = "Show AI:";
            x = KISKA_POS_X(11);
			y = KISKA_POS_Y(-10.5);
			w = KISKA_POS_W(3.5);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_groupLeader_text: RscText
		{
			idc = -1;
			text = "Group Leader:";
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(-11.5);
			w = KISKA_POS_W(5);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
        class KISKA_GCH_canRally_text: RscText
		{
			idc = -1;
			text = "Group Can Rally:";
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(10);
			w = KISKA_POS_W(8);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_canBeDeleted_text: RscText
		{
			idc = -1;
			text = "Group Can Be Deleted:";
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(9);
			w = KISKA_POS_W(8);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
		};
        class KISKA_GCH_assignTeam_text: RscText
		{
			idc = -1;
			text = "Assign Unit Team:";
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(8);
			w = KISKA_POS_W(8);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
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
			text = "Join Group";
            x = KISKA_POS_X(-10);
			y = KISKA_POS_Y(11.5);
			w = KISKA_POS_W(5);
			h = KISKA_POS_H(1);
		};
		class KISKA_GCH_leaveGroup_button: KISKA_GCH_button
		{
			idc = GCH_LEAVE_GROUP_BUTTON_IDC;
			text = "Leave Group";
            x = KISKA_POS_X(8.5);
			y = KISKA_POS_Y(11.5);
			w = KISKA_POS_W(4.5);
			h = KISKA_POS_H(1);
			tooltip = "Will leave your current group and create a new one.";
		};
		class KISKA_GCH_close_button: KISKA_RscCloseButton
		{
			idc = GCH_CLOSE_BUTTON_IDC;
            x = KISKA_POS_X(15);
			y = KISKA_POS_Y(-13);
			w = KISKA_POS_W(1);
			h = KISKA_POS_H(1);
		};
		class KISKA_GCH_setLeader_button: KISKA_GCH_button
		{
			idc = GCH_SET_LEADER_BUTTON_IDC;

			text = "Set Leader";
            x = KISKA_POS_X(2.5);
			y = KISKA_POS_Y(11.5);
			w = KISKA_POS_W(4.5);
			h = KISKA_POS_H(1);
		};
		class KISKA_GCH_setGroupID_button: KISKA_GCH_button
		{
			idc = GCH_SET_GROUP_ID_BUTTON_IDC;

			text = "Set Group ID";
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(7);
			w = KISKA_POS_W(5);
			h = KISKA_POS_H(1);
		};

		/* -------------------------------------------------------------------------
			Listbox Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_sideGroups_listBox: RscListbox
		{
			idc = GCH_SIDE_GROUPS_LISTBOX_IDC;
            x = KISKA_POS_X(-15.5);
			y = KISKA_POS_Y(-10.5);
			w = KISKA_POS_W(15);
			h = KISKA_POS_H(21.5);
			colorBackground[] = KISKA_GREY_COLOR(0,LISTBOX_TRANSPARENCY);
		};
		class KISKA_GCH_currentGroup_listBox: RscListbox
		{
			idc = GCH_CURRENT_GROUP_LISTBOX_IDC;
            x = KISKA_POS_X(0.5);
			y = KISKA_POS_Y(-9.5);
			w = KISKA_POS_W(15);
			h = KISKA_POS_H(16.5);
			colorBackground[] = KISKA_GREY_COLOR(0,LISTBOX_TRANSPARENCY);
		};

		/* -------------------------------------------------------------------------
			Edit Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_setGroupID_edit: RscEdit
		{
			idc = GCH_SET_GROUP_ID_EDIT_IDC;

			text = "";
            x = KISKA_POS_X(5.5);
			y = KISKA_POS_Y(7);
			w = KISKA_POS_W(10);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_GREY_COLOR(0,CHANGER_TRANSPARENCY);
		};

		/* -------------------------------------------------------------------------
			Combo Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_groupCanBeDeletedCombo: RscCombo
		{
			idc = GCH_CAN_BE_DELETED_COMBO_IDC;

            x = KISKA_POS_X(8.5);
			y = KISKA_POS_Y(9);
			w = KISKA_POS_W(7);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_GREY_COLOR(0,COMBO_TRANSPARENCY);
		};
		class KISKA_GCH_groupCanRallyCombo: KISKA_GCH_groupCanBeDeletedCombo
		{
			idc = GCH_CAN_RALLY_COMBO_IDC;
			y = KISKA_POS_Y(10);
		};
        class KISKA_GCH_assignTeamCombo: KISKA_GCH_groupCanBeDeletedCombo
		{
			idc = GCH_CAN_ASSIGN_TEAM_COMBO_IDC;
			y = KISKA_POS_Y(8);
		};


		/* -------------------------------------------------------------------------
			Indicator Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_groupLeaderName_indicator: RscText
		{
			idc = GCH_LEADER_NAME_INDICATOR_IDC;
			text = "";
            x = KISKA_POS_X(5.5);
			y = KISKA_POS_Y(-11.5);
			w = KISKA_POS_W(10);
			h = KISKA_POS_H(1);
			colorBackground[] = KISKA_GREY_COLOR(0,CHANGER_TRANSPARENCY);
		};

		/* -------------------------------------------------------------------------
			Misc Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_showAI_checkBox: RscCheckbox
		{
			idc = GCH_SHOW_AI_CHECKBOX_IDC;
            x = KISKA_POS_X(14.5);
			y = KISKA_POS_Y(-10.5);
			w = KISKA_POS_W(1);
			h = KISKA_POS_H(1);
		};
	};
};
