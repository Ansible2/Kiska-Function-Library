#include "..\Headers\Compass Globals.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_compass_refresh

Description:
    Resets the config global of the compass and then restarts the cutRSC for it.

Parameters:
    NONE

Returns:
    <BOOL> - true if compass restarted

Examples:
    (begin example)
        call KISKA_fnc_compass_refresh;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_compass_refresh";

if (!hasInterface) exitWith {
    ["Run on a machine without an interface, exiting...",false] call KISKA_fnc_log;
    false
};

private _display = GET_COMPASS_DISPLAY;
if (isNull _display) exitWith {
    ["The display is null",false] call KISKA_fnc_log;
    false;
};


if (_display getVariable [COMPASS_CONFIGED_VAR_STR,false]) then {
    _display setVariable [COMPASS_CONFIGED_VAR_STR,false];

    (COMPASS_LAYER_NAME call BIS_fnc_rscLayer) cutText [ "", "PLAIN", -1, false ];
    (COMPASS_LAYER_NAME call BIS_fnc_rscLayer) cutRsc [ "KISKA_compass_rsc", "PLAIN", -1, false ];

    true

} else {
    ["KISKA Compass has already been stopped",true] call KISKA_fnc_log;
    false

};
