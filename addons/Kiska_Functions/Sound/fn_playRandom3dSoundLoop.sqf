/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playRandom3dSoundLoop

Description:


Parameters:
	0:  <> -

Returns:
	NOTHING

Examples:
    (begin example)
		[

		] call KISKA_fnc_playRandom3dSoundLoop;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playRandom3dSoundLoop";

params [
	["_source",objNull,[objNull,[]],[3]],
	["_sounds",[],[[]]],
	["_timeBetweenSounds",5,[[],123]]
];


private _soundsParsed = _sounds apply {
	private _sound = _x;
	private ["_soundConfig","_duration"];

	if (_sound isEqualType []) then {
		if ((count _sound) < 2) then {continue};
		_soundConfig = _sound select 0;
		_duration = _sound select 1;

	} else {
		if (_sound isEqualType "") then {
			["CfgSounds","CfgMusic"] apply {
				_soundConfig = [[_x,_sound]] call KISKA_fnc_findConfigAny;
				if !(isNull _soundConfig) then {break};
			};
		} else {
			_soundConfig = _sound;
		};

		_duration = getNumber(_soundConfig >> "duration");

	};

	if (isNull _soundConfig OR _duration <= 0) then {continue};
	[_soundConfig,_duration]
};


private _playNextSound = {
	params [
		"_source",
		"_unusedSounds",
		"_usedSounds",
		"_playNextSound",
		"_timeBetweenSounds",
		"_id"
	];

	private _isPlaying = localNamespace getVariable [("KISKA_random3dSoundLoopIsPlaying_" + (str _id)), false];
	if (!_isPlaying) exitWith {};

	private _params = _this;
	private _unusedIsEmpty = _unusedSounds isEqualTo [];
	if (_unusedIsEmpty AND (_usedSounds isEqualTo [])) exitWith {
		["Both _unusedSounds and _usedSounds were empty arrays. Exited loop...",true] call KISKA_fnc_log;
		nil
	};

	if (_unusedIsEmpty) then {
		_unusedSounds = _usedSounds;
		_usedSounds = [];
		_params set [1,_unusedSounds];
		_params set [2,_usedSounds];
	};

	private _selectedSound = [_unusedSounds] call KISKA_fnc_deleteRandomIndex;
	private _soundConfig = _selectedSound select 0;
	[_soundConfig,_source] call KISKA_fnc_playSound3d;

	_usedSounds pushBack _selectedSound;

	private _interval = [_timeBetweenSounds,random _timeBetweenSounds] select (_timeBetweenSounds isEqualType []);
	private _soundDuration = _selectedSound select 1;
	private _timeUntilNextSound = _soundDuration + _interval;
	[
		_playNextSound,
		_params,
		_timeUntilNextSound
	] call CBA_fnc_waitAndExecute;
};

private _id = ["KISKA_random3dSoundLoop"] call KISKA_fnc_idCounter;
localNamespace setVariable [("KISKA_random3dSoundLoopIsPlaying_" + (str _id)), true];

[
	_source,
	_soundsParsed,
	[],
	_playNextSound,
	_timeBetweenSounds,
	_id
] call _playNextSound;


nil
