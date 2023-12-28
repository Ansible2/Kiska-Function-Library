/* ----------------------------------------------------------------------------
Function: KISKA_fnc_timeline_getIsRunningMap

Description:
    Returns the map that keeps track of whether or not a given KISKA timeline is
	 currently running.

Parameters:
    NONE

Returns:
    <HASHMAP> - The "is running" map

Examples:
    (begin example)
        private _isRunningMap = call KISKA_fnc_timeline_getIsRunningMap;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_timeline_getIsRunningMap";

private _isRunningMap = localNamespace getVariable ["KISKA_timeline_isRunningMap",-1];
if (_isRunningMap isEqualTo -1) then {
	_isRunningMap = createHashMap;
	localNamespace setVariable ["KISKA_timeline_isRunningMap",_isRunningMap];
};


_isRunningMap
