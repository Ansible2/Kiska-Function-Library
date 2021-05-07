/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addACESupportMenuAction

Description:
	Adds the ACE action to a player object that allows them to self interact
	 and pull up the support menu.

Parameters:
	0: _player <OBJECT> - The player object

Returns:
	NOTHING

Examples:
    (begin example)
		POST-INIT Function
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addACESupportMenuAction";

if (!hasInterface) exitWith {};

if !(["ace_main"] call KISKA_fnc_isPatchLoaded) exitWith {
	["ACE is not loaded, action will not be added",false] call KISKA_fnc_log;
	nil
};

waitUntil {
	sleep 0.1;
	!(isNull player)
};

private _action = [
	"Open Comm Menu",
	"Open Comm Menu",
	"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa",
	{showCommandingMenu "#User:BIS_fnc_addCommMenuItem_menu"},
	{alive player}
] call ace_interact_menu_fnc_createAction;

[player,1,["ACE_SelfActions"],_action] call ace_interact_menu_fnc_addActionToObject;
