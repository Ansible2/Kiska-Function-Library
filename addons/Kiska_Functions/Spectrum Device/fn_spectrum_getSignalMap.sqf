/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_getSignalMap

Description:
    Returns a map of all the signals and their corresponding ids that have been
	 added on the local machine. 

Parameters:
	NONE

Returns:
    <HASHMAP<STRING,ARRAY>> - A hashmap where a signal id as key will provide an
	 	array of that signals base properties:

	 	- 0. <NUMBER> : The frequency of the signal in MHz
	 	- 1. <PositionASL[]> : The position of the signal
	 	- 2. <NUMBER> : The base signal decibel level when when near the origin
	 	- 3. <NUMBER> : The max distance that the signal can be seen on the spectrum analyzer

Examples:
    (begin example)
        private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_getSignalMap";

private _signalMap = localNamespace getVariable ["KISKA_spectrum_signalMap",-1];
if (_signalMap isEqualTo -1) then {
	_signalMap = createHashMap;
	localNamespace setVariable ["KISKA_spectrum_signalMap",_signalMap];
};


_signalMap
