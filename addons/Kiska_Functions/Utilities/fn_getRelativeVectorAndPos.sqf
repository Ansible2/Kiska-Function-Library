/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getRelativeVectorAndPos

Description:
    Returns the relative vector dir and up and world position from one object to
     another.

Parameters:
    0: _parent <OBJECT> - The object to make the coordinates relative to.
    1: _child <OBJECT> - The object to find coordinates for.

Returns:
    <ARRAY> -
        0: <ARRAY> - Relative world pos
        1: <ARRAY> - Relative vector dir
        2: <ARRAY> - Relative vector up

Examples:
    (begin example)
        private relativeArray = [
            parentObject,
            childObject
        ] call KISKA_fnc_getRelativeVectorAndPos
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getRelativeVectorAndPos";

params [
    ["_parent",objNull,[objNull]],
    ["_child",objNull,[objNull]]
];


if (isNull _parent) exitWith {
    ["Null parent object passed",true] call KISKA_fnc_log;
    []
};

if (isNull _child) exitWith {
    ["Null child object passed",true] call KISKA_fnc_log;
    []
};

private _relativePosWorld = _parent worldToModel (ASLToAGL (getPosASL _child));
private _relativeVectorDir = _parent vectorWorldToModel (vectorDir _child);
private _relativeVectorUp = _parent vectorWorldToModel (vectorUp _child);


[_relativePosWorld,_relativeVectorDir,_relativeVectorUp]
