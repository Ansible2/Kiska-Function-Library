/* ----------------------------------------------------------------------------
Function: KISKA_fnc_dropCrate

Description:
	Executes drop crate action

Parameters:

	0: _crate <OBJECT> - The crate being dropped
	1: _caller <OBJECT> - The person dropping the crate
	2: _dropCrate_actionID <NUMBER> - The action ID for the drop action attached to the player so it can be removed

Returns:
	BOOL

Examples:
    (begin example)

		[crate1,player,0] call KISKA_fnc_dropCrate;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_crate",objNull,[objNull]],
	["_player",player,[objNull]],
	["_dropCrate_actionID",0,[123]]
];

_player setVariable ["DSO_dropCrateActionID",nil];

detach _crate;

_crate enableSimulationGlobal true;

_player removeAction _dropCrate_actionID;
_player forceWalk false;

_crate setVariable ["DSO_cratePickedUp",false,true];

true