/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getCurrentWaypoint

Description:
	Returns the units currentWaypoint

Parameters:
	0: _group <GROUP or OBJECT> - The unit to get the currentWaypoint for.

Returns:
	<ARRAY> - The waypoint

Examples:
    (begin example)
		private _waypoint = [myUnit] call KISKA_fnc_getCurrentWaypoint;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getCurrentWaypoint";


params [
    ["_group",grpNull,[objNull,grpNull]]
];

if (_group isEqualType objNull) then {
    _group = group _group;
};

if (isNull _group) exitWith {
    ["Null group passed",true] call KISKA_fnc_log;
    []
};


(waypoints _group) select (currentWaypoint _group)
