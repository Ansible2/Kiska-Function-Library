/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getBoundingBoxDimensions

Description:
    Returns the length, width, and height of a given object's bounding box, for
     a given clipping type.

Parameters:
    0: _object <OBJECT> - The object to get the dimensions of
    1: _boxType <NUMBER or STRING> - The `boundingBoxReal` command's clipping type or
        the LOD name/resolution if `_isLOD` is true.
    2: _isLOD <BOOL> - Whether or not to use the LOD syntax of `boundingBoxReal`

Returns:
    <NUMBER[]> - `[Width,Length,Height]` of the given object's dimensions 

Examples:
    (begin example)
        private _playerBoxDimensions = [player] call KISKA_fnc_getBoundingBoxDimensions;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getBoundingBoxDimensions";

#define BOUDNING_BOX_MINS (_boundingBox select 0)
#define BOUDNING_BOX_MAXES (_boundingBox select 1)

params [
    ["_object",objNull,[objNull]],
    ["_boxType",0,[123]],
    ["_isLOD",false,[false]]
];


if (isNull _object) exitWith {
    ["null object passed",true] call KISKA_fnc_log;
    [0,0,0]
};


private "_boundingBox";
if (_isLOD) then {
    _boundingBox = boundingBoxReal [_object,_boxType];
} else {
    _boundingBox = _boxType boundingBoxReal _object;
};


(BOUDNING_BOX_MAXES vectorDiff BOUDNING_BOX_MINS) apply { abs _x }
