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
    <NUMBER[]> - `[Length,Width,Height]` of the given object's dimensions 

Examples:
    (begin example)
        private _playerBoxDimensions = [player] call KISKA_fnc_getBoundingBoxDimensions;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getBoundingBoxDimensions";

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


_boundingBox params ["_boundingBoxMins","_boundingBoxMaxes"];
_boundingBoxMins params ["_xMin","_yMin","_zMin"];
_boundingBoxMaxes params ["_xMax","_yMax","_zMax"];


[
	abs (_yMax - _yMin), // length
	abs (_xMax - _xMin), // width
	abs (_zMax - _zMin) // height
]
