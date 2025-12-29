/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_create

Description:
    Defines an area that a list of objects will be tracked whether or not they
     are within the defined area.

Parameters:
    0: _areas <OBJECT, LOCATION, STRING, ARRAY, NUMBER[][]> - An array of areas 
        to add to the tracked list. These must be compatible with the right-side
        area arguement of `inAreaArray`.
    1: _trackedObjects <OBJECT[]> Default: `[]` - A list of objects to track whether
        they are in the given areas.
    2: _checkFrequency <NUMBER> Default: `1` - The delay in seconds to wait between
        area checks.
    3: _onExited <CODE, STRING, [ANY,CODE], [ANY,STRING]> Default: `{}` - 
        Code that will be executed once it is discovered that one or more tracked 
        objects has left the area. (see `KISKA_fnc_callBack` for type examples).

        Parameters:
        - 0: <OBJECT[]> - The objects that have left the area.
        - 1: <STRING> - The area tracker ID.

    4: _onReturned <CODE, STRING, [ANY,CODE], [ANY,STRING]> Default: `{}` - 
        Code that will be executed once it is discovered that one or more
        tracked objects has returned to the area. 
        (see `KISKA_fnc_callBack` for type examples).

        Parameters:
        - 0: <OBJECT[]> - The objects that have left the area.
        - 1: <STRING> - The area tracker ID.
    
    5: _start <BOOL> Default: `true` - Whether or not to immediately start the 
        area tracker.

Returns:
    <STRING> - The ID of the track area.

Examples:
    (begin example)
        [
            [trigger_1,trigger_2],
            [player],
            1,
            {
                params ["_objects"];
                hint str ["objects that left",_objects];
            },
            {
                params ["_objects"];
                hint str ["objects that returned",_objects];
            }
        ] call KISKA_fnc_trackArea_create;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_create";

#define MIN_CHECK_FREQ 0

params [
    ["_areas",[],[[]]],
    ["_trackedObjects",[],[[]]],
    ["_checkFrequency",1,[123]],
    ["_onExited",{},[[],{},""]],
    ["_onReturned",{},[[],{},""]],
    ["_start",true,[true]]
];

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;


private _id = ["KISKA_trackArea"] call KISKA_fnc_generateUniqueId;
_containerMap set [
    _id,
    createHashMapFromArray [
        ["onExited",_onExited],
        ["onReturned",_onReturned]
    ]
];

[_id,_checkFrequency] call KISKA_fnc_trackArea_checkFrequency;
_areas apply { [_id,_x] call KISKA_fnc_trackArea_addArea };
_trackedObjects apply { [_id,_x] call KISKA_fnc_trackArea_addObject };


if (_start) then {
    _id call KISKA_fnc_trackArea_startTracking;
};



_id
