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
	["_source",objNull,[objNull,[]],[3]]
	["_sounds",[],[[]]],
	["_timeBetweenSounds",5,[[],123]]
];

// parse sounds into hashmap with configs


// takes an array of sounds
// sounds can be string (cfgSound classname) or an array [classname,duration of sound]
// sounds are ultimately evaluated into an array of [config of sound,duration of sound]
// update playound 3d to also accept configs and skip trying to find it

private _soundsParsed = _sounds apply {
	private _sound = _x;
	private ["_soundConfig","_duration"];

	if (_sound isEqualType []) then {
		if ((count _sound) < 2) then {continue};
		_soundConfig = _sound select 0;
		_duration = _sound select 1;

	} else {
		if (_sound isEqualType "") exitWith {
			["CfgSounds","CfgMusic"] apply {
				_soundConfig = [[_x,_sound]] call KISKA_fnc_findConfigAny;
				if !(isNull _soundConfig) then {break};
			};
		};

		_soundConfig = _sound;
		_duration = getNumber(_soundsConfig >> "duration");
		
	};

	if (isNull _soundConfig OR _duration <= 0) then {continue};
	[_soundConfig,_duration]
};


private _playNextSound = {
	params [
		"_unusedSounds",
		"_usedSounds",
		"_playNextSound",
		"_timeBetweenSounds"
	];

	private _unusedIsEmpty = _unusedSounds isEqualTo [];
	if (_unusedIsEmpty AND (_usedSounds isEqualTo [])) exitWith {
		["Both _unusedSounds and _usedSounds were empty arrays. Exited loop...",true] call KISKA_fnc_log;
		nil
	};

	if (_unusedIsEmpty) then {
		_unusedSounds = _usedSounds;
	};

	private _selectedSound = [_unusedSounds] call KISKA_fnc_deleteRandomIndex;
	private _soundConfig = _selectedSound select 0;
	[_soundConfig] call KISKA_fnc_playSound3d;

	_usedSounds pushBack _selectedSound;

	private _interval = [_timeBetweenSounds,random _timeBetweenSounds] select (_timeBetweenSounds isEqualType []);
	private _soundDuration = _selectedSound select 1;
	private _timeUntilNextSound = _soundDuration + _interval;
	[
		_playNextSound,
		_this,
		_timeUntilNextSound
	] call CBA_fnc_waitAndExecute;
};


[
	_soundsParsed,
	[],
	_playNextSound,
	_timeBetweenSounds
] call _playNextSound;


nil
