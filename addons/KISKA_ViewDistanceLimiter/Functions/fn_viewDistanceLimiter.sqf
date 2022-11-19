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
	["_targetFPS",missionNamespace getVariable [VDL_FPS_VAR_STR,60],[123]],
	["_checkFreq",missionNamespace getVariable [VDL_FREQUENCY_VAR_STR,0.5],[123]],
	["_minObjectDistance",missionNamespace getVariable [VDL_MIN_DIST_VAR_STR,500],[123]],
	["_maxObjectDistance",missionNamespace getVariable [VDL_MAX_DIST_VAR_STR,1200],[123]],
	["_increment",missionNamespace getVariable [VDL_INCREMENT_VAR_STR,25],[123]],
	["_viewDistance",missionNamespace getVariable [VDL_VIEW_DIST_VAR_STR,3000],[123]]
];


missionNamespace setVariable [VDL_GLOBAL_RUN_STR,true];
missionNamespace setVariable [VDL_FPS_VAR_STR,_targetFPS];
missionNamespace setVariable [VDL_FREQUENCY_VAR_STR,_checkFreq];
if (_minObjectDistance > _maxObjectDistance) then {
	_minObjectDistance = _maxObjectDistance;
};
missionNamespace setVariable [VDL_MIN_DIST_VAR_STR,_minObjectDistance];
missionNamespace setVariable [VDL_MAX_DIST_VAR_STR,_maxObjectDistance];
missionNamespace setVariable [VDL_INCREMENT_VAR_STR,_increment];
if (_viewDistance < _maxObjectDistance) then {
	_viewDistance = _maxObjectDistance;
};
missionNamespace setVariable [VDL_VIEW_DIST_VAR_STR,_viewDistance];


private "_objectViewDistance";
private _fn_moveUp = {
	if (_objectViewDistance < (GET_VDL_MAX_DIST_VAR)) exitWith {
		setObjectViewDistance (_objectViewDistance + (GET_VDL_INCREMENT_VAR));
	};
	if (_objectViewDistance > (GET_VDL_MAX_DIST_VAR)) exitWith {
		setObjectViewDistance (GET_VDL_MAX_DIST_VAR);
	};
};
private _fn_moveDown = {
	if (_objectViewDistance > (GET_VDL_MIN_DIST_VAR)) exitWith {
		setObjectViewDistance (_objectViewDistance - (GET_VDL_INCREMENT_VAR));
	};
	if (_objectViewDistance < (GET_VDL_MIN_DIST_VAR)) exitWith {
		setObjectViewDistance (GET_VDL_MIN_DIST_VAR);
	};
};


missionNamespace setVariable [VDL_GLOBAL_IS_RUNNING_STR,true];
while {sleep (GET_VDL_FREQUENCY_VAR); GET_VDL_GLOBAL_IS_RUNNING} do {
	_objectViewDistance = getObjectViewDistance select 0;
	if (!(GET_VDL_GLOBAL_TIED_VIEW_DIST_VAR) AND ((GET_VDL_VIEW_DIST_VAR) isNotEqualTo viewDistance)) then {
		setViewDistance (GET_VDL_VIEW_DIST_VAR);
	};

	// is fps at target?
	if (diag_fps < (GET_VDL_FPS_VAR)) then {
		// not at target fps
		call _fn_moveDown;
	} else {
		// at target fps
		call _fn_moveUp;
	};

	if (GET_VDL_GLOBAL_TIED_VIEW_DIST_VAR) then {
		[{
			setViewDistance (getObjectViewDistance select 0);
		}] call CBA_fnc_execNextFrame;
	};
};


missionNamespace setVariable [VDL_GLOBAL_IS_RUNNING_STR,false];
