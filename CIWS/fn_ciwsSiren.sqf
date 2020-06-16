/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ciwsSiren

Description:
	Sounds a siren for the CIWS

Parameters:
	0: _turret : <OBJECT> - The CIWS turret

Returns:
	Nothing

Examples:
    (begin example)

		null = [turret1] spawn KISKA_fnc_ciwsSiren;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params ["_turret"];

waitUntil {
	["KISKA_Siren",_turret,1000,2] call KISKA_fnc_playSound3d;
	sleep 8;
	if (_turret getVariable "KISKA_CIWS_allClear") exitWith {true};
	false
};