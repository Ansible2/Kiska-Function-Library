/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_getGroup

Description:
    Copied version of the CBA function `CBA_fnc_getGroup`.

    A function used to find out the group of an object.

Parameters:
    0: _entity <MARKER, OBJECT, LOCATION, GROUP, TASK, WAYPOINT or POSITION> -
        The entity to find the position of.

Returns:
    <GROUP> - The group.

Example:
    (begin example)
        _group = player call KISKA_fnc_CBA_getGroup
    (end)

Author(s):
    Rommel,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_getGroup";

params [
    ["_entity", grpNull, [grpNull, objNull]]
];

if (_entity isEqualType grpNull) exitWith {_entity};

group _entity