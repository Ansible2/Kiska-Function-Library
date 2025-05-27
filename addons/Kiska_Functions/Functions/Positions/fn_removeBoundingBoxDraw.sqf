/* ----------------------------------------------------------------------------
Function: KISKA_fnc_removeBoundingBoxDraw

Description:
    Removes a select or all boudning boxes drawn with `KISKA_fnc_drawBoundingBox`.

Parameters:
    0: _object : <OBJECT> - The object to draw the box around.
    1: _id : <STRING> Default: `"all"` - The bounding box Id to remove.
        If the ID is `"all"`, all bounding boxes will be removed from the object.

Returns:
    NOTHING

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
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_removeBoundingBoxDraw";

#define ALL_BOXES "all"

params [
    ["_object",objNull,[objNull]],
    ["_id",ALL_BOXES,[""]]
];

if (isNull _object) exitWith {
    ["_object is null, no need to remove",false] call KISKA_fnc_log;
    nil
};


private _boxIdMap = _object getVariable "KISKA_drawnBoundingBoxIds";
if (isNil "_boxIdMap") exitWith {
    ["Did not find any value in KISKA_drawnBoundingBoxIds",false] call KISKA_fnc_log;
    nil
};


if (_id != ALL_BOXES) exitWith {
    private _missionEventId = _boxIdMap getOrDefaultCall [_id,{-1}];
    removeMissionEventHandler ["Draw3D",_missionEventId];
};


_boxIdMap apply { removeMissionEventHandler ["Draw3D",_y] };
_object setVariable ["KISKA_drawnBoundingBoxIds",nil];


nil
