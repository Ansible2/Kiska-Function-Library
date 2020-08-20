/* ----------------------------------------------------------------------------
Function: KISKA_fnc_viewDistanceLimiter

Description:
	Starts a looping function for limiting a player's viewDistance.
	Loop can be stopped by setting mission variable "KISKA_VD_run" to false.
	All other values have global vars that can be edited while it is in use.
	See each param for associated global var.

Parameters:

	0: _targetFPS <NUMBER> - The desired FPS (lower) limit (KISKA_VD_fps)
	1: _checkFreq <NUMBER> - The frequency of checks for FPS (KISKA_VD_freq)
	2: _minDistance <NUMBER> - The minimum the viewDistance can be set to (KISKA_VD_minD)
	3: _maxDistance <NUMBER> - The max the viewDistance can be set to (KISKA_VD_maxD)
	4: _increment <NUMBER> - The amount the viewDistance can incriment up or down each cycle (KISKA_VD_inc)

Returns:
	NOTHING 

Examples:
	(begin example)

		Every 3 seconds, check
		[45,3,500,1700,25] spawn KISKA_fnc_viewDistanceLimiter; 

	(end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!canSuspend) exitWith {
	"Must be run in scheduled environment." call BIS_fnc_error;
};

params [
	["_targetFPS",missionNamespace getVariable ["KISKA_VD_fps",60],[123]],
	["_checkFreq",missionNamespace getVariable ["KISKA_VD_freq",3],[123]],
	["_minDistance",missionNamespace getVariable ["KISKA_VD_minD",500],[123]],
	["_maxDistance",missionNamespace getVariable ["KISKA_VD_maxD",1700],[123]],
	["_increment",missionNamespace getVariable ["KISKA_VD_inc",25],[123]]
];

private _fn_moveUp = {
	if (_viewDistance < KISKA_VD_maxD) exitWith {
		setViewDistance (_viewDistance + KISKA_VD_inc);
	};
	if (_viewDistance > KISKA_VD_maxD) exitWith {
		setViewDistance KISKA_VD_maxD;
	};
};
private _fn_moveDown = {
	if (_viewDistance > KISKA_VD_minD) exitWith {
		setViewDistance (_viewDistance - KISKA_VD_inc);
	};
	if (_viewDistance < KISKA_VD_minD) exitWith {
		setViewDistance KISKA_VD_minD;
	};
};


KISKA_VD_run = true;
KISKA_VD_fps = _targetFPS;
KISKA_VD_freq = _checkFreq;
KISKA_VD_minD = _minDistance;
KISKA_VD_maxD = _maxDistance;
KISKA_VD_inc = _increment;

while {sleep KISKA_VD_freq; KISKA_VD_run} do {
	private _viewDistance = viewDistance;
	// is fps at target?
	if (diag_fps < KISKA_VD_fps) then {
		// not at target fps
		call _fn_moveDown;
		systemChat str viewDistance;
	} else {
		// at target fps
		call _fn_moveUp;
		systemChat str viewDistance;
	};
};
