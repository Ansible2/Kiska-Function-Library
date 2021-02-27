/* ----------------------------------------------------------------------------
Function: KISKA_fnc_arty

Description:
	Fires a number of rounds from artillery piece at target with random disperstion values

Parameters:
	0: _gun : <OBJECT> - The artillery piece
	1: _target : <OBJECT> - Self Expllanitory
	2: _rounds : <NUMBER> - Number of rounds to fire
	3: _ranDis : <NUMBER> - max distance error margin (0 will be directly on target for all rounds)
	4: _ranDir : <NUMBER> - 360 direction within rounds can land
	5: _fireTime : <ARRAY> - Array of random time between shots for bell curve 

Returns:
	Nothing

Examples:
    (begin example)
		null = [vehicle, target, 2, 100, 360, [9,10,11]] spawn KISKA_fnc_arty;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_arty"
scriptName SCRIPT_NAME;

if (!canSuspend) exitWith {
	_this spawn KISKA_fnc_arty;
	[SCRIPT_NAME,"ReExevuting in scheduled environment",false,true] call KISKA_fnc_log;
};

params [
	["_gun",objNull,[objNull]],
	["_target",objNull,[objNull]],
	["_rounds",1,[1]],
	["_ranDis",0,[1]],
	["_ranDir",360,[1]],
	["_fireTime",[10,11,12],[[],1]]
];

if (!alive _gun OR {!alive (gunner _gun)}) exitWith {
	[SCRIPT_NAME,[_gun,"or its gunner are not alive, exiting..."]] call KISKA_fnc_log;
};

if (_rounds < 1) exitWith {
	[SCRIPT_NAME,[_gun,"was told to fire less than 1 round, exiting..."],true,true] call KISKA_fnc_log;
	[[_gun," was told to fire less than 1 round, exiting..."],true] call KISKA_fnc_log;
};

private _ammo = getArtilleryAmmo [_gun] select 0; 

for "_i" from 1 to _rounds do {

	private _dir = round random _ranDir; 
	private _dis = round random _ranDis;
	private _tgt = _target getRelPos [_dis, _dir]; 
	_gun doArtilleryFire [_tgt,_ammo,1]; 
	_rounds = _rounds - 1;
	
	if (_i != _rounds) then {
		sleep (round random _fireTime);
	};
};