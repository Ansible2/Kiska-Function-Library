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
		[45,3,500,1700,3000,25] spawn KISKA_fnc_viewDistanceLimiter;
	(end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
if (!hasInterface) exitWith {};

if (!canSuspend) exitWith {
	["Must be run in a scheduled environment. Exiting to scheduled...",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_viewDistanceLimiter
};

params [
	["_targetFPS",60,[123]],
	["_checkFreq",1,[123]],
	["_minObjectDistance",500,[123]],
	["_maxObjectDistance",1700,[123]],
	["_increment",25,[123]],
	["_viewDistance",3000,[123]]
];

missionNamespace setVariable [VDL_GLOBAL_RUN_STR,true];
missionNamespace setVariable [VDL_FPS_VAR_STR,_targetFPS];
missionNamespace setVariable [VDL_FREQUENCY_VAR_STR,_checkFreq];
missionNamespace setVariable [VDL_MIN_DIST_VAR_STR,_minObjectDistance];
missionNamespace setVariable [VDL_MAX_DIST_VAR_STR,_maxObjectDistance];
missionNamespace setVariable [VDL_VIEW_DIST_VAR_STR,_viewDistance];
missionNamespace setVariable [VDL_INCREMENT_VAR_STR,_increment];


private "_objectViewDistance";
private _fn_moveUp = {
	if (_objectViewDistance < VDL_GLOBAL_MAX_DIST) exitWith {
		setObjectViewDistance (_objectViewDistance + VDL_GLOBAL_INC);
	};
	if (_objectViewDistance > VDL_GLOBAL_MAX_DIST) exitWith {
		setObjectViewDistance VDL_GLOBAL_MAX_DIST;
	};
};
private _fn_moveDown = {
	if (_objectViewDistance > VDL_GLOBAL_MIN_DIST) exitWith {
		setObjectViewDistance (_objectViewDistance - VDL_GLOBAL_INC);
	};
	if (_objectViewDistance < VDL_GLOBAL_MIN_DIST) exitWith {
		setObjectViewDistance VDL_GLOBAL_MIN_DIST;
	};
};

missionNamespace setVariable [VDL_GLOBAL_IS_RUNNING_STR,true];
while {sleep (GET_VDL_FREQUENCY_VAR); GET_VDL_GLOBAL_IS_RUNNING} do {
	_objectViewDistance = getObjectViewDistance select 0;
	if (!(GET_VDL_GLOBAL_TIED_VIEW_DIST_VAR) AND (VDL_GLOBAL_VIEW_DIST isNotEqualTo viewDistance)) then {
		setViewDistance (GET_VDL_VIEW_DIST_VAR);
	};

	// is fps at target?
	if (diag_fps < VDL_GLOBAL_FPS) then {
		// not at target fps
		call _fn_moveDown;
	} else {
		// at target fps
		call _fn_moveUp;
	};

	if (GET_VDL_GLOBAL_TIED_VIEW_DIST_VAR) then {
		setViewDistance (getObjectViewDistance select 0);
	};
};

missionNamespace setVariable [VDL_GLOBAL_IS_RUNNING_STR,false];
