/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playSound3D

Description:
	Plays a sound 3D but the function accepts the CFGSounds name rather then the file path.

Parameters:
	0: _sound <STRING> - The sound to play. Sound classname like the command playSound or playMusic (this also accepts music tracks)
	1: _origin <OBJECT or ARRAY> - The position (ASL) or object from which the sound comes from
	2: _distance <NUMBER> - Distance at which the sound can be heard
	3: _volume <NUMBER> - Range from 0-5
	4: _isInside <BOOL> - Is _origin inside
	5: _pitch <NUMBER> - Range from 0-5


Returns:
	BOOL

Examples:
    (begin example)

		["BattlefieldJet1_3D",(getPosASL player) vectorAdd [50,50,100],200] call KISKA_fnc_playSound3D;

    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
params [
	["_sound","",[""]],
	["_origin",objNull,[objNull,[]]],
	["_distance",20,[123]],
	["_volume",1,[123]],
	["_isInside",false,[true]],
	["_pitch",1,[123]]
];


// verify params
if (_sound isEqualTo "") exitWith {
	"_sound is empty string" call BIS_fnc_error;
	false
};

if (!(isCLass (configFile / "CfgSounds" / _sound)) AND {!(isClass (missionConfigFile / "CfgSounds" / _sound))} AND {!(isClass (missionConfigFile / "cfgMusic" / _sound))} AND {!(isClass (configFile / "cfgMusic" / _sound))}) exitWith {
	"_sound is undefined in config" call BIS_fnc_error;
	false
};

if ((_origin isEqualType objNull) AND {isNull _origin}) exitWith {
	"_origin object isNull" call BIS_fnc_error;
	false
};

if ((_origin isEqualType []) AND {_origin isEqualTo []}) exitWith {
	"_origin is empty array" call BIS_fnc_error;
	false
};

if (_distance < 0) exitWith {
	"_distance is negative" call BIS_fnc_error;
	false
};


// get actual path of file form config
_fn_getSoundPath = {
	params ["_sound"];

	if (isCLass (configFile / "CfgSounds" / _sound)) exitWith {
		(getArray (configFile >> "CfgSounds" >> _sound >> "sound")) select 0
	};
	if (isCLass (missionConfigFile / "CfgSounds" / _sound)) exitWith {
		(getArray (missionConfigFile >> "CfgSounds" >> _sound >> "sound")) select 0
	};// need to test mission paths to see if they need getMissionpath
	if (isCLass (configFile / "cfgMusic" / _sound)) exitWith {
		(getArray (configFile >> "cfgMusic" >> _sound >> "sound")) select 0
	};
	if (isCLass (missionConfigFile / "cfgMusic" / _sound)) exitWith {
		(getArray (missionConfigFile >> "cfgMusic" >> _sound >> "sound")) select 0
	};
};

private _soundPath = [_sound] call _fn_getSoundPath;

if !(_soundPath isEqualType "") exitWith {
	"_sound is configed incorrectly" call BIS_fnc_error;
	false
};


if (_origin isEqualType objNull) then {
	_origin = getPosASL _origin;
};

// check for bohemia weird chars on file paths
private _firstChar = _soundPath select [0,1];
if (_firstChar in ["@","\"]) then {
	_soundPath = [_soundPath,_firstChar] call CBA_fnc_leftTrim;
};

// check if bohemia didn't add file extension
if !(toLower (_soundPath select [(count _soundPath) - 4,4]) in [".wss",".ogg",".wav"]) then {
	private _soundpath1 = _soundPath + ".wss";
	private _soundpath2 = _soundPath + ".ogg";
	private _soundpath3 = _soundPath + ".wav"; // one of these has to be right, right?

	// playsound
	[_soundPath1,_soundPath2,_soundPath3] apply {
		playSound3D [_x,objNull,_isInside,_origin,_volume,_pitch,_distance];
	};
} else {
	// playsound
	playSound3D [_soundPath,objNull,_isInside,_origin,_volume,_pitch,_distance];
};

true