/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setSignalPosition

Description:
    Sets the signal's origin position.

	NOTE: If you intend to update more than one property of a signal, use
	 `KISKA_fnc_spectrum_updateSignal` as it is more efficient.

Parameters:
    0: _id : <STRING> - The id of the signal to update
    1: _origin : <OBJECT or PositionASL[]> - The position of the signal
    2: _global : <BOOL> - `true` to broadcast the change to all machines including JIP (default: `true`)

Returns:
	<HASHMAP> - Signal's updated property map:

    - `_frequency`: <NUMBER> - The frequency of the signal in MHz
    - `_origin`: <PositionASL[]> - The position of the signal
    - `_maxDistance`: <NUMBER> - The maximum distance the signal can be seen on the analyzer
    - `_decibels`: <NUMBER> - The max decibel level when the analyzer is directly on top of the origin

Examples:
    (begin example)
        ["KISKA_spectrumSignal_2_1",myOrigin] call KISKA_fnc_spectrum_setSignalPosition;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setSignalPosition";

#define FREQUENCY_KEY "_frequency"
#define ORIGIN_KEY "_origin"
#define DECIBEL_KEY "_decibels"
#define DISTANCE_KEY "_maxDistance"

params [
	["_id","",[""]],
    ["_origin",objNull,[[],objNull],[3]],
    ["_global",true,[true]]
];


private _originIsObject = _origin isEqualType objNull;
if (_originIsObject AND {isNull _origin}) exitWith {
    [["Provided origin is null object; attempting to update signal: ",_id],true] call KISKA_fnc_log;
    nil
};


private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
private _signalPropertiesMap = _signalMap getOrDefaultCall [(toLowerANSI _id),{-1}];

if (_signalPropertiesMap isEqualTo -1) exitWith {
    [["Can't find signal to update with id: ",_id],true] call KISKA_fnc_log;
	nil
};


[
	[
		_id,
		_signalPropertiesMap get FREQUENCY_KEY,
		_origin,
		_signalPropertiesMap get DECIBEL_KEY,
		_signalPropertiesMap get DISTANCE_KEY
	],
	_global
] call KISKA_fnc_spectrum_updateSignal;
