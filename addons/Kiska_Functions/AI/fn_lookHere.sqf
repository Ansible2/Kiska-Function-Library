/* ----------------------------------------------------------------------------
Function: KISKA_fnc_lookHere

Description:
    Takes objects and sets their direction towards the nearest object or position within a set

Parameters:
    0: _objectsToRotate <OBJECT or ARRAY> - The objects to setDir on 
    1: _positionsToLookAt <OBJECT or ARRAY> - The positions or objects to search for nearest
    2: _setDirection <BOOL> - Also set objects direction relative to the look position

Returns:
    BOOL

Examples:
    (begin example)
        [player,[[0,0,0]]] call KISKA_fnc_lookHere;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_lookHere";

params [
    ["_objectsToRotate",[],[objNull,[]]],
    ["_positionsToLookAt",[],[objNull,[]]],
    ["_setDirection",true,[true]]
];

if (_objectsToRotate isEqualTo [] OR {_objectsToRotate isEqualType objNull AND {isNull _objectsToRotate}}) exitWith {
    ["_objectsToRotate is undefined",true] call KISKA_fnc_log;
    false
};

if (_objectsToRotate isEqualtype objNull) then {
    _objectsToRotate = [_objectsToRotate];
};

_objectsToRotate apply {
    private _nearestPosition = [_positionsToLookAt,_x] call BIS_fnc_nearestPosition;
    
    if (_setDirection) then {
        _x setDir (_x getRelDir _nearestPosition);
    };
    
    _x doWatch _nearestPosition;
};


true