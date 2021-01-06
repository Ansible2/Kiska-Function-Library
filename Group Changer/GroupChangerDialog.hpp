class KISKA_GCH_background: RscText
{
	idc = 1000;
	x = 0.347656 * safezoneW + safezoneX;
	y = 0.25 * safezoneH + safezoneY;
	w = 0.304688 * safezoneW;
	h = 0.520833 * safezoneH;
	colorBackground[] = {-1,-1,-1,0.25};
};
class KISKA_GCH_joinGroup_button: RscButton
{
	idc = 1600;
	text = "Join Group"; //--- ToDo: Localize;
	x = 0.359375 * safezoneW + safezoneX;
	y = 0.729167 * safezoneH + safezoneY;
	w = 0.0703125 * safezoneW;
	h = 0.0208333 * safezoneH;
};
class KISKA_GCH_leaveGroup_button: RscButton
{
	idc = 1601;
	text = "Leave Group"; //--- ToDo: Localize;
	x = 0.570313 * safezoneW + safezoneX;
	y = 0.729167 * safezoneH + safezoneY;
	w = 0.0703125 * safezoneW;
	h = 0.0208333 * safezoneH;
	tooltip = "Will leave your current group and create a new one. If nobody is left in it, it will be deleted."; //--- ToDo: Localize;
};
class KISKA_GCH_sideGroups_listBox: RscListbox
{
	idc = 1500;
	x = 0.353516 * safezoneW + safezoneX;
	y = 0.28125 * safezoneH + safezoneY;
	w = 0.146484 * safezoneW;
	h = 0.427083 * safezoneH;
};
class KISKA_GCH_currentGroup_listBox: RscListbox
{
	idc = 1501;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.3125 * safezoneH + safezoneY;
	w = 0.146484 * safezoneW;
	h = 0.333333 * safezoneH;
};
class KISKA_GCH_headerText: RscText
{
	idc = 1001;
	text = "Group Changer"; //--- ToDo: Localize;
	x = 0.347657 * safezoneW + safezoneX;
	y = 0.229167 * safezoneH + safezoneY;
	w = 0.292969 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_sideGroups_text: RscText
{
	idc = 1002;
	text = "Side's Player Groups"; //--- ToDo: Localize;
	x = 0.353516 * safezoneW + safezoneX;
	y = 0.260417 * safezoneH + safezoneY;
	w = 0.146484 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_currentGroup_text: RscText
{
	idc = 1003;
	text = "Current Group's Players"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.260417 * safezoneH + safezoneY;
	w = 0.09375 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_canRally_text: RscText
{
	idc = 1004;
	text = "Group Can Rally:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.6875 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_canRally_indicator: RscText
{
	idc = 1005;
	text = "YES"; //--- ToDo: Localize;
	x = 0.587891 * safezoneW + safezoneX;
	y = 0.6875 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_showAI_text: RscText
{
	idc = 1006;
	text = "Show AI:"; //--- ToDo: Localize;
	x = 0.59375 * safezoneW + safezoneX;
	y = 0.260417 * safezoneH + safezoneY;
	w = 0.0410156 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_showAI_checkBox: RscCheckbox
{
	idc = 2800;
	x = 0.634766 * safezoneW + safezoneX;
	y = 0.260417 * safezoneH + safezoneY;
	w = 0.0117188 * safezoneW;
	h = 0.0208333 * safezoneH;
};
class KISKA_GCH_close_button: RscText
{
	idc = 1007;
	text = "X"; //--- ToDo: Localize;
	x = 0.640625 * safezoneW + safezoneX;
	y = 0.229167 * safezoneH + safezoneY;
	w = 0.0117188 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {1,-1,-1,1};
};
class RscText_1008: RscText
{
	idc = 1008;
	text = "Group Leader:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.291667 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class RscText_1009: RscText
{
	idc = 1009;
	text = "Some Unit Name"; //--- ToDo: Localize;
	x = 0.558594 * safezoneW + safezoneX;
	y = 0.291667 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_canBeDeleted_text: RscText
{
	idc = 1010;
	text = "Group Can Be Deleted:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.666667 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_canBeDeleted_indicator: RscText
{
	idc = 1011;
	text = "YES"; //--- ToDo: Localize;
	x = 0.587891 * safezoneW + safezoneX;
	y = 0.666667 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_leaderIsPlayer_text: RscText
{
	idc = 1012;
	text = "Group Leader Is Player:"; //--- ToDo: Localize;
	x = 0.5 * safezoneW + safezoneX;
	y = 0.645833 * safezoneH + safezoneY;
	w = 0.0878906 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};
class KISKA_GCH_leaderIsPlayer_text_indicator: RscText
{
	idc = 1013;
	text = "YES"; //--- ToDo: Localize;
	x = 0.587891 * safezoneW + safezoneX;
	y = 0.645833 * safezoneH + safezoneY;
	w = 0.0585937 * safezoneW;
	h = 0.0208333 * safezoneH;
	colorBackground[] = {-1,-1,-1,1};
};