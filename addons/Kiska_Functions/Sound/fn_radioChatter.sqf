/* ----------------------------------------------------------------------------
Function: KISKA_fnc_radioChatter

Description:
	Plays a random radio ambient at the specified position.

	This has a global effect now and should be executed on one machine.

Parameters:
	0: _followSource <BOOL> - Should the radio audio be attached to the _source object?
		This will use say3D instead of playSound3d.
	1: _soundParams <ARRAY> - An array of parameters that are slightly different depending on the _followSource value
		If _followSource is true:
			0: _source <OBJECT> - Where the sound is coming from
			1: _distance <NUMBER> - Max distance at which the sound can be heard
			2: _offset <ARRAY> - AttachTo coordinates that can be used to offset the sound
		If _followSource is false:
			0: _source <OBJECT or ARRAY> - Where the sound is coming from.
				If array format positionASL.
			1: _distance <NUMBER> - Max distance at which the sound can be heard
			2: _volume <NUMBER> - How loud the sound plays

Returns:
	<NUMBER> - the "chatter ID" that can be used with KISKA_fnc_stopRadioChatter. -1 if error

Examples:
    (begin example)
		// radio sound follows player
		[
			true,
			[player]
		] call KISKA_fnc_radioChatter;
    (end)
    (begin example)
		// radio sound follows front of player
		[
			true,
			[player,5,[0,1,0]]
		] call KISKA_fnc_radioChatter;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_radioChatter";

#define SOUND_PITCH 1
#define HELPER_OBJECT_CLASS "Sign_Arrow_Cyan_F"
#define DEFAULT_OFFSET [0,0,0]

params [
	["_followSource",false,[true]],
	["_soundParams",[],[[]]],
	["_chatterId",-1,[123]]
];
// helper object and all variables are deleted if the object dies
// stop radio knows how to delete helper object

private _hasChatterId = _chatterId > -1;
private _idIsPlaying = localNamespace getVariable ["KISKA_radioChatterIsPlaying_" + (str _chatterId), false];
if (
	_hasChatterId AND
	{!_idIsPlaying}
) exitWith {
	-1
};

if (_soundParams isEqualTo []) exitWith {
	["_soundParams is empty!"] call KISKA_fnc_log;
	-1
};


private _numberStr = str ([2,30] call BIS_fnc_randomInt);
private _radioSound = "KISKA_radioAmbient" + _numberStr;
private _soundCreated = false;
private _helperObject = objNull;
if (_followSource) then {
	_soundParams params [
		["_source",objNull,[objNull]],
		["_distance",20,[123]],
		["_offset",DEFAULT_OFFSET,[[]],[3]]
	];

	if (isNull _source) exitWith {
		["Sound source isNull"] call KISKA_fnc_log;
		if (_hasChatterId) then {
			// delete helper object if source is dead
			[_chatterId] call KISKA_fnc_stopRadioChatter;
		};
	};

	private _actualSource = objNull;
	if (_hasChatterId) then {
		_actualSource = localNamespace getVariable ["KISKA_radioChatter_offsetObject_" + (str _chatterId), objNull];
	};

	private _hasOffsetObject = !(isNull _actualSource);
	if !(_hasOffsetObject) then {
		_actualSource = _source;
		if (_offset isNotEqualTo DEFAULT_OFFSET) then {
			_actualSource = HELPER_OBJECT_CLASS createVehicle [0,0,0];
			_helperObject = _actualSource;
			/* [_actualSource, true] remoteExec ["hideObjectGlobal", 2]; */
			_actualSource attachTo [_source,_offset];
		};

	};


	[_actualSource, [_radioSound, _distance, SOUND_PITCH, true]] remoteExec ["say3D",0];
	_soundCreated = true;

} else {
	_soundParams params [
		["_source",[],[objNull,[]],[3]],
		["_distance",20,[123]],
		["_volume",1,[123]]
	];

	private _sourceIsObject = _source isEqualType objNull;
	if (_sourceIsObject AND {isNull _source}) exitWith {
		["Sound source isNull"] call KISKA_fnc_log;
		if (_hasChatterId) then {
			[_chatterId] call KISKA_fnc_stopRadioChatter;
		};
	};

	private _actualSource = _source;
	if !(_sourceIsObject) then {
		_actualSource = getPosASL _source;
	};

	[_radioSound,_actualSource,_distance,_volume] call KISKA_fnc_playSound3D;
	_soundCreated = true;

};


if !(_soundCreated) exitWith {
	["Failed to create radio chatter!"] call KISKA_fnc_log;
	-1
};

if !(_hasChatterId) then {
	_chatterId = localNamespace getVariable ["KISKA_radioChatterId_latestIndex",0];
	localNamespace setVariable ["KISKA_radioChatterId_latestIndex",_chatterId + 1];

	private _stringChatterId = str _chatterId;
	localNamespace setVariable [("KISKA_radioChatterIsPlaying_" + _stringChatterId), true];
	if !(isNull _helperObject) then {
		localNamespace setVariable ["KISKA_radioChatter_offsetObject_" + _stringChatterId, _helperObject];
	};
};


private _soundDuration = getNumber (configFile >> "CfgSounds" >> _radioSound >> "duration");
private _randomBuffer = random [1,5,10];
[
	{
		_this call KISKA_fnc_radioChatter;
	},
	[_followSource, _soundParams, _chatterId],
	(_soundDuration + _randomBuffer)
] call CBA_fnc_waitAndExecute;


_chatterId
