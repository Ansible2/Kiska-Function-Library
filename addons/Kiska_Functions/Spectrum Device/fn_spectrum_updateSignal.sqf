/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_updateSignal

Description:
    Updates a signal's base properties for the local machine or creates it if it
     did not exist prior. It is not recommended to directly create a signal with this
     function. Rather use `KISKA_fnc_spectrum_addSignal`.

    WARNING, this function updats ALL base properties. Meaning if you intend to
     a single property, use the corresponding setter function. For example, to update
     the origin position only and not every signal property, use 
     `KISKA_fnc_spectrum_setSignalPosition`.

Parameters:
    0: _id : <STRING> - The id of the signal to update
    1: _frequency : <NUMBER> - The frequency of the signal in MHz
    2: _origin : <OBJECT or PositionASL[]> - The position of the signal
    3: _decibels : <NUMBER> - The base signal decibel level when when near the origin
    4: _maxDistance : <NUMBER> - The max distance that the signal can be seen on the spectrum analyzer

Returns:
    <HASHMAP> - Signal's updated property map:

    - `_frequency`: <NUMBER> - The frequency of the signal in MHz
    - `_origin`: <PositionASL[]> - The position of the signal
    - `_maxDistance`: <NUMBER> - The frequency of the signal in MHz
    - `_decibels`: <NUMBER> - The frequency of the signal in MHz

Examples:
    (begin example)
        // should use KISKA_fnc_spectrum_updateSignal_global for snyched updates
        // but if you only want a subset of machines:
        [
            "KISKA_spectrumSignal_2_1",
            100,
            [0,0,0],
            100
        ] remoteExecCall [
            "KISKA_fnc_spectrum_updateSignal",
            [3,4],
            "KISKA_spectrumSignal_2_1"
        ];
    (end)

    (begin example)
        [
            "KISKA_spectrumSignal_2_1",
            100,
            [0,0,0],
            100
        ] call KISKA_fnc_spectrum_updateSignal;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_updateSignal";

#define FREQUENCY_KEY "_frequency"
#define ORIGIN_KEY "_origin"
#define DECIBEL_KEY "_decibels"
#define DISTANCE_KEY "_maxDistance"

params [
    ["_id","",[""]],
    ["_frequency",100,[123]],
    ["_origin",objNull,[[],objNull],[3]],
    ["_decibels",-100,[123]],
    ["_maxDistance",worldSize,[123]]
];

if (_frequency <= 0) exitWith {
    [
        [
            "Signal can't be added, must have a frequency above 0, current is: ",
            _frequency,
            ". Signal being updated: ",
            _id
        ],
        true
    ] call KISKA_fnc_log;
    nil
};

private _originIsObject = _origin isEqualType objNull;
if (_originIsObject AND {isNull _origin}) exitWith {
    [["Provided origin is null object; attempting to update signal: ",_id],true] call KISKA_fnc_log;
    nil
};

if (_maxDistance <= 0) exitWith {
    [["Max distance must be positive number; attempting to update signal: ",_id],true] call KISKA_fnc_log;
    nil
};


private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
private _idLowered = toLowerANSI _id;
if (_originIsObject) then {
    _origin = getPosASL _origin;
};


private _signalExists = [_idLowered] call KISKA_fnc_spectrum_signalExists;
if !(_signalExists) then {
    private _signalPropertyMap = createHashMapFromArray [
        [FREQUENCY_KEY,_frequency],
        [ORIGIN_KEY,_origin],
        [DECIBEL_KEY,_decibels],
        [DISTANCE_KEY,_maxDistance]
    ];

    _signalMap set [_idLowered,_signalPropertyMap];

} else {
    _signalMap set [FREQUENCY_KEY, _frequency];
    _signalMap set [ORIGIN_KEY, _origin];
    _signalMap set [DECIBEL_KEY, _decibels];
    _signalMap set [DISTANCE_KEY, _maxDistance];

};

call KISKA_fnc_spectrum_startLogicLoop;

_signalMap
