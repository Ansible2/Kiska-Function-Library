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
    0: _signalProperties : <ARRAY> - The all the properites of the signal

        `_signalProperties` Layout:
        - 0: _id <STRING> - The id of the signal to update
        - 1: _frequency <NUMBER> - The frequency of the signal in MHz
        - 2: _origin <OBJECT or PositionASL[]> - The position of the signal
        - 3: _decibels <NUMBER> - The base signal decibel level when when near the origin
        - 4: _maxDistance <NUMBER> - The max distance that the signal can be seen on the spectrum analyzer
    
    1: _global : <BOOL> - `true` to broadcast the changes to all machines including JIP

Returns:
    <HASHMAP> - Signal's updated property map:

    - `_frequency`: <NUMBER> - The frequency of the signal in MHz
    - `_origin`: <PositionASL[]> - The position of the signal
    - `_maxDistance`: <NUMBER> - The maximum distance the signal can be seen on the analyzer
    - `_decibels`: <NUMBER> - The max decibel level when the analyzer is directly on top of the origin

Examples:
    (begin example)
        // should use KISKA_fnc_spectrum_updateSignal for snyched updates
        // but if you only want a subset of machines:
        [
            [
                "KISKA_spectrumSignal_2_1",
                100,
                [0,0,0],
                100
            ],
            false
        ] remoteExecCall [
            "KISKA_fnc_spectrum_updateSignal",
            [3,4]
        ];
    (end)

    (begin example)
        // broadcast to all machines by default
        [
            [
                "KISKA_spectrumSignal_2_1",
                100,
                [0,0,0],
                100
            ]
        ] call KISKA_fnc_spectrum_updateSignal;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_updateSignal";

#define FREQUENCY_KEY "_frequency"
#define DECIBEL_KEY "_decibels"
#define DISTANCE_KEY "_maxDistance"
#define ORIGIN_KEY "_origin"

params [
    ["_signalProperties",[],[[]]],
    ["_global",true,[true]]
];

_signalProperties params [
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


if (_global AND isMultiplayer) then {
    [
        _signalProperties,
        false
    ] remoteExecCall ["KISKA_fnc_spectrum_updateSignal",-clientOwner,_id];
};


private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
private _idLowered = toLowerANSI _id;
if (_originIsObject) then {
    _origin = getPosASL _origin;
};


private _signalPropertyMap = _signalMap getOrDefaultCall [_idLowered,{-1}];
private _signalExists = _signalPropertyMap isNotEqualTo -1;
if (!_signalExists) then {
    private _signalPropertyMap = createHashMapFromArray [
        [FREQUENCY_KEY,_frequency],
        [ORIGIN_KEY,_origin],
        [DECIBEL_KEY,_decibels],
        [DISTANCE_KEY,_maxDistance]
    ];

    _signalMap set [_idLowered,_signalPropertyMap];

} else {
    _signalPropertyMap set [FREQUENCY_KEY, _frequency];
    _signalPropertyMap set [ORIGIN_KEY, _origin];
    _signalPropertyMap set [DECIBEL_KEY, _decibels];
    _signalPropertyMap set [DISTANCE_KEY, _maxDistance];

};

call KISKA_fnc_spectrum_startSignalLoop;


_signalMap
