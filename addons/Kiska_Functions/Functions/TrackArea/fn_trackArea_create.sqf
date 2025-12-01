/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_create

Description:
    Defines an area that a list of objects will be tracked whether or not they
     are within the defined area.

Parameters:
    0: _areas <(TRIGGER | LOCATION | MARKER | ARRAY)[]> - An array or potential areas
        the objects should be inside or out of. See `inAreaArray` right arg for
        more details.
    1: _onExited <CODE, STRING, [ANY,CODE], [ANY,STRING]> - Code that will be executed
        once it is discovered that the player has left the area.
        (see `KISKA_fnc_callBack` for type examples).

        Parameters:
        - 0: <> - 

    2: _onReturned <CODE, STRING, [ANY,CODE], [ANY,STRING]> - Code that will be 
        executed once it is discovered that the player has returned to the area.
        (see `KISKA_fnc_callBack` for type examples).
        
        Parameters:
        - 0: <> - 

    

Returns:
    <STRING> - The ID of the track area.

Examples:
    (begin example)
        
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_create";

#define MIN_CHECK_FREQ 0

params [
    ["_areas",[],[[]]],
    ["_onExited",{},[[],{},""]],
    ["_onReturned",{},[[],{},""]],
    ["_checkFrequency",1,[123]],
    ["_trackedObjects",[],[[]]],
    ["_start",true,[true]]
];

private _overallMap = [
    localNamespace,
    "KISKA_trackArea_globalMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;


private _id = ["KISKA_trackArea"] call KISKA_fnc_generateUniqueId;
_overallMap set [
    _id,
    createHashMapFromArray [
        ["onExited",_onExited],
        ["onReturned",_onReturned],
        ["checkFrequency",_checkFrequency max MIN_CHECK_FREQ]
    ]
];

_areas apply { [_id,_x] call KISKA_fnc_trackArea_addArea };
_trackedObjects apply { [_id,_x] call KISKA_fnc_trackArea_addObject };


if (_start) then {
    _id call KISKA_fnc_trackArea_startLoop;
};



_id



// TODO:
// An Area Checker is a single entity
//  This can inlcude multiple areas to check
    // Areas could be saved using a KISKA hashmap function so they are not duplicated and can be precisely controlled
    // This could however prove to be too slow to function reasonably
    // Especially of concern is how to handle null entities like triggers and locations if they unexpectedly are deleted (might not even matter though)
//  This can include multiple objects to check if they are in the areas
//  This will have a handler for when an object leaves the areas (can be changed)
//  This will have a handler for when an object enters the areas (can be changed)
//  This will have a frequency of how often the areas are checked (can be changed)
//  Sub-areas can be paused
//  Objects can be paused
// Multiple Area Checkers can be created simultaneously
//  Objects can be a part of multiple simaltaneous Area Checkers