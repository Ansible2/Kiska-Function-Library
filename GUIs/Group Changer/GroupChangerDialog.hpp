#include "GroupChangerCommonDefines.hpp"
#include "GroupChangerDialogBases.hpp"


class KISKA_GCH_dialog
{
	idd = GROUP_CHANGER_DIALOG_IDD
	movingEnabled = true;
	enableSimulation = true;
	onLoad = "[_this select 0] call KISKA_fnc_GCH_onLoad"

	class controlsBackground
	{
		class KISKA_GCH_background: RscText
		{
			idc = -1;
			x = 0.347656 * safezoneW + safezoneX;
			y = 0.25 * safezoneH + safezoneY;
			w = 0.304688 * safezoneW;
			h = 0.520833 * safezoneH;
			colorBackground[] = PROFILE_BACKGROUND_COLOR(1);
		};
		class KISKA_GCH_headerText: RscText
		{
			idc = -1;
			text = "Group Changer"; //--- ToDo: Localize;
			x = 0.347657 * safezoneW + safezoneX;
			y = 0.229167 * safezoneH + safezoneY;
			w = 0.292969 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_sideGroups_text: RscText
		{
			idc = -1;
			text = "Side's Groups"; //--- ToDo: Localize;
			x = 0.353516 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_currentGroup_text: RscText
		{
			idc = -1;
			text = "Current Group's Players"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.09375 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_canRally_text: RscText
		{
			idc = -1;
			text = "Group Can Rally:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.6875 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_showAI_text: RscText
		{
			idc = -1;
			text = "Show AI:"; //--- ToDo: Localize;
			x = 0.59375 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.0410156 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_groupLeader_text: RscText
		{
			idc = -1;
			text = "Group Leader:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_canBeDeleted_text: RscText
		{
			idc = -1;
			text = "Group Can Be Deleted:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.666667 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_leaderIsPlayer_text: RscText
		{
			idc = -1;
			text = "Group Leader Is Player:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.645833 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};

	};

	class controls
	{
		/* -------------------------------------------------------------------------
			Button Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_joinGroup_button: RscButton
		{
			idc = GROUP_CHANGER_JOIN_GROUP_BUTTON_IDC;
			text = "Join Group"; //--- ToDo: Localize;
			x = 0.359375 * safezoneW + safezoneX;
			y = 0.729167 * safezoneH + safezoneY;
			w = 0.0703125 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
		class KISKA_GCH_leaveGroup_button: RscButton
		{
			idc = GROUP_CHANGER_LEAVE_GROUP_BUTTON_IDC;
			text = "Leave Group"; //--- ToDo: Localize;
			x = 0.570313 * safezoneW + safezoneX;
			y = 0.729167 * safezoneH + safezoneY;
			w = 0.0703125 * safezoneW;
			h = 0.0208333 * safezoneH;
			tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
		};
		class KISKA_GCH_close_button: RscButton
		{
			idc = GROUP_CHANGER_CLOSE_BUTTON_IDC;
			text = "X"; //--- ToDo: Localize;
			x = 0.640625 * safezoneW + safezoneX;
			y = 0.229167 * safezoneH + safezoneY;
			w = 0.0117188 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {1,-1,-1,1};
		};

		/* -------------------------------------------------------------------------
			Listbox Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_sideGroups_listBox: RscListbox
		{
			idc = GROUP_CHANGER_SIDE_GROUPS_LISTBOX_IDC;
			x = 0.353516 * safezoneW + safezoneX;
			y = 0.28125 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.427083 * safezoneH;
		};
		class KISKA_GCH_currentGroup_listBox: RscListbox
		{
			idc = GROUP_CHANGER_CURRENT_GROUP_LISTBOX_IDC;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.28125 * safezoneH + safezoneY;
			w = 0.146484 * safezoneW;
			h = 0.34375 * safezoneH;
		};

		/* -------------------------------------------------------------------------
			Indicator Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_canRally_indicator: RscText
		{
			idc = GROUP_CHANGER_CAN_RALLY_INDICATOR_IDC;
			text = ""; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.6875 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_groupLeaderName_indicator: RscText
		{
			idc = GROUP_CHANGER_LEADER_NAME_INDICATOR_IDC;
			text = "Some Unit Name"; //--- ToDo: Localize;
			x = 0.558594 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_canBeDeleted_indicator: RscText
		{
			idc = GROUP_CHANGER_CAN_BE_DELETED_INDICATOR_IDC;
			text = "YES"; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.666667 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_leaderIsPlayer_text_indicator: RscText
		{
			idc = GROUP_CHANGER_LEADER_IS_PLAYER_INDICATOR_IDC;
			text = "YES"; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.645833 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};

		/* -------------------------------------------------------------------------
			Misc Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_showAI_checkBox: RscCheckbox
		{
			idc = GROUP_CHANGER_SHOW_AI_CHECKBOX_IDC;
			x = 0.634766 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.0117188 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
	};
};


















