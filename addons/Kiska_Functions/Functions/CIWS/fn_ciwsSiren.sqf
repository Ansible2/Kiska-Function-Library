/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciwsSiren

Description:
    Sounds a siren for the CIWS

Parameters:
    0: _turret : <OBJECT> - The CIWS turret

Returns:
    Nothing

Examples:
    (begin example)
        [turret1] spawn KISKA_fnc_ciwsSiren;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
#define SIREN_DISTANCE 1000
#define SIREN_VOLUME 2

scriptName "KISKA_fnc_ciwsSiren";

params ["_turret"];

if (_turret getVariable ["KISKA_CIWS_sirenSounding",false]) exitWith {
    [[_turret," already has its siren sounding"],true] call KISKA_fnc_log;
    nil
};

_turret setVariable ["KISKA_CIWS_sirenSounding",true];

waitUntil {
    ["KISKA_Siren",_turret,SIREN_DISTANCE,SIREN_VOLUME] call KISKA_fnc_playSound3d;
    sleep 8;
    if (_turret getVariable "KISKA_CIWS_allClear") exitWith {true};

    false
};

_turret setVariable ["KISKA_CIWS_sirenSounding",false];