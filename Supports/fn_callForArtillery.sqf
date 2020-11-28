/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callForArtillery

Description:
	Calls for an artillery or mortar strike at a designated position and marks the spot.
	Also informs players of strike with radio message

Parameters:
	0: _target <OBJECT, ARRAY, or STRING(marker)> - The target you want to cluter fire around
	1: _ammoType <STRING> - The ammo type from cfgAmmo 
	2: _radius <NUMER> - Spread of rounds
	3: _numberOfRounds <NUMER> - The number of rounds to fire
	4: _delayBetween <NUMER> - Time between shots

Returns:
	NOTHING

Examples:
    (begin example)

		null = [target_1,"Sh_155mm_AMOS"] spawn KISKA_fnc_callForArtillery;

    (end)

Authors:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callForArtillery";

if (!canSuspend) exitWith {};
params [
	["_fireAtPosition",objNull,[[],objNull],""],
	["_ammoType","Sh_155mm_AMOS",[""]],
	["_radius",25,[123]],
	["_numberOfRounds",3,[123]],
	["_delayBetween",5,[123]]
];

// flare round need to fall slower
if (_ammoType == "Flare_82mm_AMOS_White") exitWith {
	null = [_fireAtPosition,_ammoType,15,1,1,{},nil,250,1] spawn BIS_fnc_fireSupportVirtual;
};

["artillery",player] call KISKA_fnc_supportRadioGlobal;

// create markers
private _chemlight = createvehicle ["Chemlight_green_infinite",_fireAtPosition,[],0,"NONE"];
private _smoke = createvehicle ["G_40mm_SmokeRed_infinite",_fireAtPosition,[],0,"NONE"];
//private _flare = createvehicle ["F_40mm_Red",_fireAtPosition,[],0,"NONE"];

sleep 5;

null = [_fireAtPosition,_ammoType,_radius,_numberOfRounds,_delayBetween,{},nil,1300] spawn BIS_fnc_fireSupportVirtual;

sleep 20;
deleteVehicle _chemlight;
deleteVehicle _smoke;
//deleteVehicle _flare;