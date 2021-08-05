/* ----------------------------------------------------------------------------
Function: KISKA_fnc_battleSound

Description:
	Create ambient battlefield sounds for a specified duration

Parameters:
	0: _source <OBJECT or ARRAY> - Where the sound is coming from. Can be an object or positions array (ASL)
	1: _distance <NUMBER or ARRAY> - Distance at which the sounds can be heard
	2: _duration <NUMBER> - Distance at which the sound can be heard
	3: _intensity <NUMBER> - Value between 1-5 that determines how frequent these sounds are played (5 being the fastest)

Returns:
	NOTHING

Examples:
    (begin example)
		[player,20,10] spawn KISKA_fnc_battleSound;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_battleSound";

#define MAX_INTENSITY 5
#define MIN_INTENSITY 1
#define EXPLOSION_WEIGHT 0.25
#define FIREFIGHT_WEIGHT 1

if (!isServer) then {
	["Was not run on the server, recommend execution on server in the future",false] call KISKA_fnc_log;
	nil
};
if (!canSuspend) exitWith {
	["Must be run in scheduled envrionment, exiting to scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_battleSound;
};

params [
	["_source",objNull,[objNull,[]]],
	["_distance",500,[[],123]],
	["_duration",60,[123]],
	["_intensity",1,[123]]
];

if (_source isEqualType objNull AND {isNull _source}) exitWith {
	["_source isNull",true] call KISKA_fnc_log;
	nil
};
if (_distance isEqualType 123 AND {_distance <= 0}) exitWith {
	[["_distance is: ",_distance,". It must be higher then 0"],true] call KISKA_fnc_log;
	nil
};
if (_distance isEqualType [] AND {!(_distance isEqualTypeParams [0,0,0])}) exitWith {
	["_distance random array is not configured properly",true] call KISKA_fnc_log;
	nil
};


if (_source isEqualType objNull) then {
	_source = getPosASL _source;
};

if (_intensity > MAX_INTENSITY) then {
	_intensity = MAX_INTENSITY;
} else {
	if (_intensity < MIN_INTENSITY) then {
		_intensity = MIN_INTENSITY;
	};
};

private _intensityArray = switch _intensity do {
	case 1: {[2.5,3,3.5]};
	case 2: {[2,2.5,3]};
	case 3: {[1.5,2,2.5]};
	case 4: {[1,1.5,2]};
	case 5: {[0.5,1,1.5]};
};

private _soundArr = [
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions1.wss",EXPLOSION_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions2.wss",EXPLOSION_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions3.wss",EXPLOSION_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions4.wss",EXPLOSION_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_explosions5.wss",EXPLOSION_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_firefight1.wss",FIREFIGHT_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_firefight2.wss",FIREFIGHT_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_firefight3.wss",FIREFIGHT_WEIGHT,
	"A3\Sounds_F\environment\ambient\battlefield\battlefield_firefight4.wss",FIREFIGHT_WEIGHT
];
private _endTime = _duration + time;
private _timeBetweenSounds = _intensityArray vectorMultiply 4;


waitUntil {
	if (_endTime <= time) exitWith {true};

	private _volume = floor (random [3,4,5]);

	playSound3D [selectRandomWeighted _soundArr, objNull, false, _source, _volume, random [-2,-1,0],[_distance,random _distance] select (_distance isEqualType [])];
	sleep (random _intensityArray);

	playSound3D [selectRandomWeighted _soundArr, objNull, false, _source, _volume, random [-2,-1,0],[_distance,random _distance] select (_distance isEqualType [])];
	sleep (random _timeBetweenSounds);

	false
};


nil
