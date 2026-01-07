/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_isRunning

Description:
    Checks if a track area is currently running.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.

Returns:
    NOTHING

Examples:
    (begin example)
        private _isRunning = _trackAreaId call KISKA_fnc_trackArea_isRunning;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_isRunning";

#define PER_FRAME_HANDLER_KEY "perFrameHandlerId"

params [
    ["_trackAreaId","",[""]]
];

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _trackAreaInfoMap = _containerMap get _trackAreaId;
if (isNil "_trackAreaInfoMap") exitWith {
    [["_trackAreaId ",_trackAreaId," does not exist"],true] call KISKA_fnc_log;
    false
};


PER_FRAME_HANDLER_KEY in _trackAreaInfoMap
