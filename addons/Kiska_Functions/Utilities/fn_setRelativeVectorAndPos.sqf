/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getRelativeVectorAndPos

Description:
	Sets the position and vector dir and up of one object to another based on
     relative coordinates to the parent object.

Parameters:
	0: _parent <OBJECT> - The object to make the coordinates relative to.
	1: _child <OBJECT> - The object to find coordinates for.
	2: _relativeInfo <ARRAY> - An array containing the relative coordinates to
        change to worldspace:
        0: <ARRAY> - Relative world pos
        1: <ARRAY> - Relative vector dir
        2: <ARRAY> - Relative vector up

Returns:
	NOTHING

Examples:
    (begin example)
		[
            parentObject,
            childObject,
            [[0,0,0],[0,1,0],[0,0,1]]
        ] call KISKA_fnc_setRelativeVectorAndPos;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_setRelativeVectorAndPos";

params [
    ["_parent",objNull,[objNull]],
    ["_child",objNull,[objNull]],
    ["_relativeInfo",[],[[]],3]
];

if (isNull _parent) exitWith {
    ["Null parent object passed",true] call KISKA_fnc_log;
    nil
};

if (isNull _child) exitWith {
    ["Null child object passed",true] call KISKA_fnc_log;
    nil
};

private _relativePosWorld = _relativeInfo select 0;
private _relativeVectorDir = _relativeInfo select 1;
private _relativeVectorUp = _relativeInfo select 2;

_child setPosWorld (_parent modelToWorldWorld _relativePosWorld);
_child setVectorDir (_parent vectorModelToWorld _relativeVectorDir);
_child setVectorUp (_parent vectorModelToWorld _relativeVectorUp);
