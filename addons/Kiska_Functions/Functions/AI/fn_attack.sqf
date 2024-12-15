/* ----------------------------------------------------------------------------
Function: KISKA_fnc_attack

Description:
    Modified version of CBA_fnc_taskAttack.
    Now allows setting of different behaviour and combatMode.

Parameters:
    0: _group <GROUP or OBJECT> - Unit(s) to attack
    1: _position <OBJECT, LOCATION, GROUP, or ARRAY> - The position to attack
    2: _radius <NUMBER> - Radius for waypoint placement
    3: _behaviour <STRING> - What behaviour will the attacker(s) have
    4: _combatMode <STRING> - What combatMode will the attacker(s) have
    5: _override <BOOL> - Clear units current waypoints

Returns:
    NOTHING

Examples:
    (begin example)
        [group1,attackPosition,100,"COMBAT","RED"] call KISKA_fnc_attack;
    (end)

Author:
    Rommel,
    Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_attack";

params [
    ["_group",grpNull,[objNull,grpNull]],
    ["_position",objNull,[[],objNull,locationNull,grpNull]],
    ["_radius",-1,[123]],
    ["_behaviour","AWARE",[""]],
    ["_combatMode","RED",[""]],
    ["_override",false,[true]]
];

_group = _group call CBA_fnc_getGroup;

// Don't create waypoints on each machine
if !(local _group) exitWith {
    [["Found that ",_group," was not local, exiting..."],true] call KISKA_fnc_log;
    nil
};

// Allow TaskAttack to override other set waypoints
if (_override) then {
    [_group,-1,true] call KISKA_fnc_clearWaypoints;
};

[_group, _position, _radius, "SAD", _behaviour, _combatMode] call CBA_fnc_addWaypoint;


nil
