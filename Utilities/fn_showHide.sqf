/* ----------------------------------------------------------------------------
Function: KISKA_fnc_showHide

Description:
	On selected objects, will disable simulation and hide the object or the reverse.

Parameters:

	0: _objects <ARRAY or GROUP> - Units to show or hide
	1: _show <BOOL> - True to show and simulate, false to hide and disable simulation
	2: _enableDynamicSim <BOOL> - Should the object be dynamically simulated after shown

Returns:
	NOTHING

Examples:
    (begin example)

		null = [group1, true, true] spawn KISKA_fnc_showHide;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if !(isServer) exitWith {
	["Not executed on Server"] call BIS_fnc_error;
};

params [
	["_objects",[],[[],grpNull]],
	["_show",true,[true]],
	["_enableDynamicSim",true,[true]]
];

if (_objects isEqualTo []) exitWith {
	["No objects to show or hide"] call BIS_fnc_error;
};

if (_objects isEqualType grpNull) then {
	_objects = units _objects;
};

_objects apply {
	if (!(isNull _x) OR {!(alive _x)}) then {
		[_x,_show] remoteExecCall ["allowDamage",_x];
		_x hideObjectGlobal !(_show);
		_x enableSimulationGlobal _show;

		if (_enableDynamicSim AND {dynamicSimulationSystemEnabled} AND {!(dynamicSimulationEnabled (group _x))}) then {
			(group _x) enableDynamicSimulation true;
		};
	};
};