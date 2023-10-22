/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_setSelectionWidth

Description:
    Sets the selection area of the local machine's spectrum device. This is the
	 bar that a user can "scroll" around the spectrum with.

Parameters:
    0: _width : <NUMBER> - The width of the bar in MHz

Returns:
    NOTHING

Examples:
    (begin example)
		// bar is 2 MHz wide
        [2] call KISKA_fnc_spectrum_setSelectionWidth;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_setSelectionWidth";

params [
	["_width",2,[123]]
];


if !(call KISKA_fnc_spectrum_isInitialized) then {
    localNamespace setVariable ["KISKA_spectrum_staged_selectionWidth",_width];
};

private _currentSelectionMin = missionNamespace getVariable ["#EM_SelMin", ""];

// selection adjusments do not stick if set outside of the frequency AND the spectrum device ui is NOT open
private _minFrequency = call KISKA_fnc_spectrum_getMinFrequency;
if ((_currentSelectionMin isEqualTo "") OR {_currentSelectionMin < _minFrequency}) then {
    missionNamespace setVariable ["#EM_SelMin",_minFrequency];
    _currentSelectionMin = _minFrequency;
};

missionNamespace setVariable ["#EM_SelMax", _currentSelectionMin + _width];
