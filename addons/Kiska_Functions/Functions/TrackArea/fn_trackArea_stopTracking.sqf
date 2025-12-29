/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_stopTracking

Description:
    Stops the looping process of actually checking what tracked objects are within
     the tracked areas or not. 
     
    This can effectively be used to pause checks without destroying the whole 
     tracked area's information.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.

Returns:
    NOTHING

Examples:
    (begin example)
        _trackAreaId call KISKA_fnc_trackArea_stopTracking;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_stopTracking";

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
    nil
};

if !(PER_FRAME_HANDLER_KEY in _trackAreaInfoMap) exitWith {
    [["_trackAreaId ",_trackAreaId," is already stopped"]] call KISKA_fnc_log;
    nil
};


private _perFrameHandlerId = _trackAreaInfoMap get PER_FRAME_HANDLER_KEY;
_perFrameHandlerId call KISKA_fnc_CBA_removePerFrameHandler;
_trackAreaInfoMap set [PER_FRAME_HANDLER_KEY,nil];


nil
