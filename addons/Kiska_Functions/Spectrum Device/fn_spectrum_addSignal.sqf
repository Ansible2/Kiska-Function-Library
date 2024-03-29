/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_addSignal

Description:
    Adds a signal that can be seen on a spectrum device. 

Parameters:
    0: _signalProperties : <ARRAY> - The all the properites of the signal

        `_signalProperties` Layout:
        - 0: _frequency <NUMBER> - The frequency of the signal in MHz
        - 1: _origin <OBJECT or PositionASL[]> - The position of the signal
        - 2: _decibels <NUMBER> - The base signal decibel level when when near the origin
        - 3: _maxDistance <NUMBER> - The max distance that the signal can be seen on the spectrum
        analyzer. This will be what governs how the signal strength increases/decreases depending
        on the user's position. Default is `worldSize`.

    1: _global : <BOOL> - `true` to broadcast the changes to all machines including JIP

Returns:
    <STRING> - The corresponding ID for the signal

Examples:
    (begin example)
        private _signalId = [
            [100,[0,0,0],100]
        ] call KISKA_fnc_spectrum_addSignal;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_addSignal";

params [
    ["_signalProperties",[],[[]]],
    ["_global",true,[true]]
];

_signalProperties params [
    ["_frequency",100,[123]],
    ["_origin",objNull,[[],objNull],[3]],
    ["_decibels",-100,[123]],
    ["_maxDistance",worldSize,[123]]
];


if (_frequency <= 0) exitWith {
    [["Signal can't be added, must have a frequency above 0, current is: ",_frequency],true] call KISKA_fnc_log;
    ""
};

if ((_origin isEqualType objNull) AND {isNull _origin}) exitWith {
    ["Provided origin is null object",true] call KISKA_fnc_log;
    ""
};

if (_maxDistance <= 0) exitWith {
    ["Max distance must be positive number",true] call KISKA_fnc_log;
    ""
};


private _tag = ["KISKA","spectrumSignal",clientOwner] joinString "_";
private _id = [_tag] call KISKA_fnc_generateUniqueId;

[
    [
        _id,
        _frequency,
        _origin,
        _decibels,
        _maxDistance
    ],
    _global
] call KISKA_fnc_spectrum_updateSignal;


_id
