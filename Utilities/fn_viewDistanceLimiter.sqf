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
	2: _minObjectDistance <NUMBER> - The minimum the objectViewDistance, can be set by (KISKA_VD_minDist)
	3: _maxObjectDistance <NUMBER> - The max the objectViewDistance, can be set by (KISKA_VD_maxDist)
	4: _increment <NUMBER> - The amount the viewDistance can incriment up or down each cycle (KISKA_VD_inc)
	5: _viewDistance <NUMBER> - This is the static overall viewDistance, can be set by (KISKA_VD_viewDist)
								This is static because it doesn't affect FPS too much.

Returns:
	NOTHING 

Examples:
	(begin example)

		Every 3 seconds, check
		[45,3,500,1700,3000,25] spawn KISKA_fnc_viewDistanceLimiter; 

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
	["_minObjectDistance",missionNamespace getVariable ["KISKA_VD_minDist",500],[123]],
	["_maxObjectDistance",missionNamespace getVariable ["KISKA_VD_maxDist",1700],[123]],
	["_increment",missionNamespace getVariable ["KISKA_VD_inc",25],[123]],
	["_viewDistance",missionNamespace getVariable ["KISKA_VD_viewDist",3000],[123]]
];

private _fn_moveUp = {
	if (_viewDistance < KISKA_VD_maxDist) exitWith {
		setObjectViewDistance (_viewDistance + KISKA_VD_inc);
	};
	if (_viewDistance > KISKA_VD_maxDist) exitWith {
		setObjectViewDistance KISKA_VD_maxDist;
	};
};
private _fn_moveDown = {
	if (_viewDistance > KISKA_VD_minDist) exitWith {
		setObjectViewDistance (_viewDistance - KISKA_VD_inc);
	};
	if (_viewDistance < KISKA_VD_minDist) exitWith {
		setObjectViewDistance KISKA_VD_minDist;
	};
};

/*
	KISKA_fnc_adjustViewDistance = {
		if (KISKA_VD_viewDist isEqualTo viewDistance) exitWith {};

		private _differenceOneSixtieth = (abs (viewDistance - KISKA_VD_viewDist)) / 60;

		for "_i" from 1 to 60 do {
			if (viewDistance < KISKA_VD_viewDist) then {
				setViewDistance (viewDistance + _differenceOneSixtieth);
			} else {
				setViewDistance (viewDistance - _differenceOneSixtieth);
			};

			KISKA_VD_viewDist = viewDistance;

			sleep 0.5;
		};
	};
*/

KISKA_VD_run = true;
KISKA_VD_fps = _targetFPS;
KISKA_VD_freq = _checkFreq;
KISKA_VD_minDist = _minObjectDistance;
KISKA_VD_maxDist = _maxObjectDistance;
KISKA_VD_viewDist = _viewDistance;
KISKA_VD_inc = _increment;

while {sleep KISKA_VD_freq; KISKA_VD_run} do {
	private _viewDistance = getObjectViewDistance select 0;

	if (KISKA_VD_viewDist != viewDistance) then {
		//null = [] spawn KISKA_fnc_adjustViewDistance;
		setViewDistance KISKA_VD_viewDist;
		//hint "adjusted overall to: " + (str KISKA_VD_viewDist);
	};

	// is fps at target?
	if (diag_fps < KISKA_VD_fps) then {
		// not at target fps
		call _fn_moveDown;
		//systemChat str (getObjectViewDistance select 0);
	} else {
		// at target fps
		call _fn_moveUp;
		//systemChat str (getObjectViewDistance select 0);
	};
};