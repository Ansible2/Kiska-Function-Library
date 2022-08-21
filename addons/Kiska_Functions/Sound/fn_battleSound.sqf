/* ----------------------------------------------------------------------------
Function: KISKA_fnc_battleSound

Description:
	Create ambient battlefield sounds for a specified duration

Parameters:
	0: _source <OBJECT or ARRAY> - Where the sound is coming from. Can be an object or positions array (ASL)
	1: _distance <NUMBER or ARRAY> - Distance at which the sounds can be heard,
		if an array, will be used with the "random" command (random _distance)
		for getting a random value between the numbers.
	2: _duration <NUMBER> - How long the sounds should play for in seconds
	3: _intensity <NUMBER> - Value between 1-5 that determines how frequent these sounds are played (5 being the fastest)

Returns:
	NOTHING

Examples:
    (begin example)
		[player,20,10] spawn KISKA_fnc_battleSound;
    (end)
	(begin example)
		// distance will be between 10-30m, leaning towards 20m
		[player,[10,20,30],10] spawn KISKA_fnc_battleSound;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_battleSound";

#define MAX_INTENSITY 5
#define MIN_INTENSITY 1
#define EXPLOSION_WEIGHT 0.25
#define FIREFIGHT_WEIGHT 1

params [
	["_source",objNull,[objNull,[]],[3]],
	["_distance",500,[[],123],[3]],
	["_duration",60,[123]],
	["_intensity",1,[123]],
    ["_battleSoundId",-1,[123]]
];

private _hasBattleSoundId = _battleSoundId > -1;
private _idIsPlaying = localNamespace getVariable ["KISKA_battleSoundIsPlaying_" + (str _battleSoundId), false];
if (
	_hasBattleSoundId AND
	(!_idIsPlaying)
) exitWith {
	-1
};

private _sourceIsObject = _source isEqualType objNull;
if (_sourceIsObject AND {isNull _source}) exitWith {
	["_source isNull",true] call KISKA_fnc_log;
	nil
};
if ((_distance isEqualType 123) AND {_distance <= 0}) exitWith {
	[["_distance is: ",_distance,". It must be higher then 0"],true] call KISKA_fnc_log;
	nil
};
private _sourceIsArray = _distance isEqualType [];
if (_sourceIsArray AND {!(_distance isEqualTypeParams [0,0,0])}) exitWith {
	["_distance random array is not configured properly",true] call KISKA_fnc_log;
	nil
};

private _actualSource = _source;
if (_sourceIsObject) then {
	_actualSource = getPosASL _source;
};

if (_intensity > MAX_INTENSITY) then {
	_intensity = MAX_INTENSITY;
} else {
	if (_intensity < MIN_INTENSITY) then {
		_intensity = MIN_INTENSITY;
	};
};

private _intensities = localNamespace getVariable ["KISKA_battleSoundIntensities",[]];
if (_intensities isEqualTo []) then {
    _intensities = [
        [2.5,3,3.5],
        [2,2.5,3],
        [1.5,2,2.5],
        [1,1.5,2],
        [0.5,1,1.5]
    ];
    localNamespace setVariable ["KISKA_battleSoundIntensities",_intensities];
};
private _intensityArray = _intensities select (_intensity - 1);


private _soundsArray = localNamespace getVariable ["KISKA_battleSounds",[]];
if (_soundsArray isEqualTo []) then {
    _soundsArray = [
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
    localNamespace setVariable ["KISKA_battleSounds",_soundsArray];
};


private _distanceIsArray = _distance isEqualType [];
private _volume = floor (random [3,4,5]);
playSound3D [
    selectRandomWeighted _soundsArray,
    objNull,
    false,
    _actualSource,
    _volume,
    random [-2,0,1],
    [_distance,random _distance] select _distanceIsArray
];


if !(_hasBattleSoundId) then {
	_battleSoundId = ["KISKA_battleSoundId_latestIndex"] call KISKA_fnc_idCounter;
	private _stringBattleSoundId = str _battleSoundId;
	localNamespace setVariable [("KISKA_battleSoundIsPlaying_" + _stringBattleSoundId), true];
};

if (_duration > 0) then {
	[
		KISKA_fnc_stopBattleSound,
		[_battleSoundId],
		_duration
	] call CBA_fnc_waitAndExecute;

	_duration = -1;
};


private _timeUntilSecondSound = random _intensityArray;
private _timeBetweenNextCall = _intensityArray vectorMultiply 4;
[
    {
        params [
            "_soundsArray",
            "_actualSource",
            "_volume",
            "_distance"
        ];
        playSound3D [
    		selectRandomWeighted _soundsArray,
    		objNull,
    		false,
    		_actualSource,
    		_volume,
    		random [-2,0,1],
    		_distance
    	];
    },
    [
        _soundsArray,
        _actualSource,
        _volume,
        [_distance,random _distance] select _distanceIsArray
    ],
    _timeUntilSecondSound
] call CBA_fnc_waitAndExecute;


[
    {
        _this call KISKA_fnc_battleSound;
    },
    [
        _source,
        _distance,
        _duration,
        _intensity,
        _battleSoundId
    ],
    (_timeUntilSecondSound + (random _timeBetweenNextCall))
] call CBA_fnc_waitAndExecute;


_battleSoundId
