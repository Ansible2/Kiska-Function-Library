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
	<BOOL> - True if sound found and played, false if error

Examples:
    (begin example)
		["BattlefieldJet1_3D",(getPosASL player) vectorAdd [50,50,100],200] call KISKA_fnc_playSound3D;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playSound3D";

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
	["_sound is empty string",true] call KISKA_fnc_log;
	false
};

if ((_origin isEqualType objNull) AND {isNull _origin}) exitWith {
	["_origin object isNull",true] call KISKA_fnc_log;
	false
};

if ((_origin isEqualType []) AND {_origin isEqualTo []}) exitWith {
	["_origin is empty array",true] call KISKA_fnc_log;
	false
};

if (_distance < 0) exitWith {
	[["_distance is: ",_distance," and cannot be negative"],true] call KISKA_fnc_log;
	false
};


// get actual path of file from config
_fn_getSoundPath = {
	if (isClass (configFile / "CfgSounds" / _sound)) exitWith {
		(getArray (configFile >> "CfgSounds" >> _sound >> "sound")) select 0
	};
	if (isClass (missionConfigFile / "CfgSounds" / _sound)) exitWith {
		getMissionPath ((getArray (missionConfigFile >> "CfgSounds" >> _sound >> "sound")) select 0)
	};
	if (isClass (configFile / "cfgMusic" / _sound)) exitWith {
		(getArray (configFile >> "cfgMusic" >> _sound >> "sound")) select 0
	};
	if (isClass (missionConfigFile / "cfgMusic" / _sound)) exitWith {
		getMissionPath ((getArray (missionConfigFile >> "cfgMusic" >> _sound >> "sound")) select 0)
	};
};

private _soundPath = [_sound] call _fn_getSoundPath;

if (!(_soundPath isEqualType "") OR {_soundPath isEqualTo ""}) exitWith {
	["_sound: ",_sound," is configed incorrectly",true] call KISKA_fnc_log;
	false
};


if (_origin isEqualType objNull) then {
	_origin = getPosASL _origin;
};

// check for bohemia weird chars on file paths
private _firstChar = _soundPath select [0,1];
if (_firstChar in ["@","\"]) then {
	_soundPath = _soundPath trim [_firstChar,1];
	//_soundPath = [_soundPath,_firstChar] call CBA_fnc_leftTrim;
};

// check if bohemia didn't add file extension
if !(toLowerANSI (_soundPath select [(count _soundPath) - 4,4]) in [".wss",".ogg",".wav"]) then {
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