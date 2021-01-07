#include "GroupChangerCommonDefines.hpp"

class KISKA_GCH_dialog
{
	idd = GROUP_CHANGER_DIALOG_IDD;
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
			colorBackground[] = {-1,-1,-1,0.25};
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
			text = "Current Group's Players"; //--- ToDo: Localize;
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
			y = 0.6875 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_showAI_text: KISKA_RscText
		{
			idc = -1;
			text = "Show AI:"; //--- ToDo: Localize;
			x = 0.59375 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.0410156 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_groupLeader_text: KISKA_RscText
		{
			idc = -1;
			text = "Group Leader:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_canBeDeleted_text: KISKA_RscText
		{
			idc = -1;
			text = "Group Can Be Deleted:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.666667 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_leaderIsPlayer_text: KISKA_RscText
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
		class KISKA_GCH_joinGroup_button: KISKA_RscButton
		{
			idc = GROUP_CHANGER_JOIN_GROUP_BUTTON_IDC;
			text = "Join Group"; //--- ToDo: Localize;
			x = 0.359375 * safezoneW + safezoneX;
			y = 0.729167 * safezoneH + safezoneY;
			w = 0.0703125 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
		class KISKA_GCH_leaveGroup_button: KISKA_RscButton
		{
			idc = GROUP_CHANGER_LEAVE_GROUP_BUTTON_IDC;
			text = "Leave Group"; //--- ToDo: Localize;
			x = 0.570313 * safezoneW + safezoneX;
			y = 0.729167 * safezoneH + safezoneY;
			w = 0.0703125 * safezoneW;
			h = 0.0208333 * safezoneH;
			tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
		};
		class KISKA_GCH_close_button: KISKA_RscButtonMenu
		{
			idc = GROUP_CHANGER_CLOSE_BUTTON_IDC;
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

		/* -------------------------------------------------------------------------
			Listbox Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_sideGroups_listBox: KISKA_RscListbox
		{
			idc = GROUP_CHANGER_SIDE_GROUPS_LISTBOX_IDC;
			x = 0.353516 * safezoneW + safezoneX;
			y = 0.28125 * safezoneH + safezoneY;
			w = 0.140625 * safezoneW;
			h = 0.427083 * safezoneH;
		};
		class KISKA_GCH_currentGroup_listBox: KISKA_RscListbox
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
		class KISKA_GCH_canRally_indicator: KISKA_RscText
		{
			idc = GROUP_CHANGER_CAN_RALLY_INDICATOR_IDC;
			text = ""; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.6875 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_groupLeaderName_indicator: KISKA_RscText
		{
			idc = GROUP_CHANGER_LEADER_NAME_INDICATOR_IDC;
			text = "Some Unit Name"; //--- ToDo: Localize;
			x = 0.558594 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.0878906 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_canBeDeleted_indicator: KISKA_RscText
		{
			idc = GROUP_CHANGER_CAN_BE_DELETED_INDICATOR_IDC;
			text = "YES"; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.666667 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};
		class KISKA_GCH_leaderIsPlayer_text_indicator: KISKA_RscText
		{
			idc = GROUP_CHANGER_LEADER_IS_PLAYER_INDICATOR_IDC;
			text = ""; //--- ToDo: Localize;
			x = 0.587891 * safezoneW + safezoneX;
			y = 0.645833 * safezoneH + safezoneY;
			w = 0.0585937 * safezoneW;
			h = 0.0208333 * safezoneH;
			colorBackground[] = {-1,-1,-1,1};
		};

		/* -------------------------------------------------------------------------
			Misc Controls
		------------------------------------------------------------------------- */
		class KISKA_GCH_showAI_checkBox: KISKA_RscCheckbox
		{
			idc = GROUP_CHANGER_SHOW_AI_CHECKBOX_IDC;
			x = 0.634766 * safezoneW + safezoneX;
			y = 0.260417 * safezoneH + safezoneY;
			w = 0.0117188 * safezoneW;
			h = 0.0208333 * safezoneH;
		};
	};
};