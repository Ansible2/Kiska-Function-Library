/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stopRadioChatter

Description:
    Stops radio chatter playing for the given id.

Parameters:
    0: _chatterId <OBJECT> - Where the sound is coming from

Returns:
    NOTHING

Examples:
    (begin example)
        [0] call KISKA_fnc_radioChatter;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stopRadioChatter";

params [
    ["_chatterId",-1,[123]]
];

if (_chatterId < 0) exitWith {
    ["Invalid _chatterId given!",true] call KISKA_fnc_log;
    nil
};

private _stringChatterId = str _chatterId;
localNamespace setVariable [("KISKA_radioChatterIsPlaying_" + _stringChatterId), nil];

private _offsetObjectVar = "KISKA_radioChatter_offsetObject_" + _stringChatterId;
private _offsetObject = localNamespace getVariable [_offsetObjectVar, objNull];
if (isNull _offsetObject) exitWith {};

detach _offsetObject;
deleteVehicle _offsetObject;
localNamespace setVariable [_offsetObjectVar, nil];
