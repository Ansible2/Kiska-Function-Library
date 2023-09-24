/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_updateSignal_global

Description:
    Updates a signal's base properties for ALL machines (and JIP) or creates it if it
     did not exist prior. It is not recommended to directly create a signal with this
     function. Rather use`KISKA_fnc_spectrum_addSignal_global`.

    WARNING, this function updats ALL base properties. Meaning if you intend to
     a single property, use the corresponding setter function. For example, to update
     the origin position only and not every signal property, use 
     `KISKA_fnc_spectrum_setSignalPosition_global`.

Parameters:
    0: _id : <STRING> - The id of the signal to update
    1: _frequency : <NUMBER> - The frequency of the signal in MHz
    2: _origin : <OBJECT or PositionASL[]> - The position of the signal
    3: _decibels : <NUMBER> - The base signal decibel level when when near the origin
    4: _maxDistance : <NUMBER> - The max distance that the signal can be seen on the spectrum analyzer

Returns:
    NOTHING

Examples:
    (begin example)
        // should use KISKA_fnc_spectrum_updateSignal_global for snyched updates
        // but if you only want a subset of machines:
        [
            "KISKA_spectrumSignal_2_1",
            100,
            [0,0,0],
            100
        ] call KISKA_fnc_spectrum_updateSignal_global
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_updateSignal_global";

// only defining params for type checking
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

if ((_origin isEqualType objNull) AND {isNull _origin}) exitWith {
    [["Provided origin is null object; attempting to update signal: ",_id],true] call KISKA_fnc_log;
    nil
};

if (_maxDistance <= 0) exitWith {
    [["Max distance must be positive number; attempting to update signal: ",_id],true] call KISKA_fnc_log;
    nil
};


_this remoteExecCall ["KISKA_fnc_spectrum_updateSignal", 0, _id];


nil
