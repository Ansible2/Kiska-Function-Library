/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addCommMenuItem

Description:
	This is an alias of sorts of Bohemia's BIS_fnc_addCommMenuItem.
	It is mostly made with the purpose of using default values and specifically
	 passing a -1 by default to _expressionArguments.

Parameters:
	0: _supportClass <STRING> - The class as defined in the CfgCommunicationMenu

Returns:
	<NUMBER> - The comm menu ID

Examples:
    (begin example)
		_id = [player,"myClass"] call KISKA_fnc_addCommMenuItem;
    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addCommMenuItem";

params [
	["_owner",objNull,[objNull]],
	["_itemClass","",[""]],
	["_textArguements",""],
	["_expressionArguments",-1,[]],
	["_notification","",[""]]
];

[
	_owner,
	_itemClass,
	_textArguements,
	_expressionArguments,
	_notification
] call BIS_fnc_addCommMenuItem;