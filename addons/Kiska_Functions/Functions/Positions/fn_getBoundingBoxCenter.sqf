/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getBoundingBoxCenter

Description:
    Gets the center of a given object's bounding box.

Parameters:
    0: _object : <OBJECT> - The object to get the bounding box center of.
    1: _lod : <NUMBER | STRING> Default: `0` - The lod to get the bounding box of.
        See `boundingBoxReal` for valid args.

Returns:
    <PositionWorld[]> - The center position of the bounding box.

Examples:
    (begin example)
        private _centerPositionWorld = [myObject] call KISKA_fnc_getBoundingBoxCenter;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getBoundingBoxCenter";

params [
    ["_object",objNull,[objNull]],
    ["_lod",0,["",123]]
];

if (isNull _object) exitWith {
    ["_object is null",true] call KISKA_fnc_log;
    []
};

private "_boundingBox";
if (_lod isEqualType "") then {
    _boundingBox = boundingBoxReal [_object,_lod];
} else {
    _boundingBox = _lod boundingBoxReal _object;
};


private _relativeCenter = ((_boundingBox select 1) vectorAdd (_boundingBox select 0)) vectorMultiply 0.5;
_object modelToWorldVisualWorld _relativeCenter
