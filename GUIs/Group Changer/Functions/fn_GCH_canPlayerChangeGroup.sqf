/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_leaveGroupButton

Description:
	The function that fires on the leave group button click event.
	The Event is added in KISKA_fnc_GCHOnLoad.

Parameters:
	0: _groupToJoin : <group> - The group a player wants to join

Returns:
	NOTHING

Examples:
    (begin example)
        [someGroup] call KISKA_fnc_GCH_leaveGroupButton;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define TRYING_TO_CREATE_NEW_GROUP 1
#define TRYING_TO_JOIN_GROUP_WITHOUT_PERMS 2
#define TRYING_TO_JOIN_GROUP_WITHOUT_PERMS 2

#define SCRIPT_NAME "KISKA_fnc_canPlayerChangeGroup"
scriptName SCRIPT_NAME;


params [
	["_groupToJoin","new group",[grpNull,""]]
];

private _allowedGroups = missionNamespace getVariable ["KISKA_allowedGroups",[]];
private _currentPlayerGroup = group player;

private _doExit = -1;

if !(_allowedGroups isEqualTo []) then {

	private _isInAllowedGroup = [
		_allowedGroups,
		{(group player) isEqualTo _x}
	] call KISKA_fnc_findIfBool;
	
	if (_isInAllowedGroup AND {_groupToJoin isEqualTo "new group"}) exitWith {
		_doExit = TRYING_TO_CREATE_NEW_GROUP;
	};

	if 
};

if (_doExit != -1) exitWith {

	switch (_doExit) do {
		
		case TRYING_TO_CREATE_NEW_GROUP: {
			hint "You cannot create a new group, you must join only your allowed groups";;
		};

		case TRYING_TO_JOIN_GROUP_WITHOUT_PERMS: {
			private _text = parseText "You are limited in the groups you can join, consult the Side Groups list. <t color='#00b530'>Green</t> are joinable.";
			hint _text;
		};
	};
};

if (isNull _groupToJoin) exitWith {
	hint "The group you are attempting to join no longer exists";
};