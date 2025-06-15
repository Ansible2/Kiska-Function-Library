/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_delete

Description:
    Removes all traces of a multi kill event.

    This can only be performed on an event that has not had its threshold met.

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <BOOL> - `true` if the event was deleted or does not exist. 
        `false` if the event exists but its threshold was met and therefore
        it will not be deleted.

Examples:
    (begin example)
        private _wasDeleted = "KISKA_multiKillEvent_uid_0_0" 
            call KISKA_fnc_multiKillEvent_delete;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_delete";

params [
    ["_id","",[""]]
];

private _containerMap = _id call KISKA_fnc_multiKillEvent_getContainerMap;
if !(_id in _containerMap) exitWith { true };

private _eventMap = _containerMap get _id;
_containerMap deleteAt _id;
if (_eventMap getOrDefaultCall ["thresholdMet",{false}]) exitWith { false };

private _objectHashSet = _eventMap get "objectHashSet";
[_id,(values _objectHashSet)] call KISKA_fnc_multiKillEvent_removeObjects;


true
