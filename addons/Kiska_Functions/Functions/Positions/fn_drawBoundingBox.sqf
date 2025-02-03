/* ----------------------------------------------------------------------------
Function: KISKA_fnc_drawBoundingBox

Description:
    Draws the given bounding box of _corner_a specified object.

Parameters:
    0: _object : <OBJECT> - The object to draw the box around.
    1: _color : <NUMBER[]> Default: `[1,0,1,1]` - The color of the boundingBox in RGBA format.
    2: _lod : <NUMBER | STRING> Default: `0` - See `boundingBoxReal` for valid args.

Returns:
    <STRING> - The id of the bounding box for removal

Examples:
    (begin example)
        [] spawn {
            private _boundingBoxId = [
                myObject,
                [1,0,1,1],
                0
            ] call KISKA_fnc_drawBoundingBox;
            
            sleep 10;
            
            [_boundingBoxId] call KISKA_fnc_removeBoundingBoxDraw;
        };
    (end)

Author(s):
    Bohemia Interactive,
    Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_drawBoundingBox";

params [
    ["_object",objNull,[objNull]],
    ["_color",[1,0,1,1],[[]],4],
    ["_lod",0,["",123]]
];

if (isNull _object) exitWith {
    ["_object is null",true] call KISKA_fnc_log;
    -1
};

private "_boundingBox";
if (_lod isEqualType "") then {
    _boundingBox = boundingBoxReal [_object,_lod];
} else {
    _boundingBox = _lod boundingBoxReal _object;
};
_boundingBox params ["_mins","_maxes"];

private _id = addMissionEventHandler [
    "Draw3D",
    {
        _thisArgs params ["_object","_color","_mins","_maxes"];

        if (isNull _object) then {
            removeMissionEventHandler [_thisEvent,_thisEventHandler];
        } else {
            _mins params ["_xMin","_yMin","_zMin"];
            _maxes params ["_xMax","_yMax","_zMax"];

            private _corner_a = _object modelToWorldVisual [_xMin,_yMin,_zMin];
            private _corner_b = _object modelToWorldVisual [_xMax,_yMin,_zMin];
            private _corner_c = _object modelToWorldVisual [_xMax,_yMin,_zMax];
            private _corner_d = _object modelToWorldVisual [_xMin,_yMin,_zMax];
            private _corner_e = _object modelToWorldVisual [_xMin,_yMax,_zMin];
            private _corner_f = _object modelToWorldVisual [_xMax,_yMax,_zMin];
            private _corner_G = _object modelToWorldVisual [_xMax,_yMax,_zMax];
            private _corner_h = _object modelToWorldVisual [_xMin,_yMax,_zMax];
            [
                [_corner_a, _corner_b, _color],
                [_corner_b, _corner_c, _color],
                [_corner_c, _corner_d, _color],
                [_corner_d, _corner_a, _color],
                [_corner_e, _corner_f, _color],
                [_corner_f, _corner_G, _color],
                [_corner_G, _corner_h, _color],
                [_corner_h, _corner_e, _color],
                [_corner_a, _corner_e, _color],
                [_corner_b, _corner_f, _color],
                [_corner_c, _corner_G, _color],
                [_corner_d, _corner_h, _color] 
            ] apply { 
                drawLine3D _x;
            };
        };
    },
    [_object,_color,_mins,_maxes]
];

private _drawIds = _object getVariable "KISKA_drawnBoundingBoxIds";
if (isNil "_drawIds") then {
    _drawIds = createHashMap;
    _object setVariable ["KISKA_drawnBoundingBoxIds",_drawIds];
};

private _boundingBoxDrawId = ["KISKA_drawnBoundingBox"] call KISKA_fnc_generateUniqueId;
_drawIds set [_boundingBoxDrawId,_id];


_boundingBoxDrawId
