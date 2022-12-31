/* ----------------------------------------------------------------------------
Function: KISKA_fnc_arty

Description:
	Fires a number of rounds from artillery piece at target with random disperstion values

Parameters:
	0: _gun : <OBJECT> - The artillery piece
	1: _target : <OBJECT or ARRAY> - Self Expllanitory
	2: _rounds : <NUMBER> - Number of rounds to fire
	3: _randomDistance : <NUMBER> - max distance error margin (0 will be directly on target for all rounds)
	4: _randomDirection : <NUMBER> - 360 direction within rounds can land
	5: _fireTime : <ARRAY> - Array of random time between shots for bell curve

Returns:
	Nothing

Examples:
    (begin example)
		[vehicle, target, 2, 100, 360, [9,10,11]] spawn KISKA_fnc_arty;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_arty";

if (!canSuspend) exitWith {
	["ReExecuting in scheduled environment",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_arty;
};

params [
	["_gun",objNull,[objNull]],
	["_target",objNull,[objNull,[]]],
	["_rounds",1,[1]],
	["_randomDistance",0,[1]],
	["_randomDirection",360,[1]],
	["_fireTime",[10,11,12],[[],1]]
];

if (!(alive _gun) OR !(alive (gunner _gun))) exitWith {
	[[_gun," or its gunner are not alive, exiting..."]] call KISKA_fnc_log;
	nil
};

if (_rounds < 1) exitWith {
	[[_gun," was told to fire less than 1 round, exiting..."],true] call KISKA_fnc_log;
	nil
};


private _ammo = (getArtilleryAmmo [_gun]) select 0;
if (isNil "_ammo") exitWith {
	[[_gun," was told to fire but has no ammo, exiting..."]] call KISKA_fnc_log;
	nil
};

private ["_fireDirection","_fireDistance","_targetToAimAt"];
for "_i" from 1 to _rounds do {
	if (!(alive _gun) OR !(alive (gunner _gun))) then {
		[[_gun," or its gunner are not alive, exiting..."]] call KISKA_fnc_log;
		break;
	};

	_fireDirection = round random _randomDirection;
	_fireDistance = round random _randomDistance;
	_targetToAimAt = _target getPos [_fireDistance, _fireDirection];

	_gun doArtilleryFire [_targetToAimAt,_ammo,1];

	_rounds = _rounds - 1;

	if (_i isNotEqualTo _rounds) then {
		sleep (round random _fireTime);
	};
};


nil
