/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_compileFinal

Description:
    Copied function `CBA_fnc_compileFinal` from CBA3. Will `compileFinal` a piece of code
     and place it in the `missionNamespace` with the given name.

Parameters:
    0: _name <STRING> - The name of the function that will be saved to the `missionNamespace`.
    1: _function <CODE> - The code to set the function name to.

Returns:
    NOTHING

Example:
    (begin example)
        ["MyFunction", {systemChat str _this}] call KISKA_fnc_CBA_compileFinal;
        // call (missionNamespace getVariable "MyFunction");
        call MyFunction;
    (end)

Author(s):
    commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_compileFinal";

params [
    ["_name", "", [""]], 
    ["_function", {}, [{}]]
];

missionNamespace setVariable [_name, compileFinal _function];
