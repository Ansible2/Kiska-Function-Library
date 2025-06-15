/* ----------------------------------------------------------------------------
Function: KISKA_fnc_multiKillEvent_getContainerMap

Description:
    Returns the map that contains the event maps

Parameters:
    0: _id <STRING> - The multi kill event ID.

Returns:
    <HASHMAP> - A hashmap for all the event maps

Examples:
    (begin example)
        private _containerMap = call KISKA_fnc_multiKillEvent_getContainerMap;
    (end)
    
Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_multiKillEvent_getContainerMap";

private _containerMap = localNamespace getVariable "KISKA_multiKillEvent_containerMap";
if (isNil "_containerMap") then {
    _containerMap = createHashMap;
    localNamespace setVariable ["KISKA_multiKillEvent_containerMap",_containerMap];
};


_containerMap
