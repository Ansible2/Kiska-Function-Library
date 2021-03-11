/* ----------------------------------------------------------------------------
Function: KISKA_fnc_arty

Description:
	Fires a number of rounds from artillery piece at target with random disperstion values

Parameters:
	0: _gun : <OBJECT> - The artillery piece
	1: _target : <OBJECT or ARRAY> - Self Expllanitory
	2: _rounds : <NUMBER> - Number of rounds to fire
	3: _ranDis : <NUMBER> - max distance error margin (0 will be directly on target for all rounds)
	4: _ranDir : <NUMBER> - 360 direction within rounds can land
	5: _fireTime : <ARRAY> - Array of random time between shots for bell curve 

Returns:
	Nothing

Examples:
    (begin example)
		[vehicle, target, 2, 100, 360, [9,10,11]] spawn KISKA_fnc_arty;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define RETURN_NIL nil
scriptName "KISKA_fnc_arty";

if (!canSuspend) exitWith {
	["ReExecuting in scheduled environment",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_arty;
};

params [
	["_gun",objNull,[objNull]],
	["_target",objNull,[objNull,[]]],
	["_rounds",1,[1]],
	["_ranDis",0,[1]],
	["_ranDir",360,[1]],
	["_fireTime",[10,11,12],[[],1]]
];

if (!alive _gun OR {!alive (gunner _gun)}) exitWith {
	[[_gun," or its gunner are not alive, exiting..."]] call KISKA_fnc_log;
	RETURN_NIL
};

if (_rounds < 1) exitWith {
	[[_gun," was told to fire less than 1 round, exiting..."],true] call KISKA_fnc_log;
	RETURN_NIL
};

private _ammo = getArtilleryAmmo [_gun] select 0; 
private ["_dir","_dis","_tgt"];

for "_i" from 1 to _rounds do {
	if (!alive _gun OR {!alive (gunner _gun)}) exitWith {
		[[_gun," or its gunner are not alive, exiting..."]] call KISKA_fnc_log;
	};
	
	_dir = round random _ranDir; 
	_dis = round random _ranDis;
	_tgt = _target getPos [_dis, _dir]; 
	_gun doArtilleryFire [_tgt,_ammo,1]; 
	_rounds = _rounds - 1;
	
	if (_i != _rounds) then { 
		sleep (round random _fireTime);
	};
};


RETURN_NIL