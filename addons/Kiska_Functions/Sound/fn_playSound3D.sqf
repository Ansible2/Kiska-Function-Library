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
		["BattlefieldJet1_3D",(getPosASL player) vectorAdd [50,50,100],2000] call KISKA_fnc_playSound3D;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playSound3D";

#define FILE_EXTENSIONS [".wss",".ogg",".wav"]

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
private _soundConfig = [["CfgSounds",_sound]] call KISKA_fnc_findConfigAny;
if (isNull _soundConfig) exitWith {
	[["Could not find a config for the sound: ",_sound],true] call KISKA_fnc_log;
	false
};

private _soundPath = (getArray(_soundConfig >> "sound")) select 0;
if ([_soundConfig, missionConfigFile] call CBA_fnc_inheritsFrom) then {
	_soundPath = getMissionPath + _soundPath;
};


if (!(_soundPath isEqualType "") OR {_soundPath isEqualTo ""}) exitWith {
	["_sound: ",_sound," is configed incorrectly",true] call KISKA_fnc_log;
	false
};


if (_origin isEqualType objNull) then {
	_origin = getPosASL _origin;
};

// Some Bohmemia sound paths had a "@" or "\" at the front
// playSound3D will not find the file if this is the case
private _firstChar = _soundPath select [0,1];
if (_firstChar in ["@","\"]) then {
	_soundPath = _soundPath trim [_firstChar,1];
};


private _fileNotFound = false;
private _tempPath = "";
if !(fileExists _soundPath) then {
	private _hasFileExtension = (toLowerANSI (_soundPath select [(count _soundPath) - 4,4])) in FILE_EXTENSIONS;
	if !(_hasFileExtension) then {
		_fileNotFound = true;

		FILE_EXTENSIONS apply {
			_tempPath = _soundPath + _x;
			if (fileExists _tempPath) then {
				_fileNotFound = false;
				_soundPath = _tempPath;
				break;
			};

		};

	} else {
		_fileNotFound = true;

	};

};

if (_fileNotFound) exitWith {
	[["Could not find file at path: ", _soundPath],true] call KISKA_fnc_log;
	false
};

playSound3D [_soundPath,objNull,_isInside,_origin,_volume,_pitch,_distance];


true