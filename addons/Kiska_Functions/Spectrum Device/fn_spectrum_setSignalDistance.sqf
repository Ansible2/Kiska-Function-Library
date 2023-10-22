/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setSignalDistance

Description:
    Sets the signal's distance that it can be heard from.

	NOTE: If you intend to update more than one property of a signal, use
	 `KISKA_fnc_spectrum_updateSignal` as it is more efficient.

Parameters:
    0: _id : <STRING> - The id of the signal to update
    1: _maxDistance : <NUMBER> - The maximum distance the signal can be seen on the analyzer
    2: _global : <BOOL> - `true` to broadcast the change to all machines including JIP (default: `true`)

Returns:
	<HASHMAP> - Signal's updated property map:

    - `_frequency`: <NUMBER> - The frequency of the signal in MHz
    - `_origin`: <PositionASL[]> - The position of the signal
    - `_maxDistance`: <NUMBER> - The maximum distance the signal can be seen on the analyzer
    - `_decibels`: <NUMBER> - The max decibel level when the analyzer is directly on top of the origin

Examples:
    (begin example)
        ["KISKA_spectrumSignal_2_1",1000] call KISKA_fnc_spectrum_setSignalDistance;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setSignalDistance";

#define ORIGIN_KEY "_origin"
#define FREQUENCY_KEY "_frequency"
#define DECIBEL_KEY "_decibels"

params [
	["_id","",[""]],
    ["_maxDistance",1000,[123]],
    ["_global",true,[true]]
];

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
		_signalPropertiesMap get ORIGIN_KEY,
		_signalPropertiesMap get DECIBEL_KEY,
		_maxDistance
	],
	_global
] call KISKA_fnc_spectrum_updateSignal;
