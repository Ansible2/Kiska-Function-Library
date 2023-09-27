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

private _currentSelectionMin = missionNamespace getVariable ["#EM_SelMin", 100];
missionNamespace setVariable ["#EM_SelMax", _currentSelectionMin + _width];
