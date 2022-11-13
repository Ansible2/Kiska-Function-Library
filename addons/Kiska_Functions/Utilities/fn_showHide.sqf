/* ----------------------------------------------------------------------------
Function: KISKA_fnc_showHide

Description:
	On selected objects, will disable simulation and hide the object or the reverse.

Parameters:
	0: _objects <ARRAY, GROUP, STRING, or OBJECT> - Units to show or hide, if string, it is a mission layer
	1: _show <BOOL> - True to show and simulate, false to hide and disable simulation
	2: _enableDynamicSim <BOOL> - Should the object be dynamically simulated after shown

Returns:
	<BOOL> - True if action performed, false otherwise

Examples:
    (begin example)
		[group1, true, true] call KISKA_fnc_showHide;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_showHide";

if !(isServer) exitWith {
	["Must be executed on Server",true] call KISKA_fnc_log;
	false
};

params [
	["_objects",[],[[],grpNull,objNull,""]],
	["_show",true,[true]],
	["_enableDynamicSim",false,[true]]
];

if (_objects isEqualTo []) exitWith {
	["No objects to show or hide"] call KISKA_fnc_log;
	false
};

if (_objects isEqualType objNull) then {
	_objects = [_objects];
};

if (_objects isEqualType grpNull) then {
	_objects = units _objects;
};

if (_objcects isEqualType "") then {
	_objects = getMissionLayerEntities _objects;
}

_objects apply {
	if (!(isNull _x) OR {!(alive _x)}) then {
		[_x,_show] remoteExecCall ["allowDamage",_x];
		_x hideObjectGlobal !(_show);
		_x enableSimulationGlobal _show;
		
		if (_x isKindOf "Man" AND {!((dynamicSimulationEnabled (group _x)) isEqualTo _enableDynamicSim)}) then {
			(group _x) enableDynamicSimulation _enableDynamicSim;
		};
		
		if (dynamicSimulationEnabled _x AND {!(_enableDynamicSim)}) then {
			_x enableDynamicSimulation false;
		} else {
			_x enableDynamicSimulation _enableDynamicSim;
		};
		if (isDedicated AND {canSuspend}) then {
			sleep 0.1;
		};
	};
};


true