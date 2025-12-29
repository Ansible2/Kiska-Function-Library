/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_checkFrequency

Description:
    Gets or sets the delay in seconds between each check of a given area tracker.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.
    1: _newFrequency <NUMBER> - The delay in seconds to wait between area checks.

Returns:
    <NUMBER or NIL> - The frequency of checks or `nil` if the area tracker does 
        not exist for the given id.

Examples:
    (begin example)
        private _newFrequency = [
            "KISKA_trackArea_uid_0_0",
            1 // set to 1 second between checks
        ] call KISKA_fnc_trackArea_checkFrequency;
    (end)

    (begin example)
        private _currentFrequency = ["KISKA_trackArea_uid_0_0",] call KISKA_fnc_trackArea_checkFrequency;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_checkFrequency";

#define MIN_CHECK_FREQ 0
#define INFO_MAP_KEY "checkFrequency"
#define PER_FRAME_HANDLER_KEY "perFrameHandlerId"

params [
    ["_trackAreaId","",[""]],
    ["_newFrequency",nil,[123]]
];

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
private _trackAreaInfoMap = _containerMap get _trackAreaId;

if (isNil "_trackAreaInfoMap") exitWith {
    [["_trackAreaId ",_trackAreaId," does not exist"],true] call KISKA_fnc_log;
    nil
};
if (isNil "_newFrequency") exitWith { _trackAreaInfoMap get INFO_MAP_KEY };

_newFrequency = _newFrequency max MIN_CHECK_FREQ;
_trackAreaInfoMap set [INFO_MAP_KEY,_newFrequency];

private _perFrameHandlerId = _trackAreaInfoMap get PER_FRAME_HANDLER_KEY;
if !(isNil "_perFrameHandlerId") then {
    [_perFrameHandlerId,_newFrequency] call KISKA_fnc_CBA_setPerFrameHandlerDelay;
};


_newFrequency
