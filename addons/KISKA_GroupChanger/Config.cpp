class CfgPatches
{
	class KISKA_GroupChanger
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]={
			"KISKA_Functions"
		};
	};
};

class CfgFunctions
{
	class KISKA
	{
		class GroupChanger
		{
			file = "KISKA_GroupChanger\Functions";

			class GCH_addDiaryEntry
			{
				preInit = 1;
			};
			class GCH_addMissionEvents
			{
				preInit = 1;
			};
			class GCH_addGroupEventhandlers
			{};
			class GCH_assignTeam
			{};
			class GCH_dontExcludePlayerGroupDefault
			{
				postInit = 1;
			};
			class GCH_doesGroupHaveAnotherPlayer
			{};
			class GCH_getSideGroups
			{};
			class GCH_getSelectedGroup
			{};
			class GCH_getPlayerSide
			{};
			class GCH_groupDeleteQuery
			{};
			class GCH_isAllowedToEdit
			{};
			class GCH_isGroupExcluded
			{};
			class GCH_isOpen
			{};
			class GCH_setLeaderRemote
			{};
			class GCH_setGroupExcluded
			{};
			class GCH_updateCurrentGroupSection
			{};
			class GCH_updateSideGroupsList
			{};
			class GCHOnLoad
			{};
			class GCHOnLoad_assignTeamCombo
			{};
			class GCHOnLoad_canBeDeletedCombo
			{};
			class GCHOnLoad_canRallyCombo
			{};
			class GCHOnLoad_closeButton
			{};
			class GCHOnLoad_joinGroupButton
			{};
			class GCHOnLoad_leaveGroupButton
			{};
			class GCHOnLoad_setGroupIdButton
			{};
			class GCHOnLoad_setLeaderButton
			{};
			class GCHOnLoad_showAiCheckbox
			{};
			class GCHOnLoad_sideGroupsList
			{};
			class GCH_openDialog
			{};
		};
	};
};


class Extended_PreInit_EventHandlers {
	class groupChanger_settings_preInitEvent {
        init = "call compileScript ['KISKA_GroupChanger\Scripts\addGroupChangerCbaSettings.sqf'];";
    };
};

#include "Headers\GroupChangerDialog.hpp"
