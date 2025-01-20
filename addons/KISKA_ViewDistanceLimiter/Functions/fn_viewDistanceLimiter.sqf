#include "..\Headers\View Distance Limiter Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_viewDistanceLimiter

Description:
    Starts a looping function for limiting a player's viewDistance.
    Loop can be stopped by setting mission variable "KISKA_VDL_run" to false.
    All other values have global vars that can be edited while it is in use.

    See each param for associated global var.

Parameters:
    0: _targetFPS <NUMBER> - The desired FPS (lower) limit (KISKA_VDL_fps)
    1: _checkFreq <NUMBER> - The frequency of checks for FPS (KISKA_VDL_freq)
    2: _minObjectDistance <NUMBER> - The minimum the objectViewDistance, can be set by (KISKA_VDL_minDist)
    3: _maxObjectDistance <NUMBER> - The max the objectViewDistance, can be set by (KISKA_VDL_maxDist)
    4: _increment <NUMBER> - The amount the viewDistance can incriment up or down each cycle (KISKA_VDL_inc)
    5: _viewDistance <NUMBER> - This is the static overall viewDistance, can be set by (KISKA_VDL_viewDist)
                                 This is static because it doesn't affect FPS too much.

Returns:
    NOTHING

Examples:
    (begin example)
        Every 3 seconds, check
        [45,3,500,1700,25,3000] spawn KISKA_fnc_viewDistanceLimiter;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_viewDistanceLimiter";

if (!hasInterface) exitWith {};

if (!canSuspend) exitWith {
    ["Must be run in a scheduled environment. Exiting to scheduled...",true] call KISKA_fnc_log;
    _this spawn KISKA_fnc_viewDistanceLimiter
};

params [
    ["_targetFPS",missionNamespace getVariable ["KISKA_VDL_fps",60],[123]],
    ["_checkFreq",missionNamespace getVariable ["KISKA_VDL_freq",0.5],[123]],
    ["_minObjectDistance",missionNamespace getVariable ["KISKA_VDL_minDist",500],[123]],
    ["_maxObjectDistance",missionNamespace getVariable ["KISKA_VDL_maxDist",1200],[123]],
    ["_increment",missionNamespace getVariable ["KISKA_VDL_increment",25],[123]],
    ["_viewDistance",missionNamespace getVariable ["KISKA_VDL_viewDist",3000],[123]]
];


missionNamespace setVariable ["KISKA_VDL_run",true];
missionNamespace setVariable ["KISKA_VDL_fps",_targetFPS];
missionNamespace setVariable ["KISKA_VDL_freq",_checkFreq];
if (_minObjectDistance > _maxObjectDistance) then {
    _minObjectDistance = _maxObjectDistance;
};
missionNamespace setVariable ["KISKA_VDL_minDist",_minObjectDistance];
missionNamespace setVariable ["KISKA_VDL_maxDist",_maxObjectDistance];
missionNamespace setVariable ["KISKA_VDL_increment",_increment];
if (_viewDistance < _maxObjectDistance) then {
    _viewDistance = _maxObjectDistance;
};
missionNamespace setVariable ["KISKA_VDL_viewDist",_viewDistance];


private _fn_moveUp = {
    import "_objectViewDistance";

    private _maxDistance = missionNamespace getVariable ["KISKA_VDL_maxDist",1200];
    if (_objectViewDistance < _maxDistance) exitWith {
        setObjectViewDistance (_objectViewDistance + (missionNamespace getVariable ["KISKA_VDL_increment",25]));
    };
    if (_objectViewDistance > _maxDistance) exitWith {
        setObjectViewDistance _maxDistance;
    };
};
private _fn_moveDown = {
    import "_objectViewDistance";

    private _minDistance = missionNamespace getVariable ["KISKA_VDL_minDist",600];
    if (_objectViewDistance > _minDistance) exitWith {
        setObjectViewDistance (_objectViewDistance - (missionNamespace getVariable ["KISKA_VDL_increment",25]));
    };
    if (_objectViewDistance < _minDistance) exitWith {
        setObjectViewDistance _minDistance;
    };
};


missionNamespace setVariable ["KISKA_VDL_isRunning",true];
while {sleep (missionNamespace getVariable ["KISKA_VDL_freq",1]); missionNamespace getVariable ["KISKA_VDL_isRunning",false]} do {
    private _objectViewDistance = getObjectViewDistance select 0;
    private _isViewDistanceTied = missionNamespace getVariable ["KISKA_VDL_tiedViewDistance",false];
    private _viewDistance = missionNamespace getVariable ["KISKA_VDL_viewDist",3000];
    if (
        (!_isViewDistanceTied) AND 
        (_viewDistance isNotEqualTo viewDistance)
    ) then {
        setViewDistance _viewDistance;
    };

    // is fps at target?
    if (diag_fps < (missionNamespace getVariable ["KISKA_VDL_fps",60])) then {
        call _fn_moveDown;
    } else {
        call _fn_moveUp;
    };

    if (_isViewDistanceTied) then {
        [
            {
                private _objectViewDistance = getObjectViewDistance select 0;
                setViewDistance _objectViewDistance;
            }
        ] call CBA_fnc_execNextFrame;
    };
};


missionNamespace setVariable ["KISKA_VDL_isRunning",false];
