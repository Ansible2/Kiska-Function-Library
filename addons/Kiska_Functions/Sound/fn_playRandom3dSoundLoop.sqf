/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playRandom3dSoundLoop

Description:


Parameters:
	0: _origin <OBJECT or ARRAY> - The positionASL or object from which the sound will
		originate.
	1: _sounds <ARRAY> - An array of sounds to play randomly with any combination of three formats:
		- <STRING>: A config name of a sound in either CfgSounds and/or CfgMusic. This config Must
			have a "duration" number property. 
		- [<STRING>,<NUMBER>] ([<configClassName>,<duration>]): a config class name that is in CfgSounds 
			and/or CfgMusic and the duration the sound lasts.
		- <CONFIG>: a config path to a class with a "sound[]" array property that has it's first entry
			as a sound file path, and has a "duration" number property.
	2: _timeBetweenSounds1 <NUMBER or ARRAY> - A buffer time between each sound once one completes. 
		If array, random syntax of random [min,mid,max] is used to get buffer each time a sound completes.
	3: _soundParams <ARRAY> - An array of parameters for playSound3D:
		0: _distance <NUMBER> - Distance at which the sound can be heard
		1: _volume <NUMBER> - Range from 0-5
		2: _isInside <BOOL> - Is _origin inside
		3: _pitch <NUMBER> - Range from 0-5
	4: _onSoundPlayed <ARRAY, CODE, STRING> - A callback function that executes each time a sound is played
		(See KISKA_fnc_callback). Parameters are:
		0: <NUMBER> - An id that can be used with KISKA_fnc_stopRandom3dSoundLoop to stop sounds
		1: <OBJECT or ARRAY> - The position the sound is playing at
		2: <CONFIG> - The config of the current sound being played

Returns:
	<NUMBER> - An id that can be used with KISKA_fnc_stopRandom3dSoundLoop to stop
		the sound loop.

Examples:
    (begin example)
		[
			player,
			[],
			5,
			[],
			{hint str _this}
		] call KISKA_fnc_playRandom3dSoundLoop;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playRandom3dSoundLoop";

params [
	["_origin",objNull,[objNull,[]],[3]],
	["_sounds",[],[[]]],
	["_timeBetweenSounds",5,[[],123],[3]],
	["_soundParams",[],[[]]],
	["_onSoundPlayed",{},[[],{},""]]
];

// verify params
_soundParams params [
	["_distance",20,[123]],
	["_volume",1,[123]],
	["_isInside",false,[true]],
	["_pitch",1,[123]]
];


private _soundsParsed = _sounds apply {
	private _sound = _x;
	private ["_soundConfig","_duration"];

	if (_sound isEqualType []) then {
		if ((count _sound) < 2) then {continue};
		_soundConfig = _sound select 0;

		if !(_soundConfig isEqualTypeAny ["",configNull]) then {continue};
		if (_soundConfig isEqualType "") then {
			private _soundConfigName = _soundConfig;
			["CfgSounds","CfgMusic"] apply {
				_soundConfig = [[_x,_soundConfigName]] call KISKA_fnc_findConfigAny;
				if !(isNull _soundConfig) then {break};
			};
		};
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
		"_origin",
		"_unusedSounds",
		"_usedSounds",
		"_playNextSound",
		"_timeBetweenSounds",
		"_soundParams",
		"_onSoundPlayed",
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
	_soundParams params [
		["_distance",20,[123]],
		["_volume",1,[123]],
		["_isInside",false,[true]],
		["_pitch",1,[123]]
	];

	[
		_soundConfig,
		_origin,
		_distance,
		_volume,
		_isInside,
		_pitch
	] call KISKA_fnc_playSound3d;
	
	[
		[_id,_origin,_soundConfig],
		_onSoundPlayed
	] call KISKA_fnc_callBack;

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
	_origin,
	_soundsParsed,
	[],
	_playNextSound,
	_timeBetweenSounds,
	_soundParams,
	_onSoundPlayed,
	_id
] call _playNextSound;


_id
