/* ----------------------------------------------------------------------------
Function: KISKA_fnc_isObjectLocalOnly

Description:
    Checks if a created vehicle has a `netId` of `"0:0"`. If it does, it is a local
    only object.

Parameters:
    0: _object <OBJECT> - The object to check.

Returns:
    <BOOL> - `false` if the object is local to only the current machine.

Examples:
    (begin example)
        private _isLocalOnly = MyObject call KISKA_fnc_isObjectLocalOnly;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
params [
    ["_object",objNull,[objNull]]
];

(netId _object) == "0:0" OR {!isMultiplayer}