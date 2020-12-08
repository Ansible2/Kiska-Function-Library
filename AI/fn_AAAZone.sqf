/* ----------------------------------------------------------------------------
Function: KISKA_fnc_AAAZone

Description:
	Sets up a zone that when entered by an enemy aircraft, the provided vehicle will engage.

	Otherwise, vehicle will stay the same.

Parameters:
	0: _vehicle : <OBJECT> - The AAA piece

Returns:
	BOOL

Examples:
    (begin example)
		null = [myVehicle] spawn KISKA_fnc_AAAZone;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_AAAZone";

params [
	["_vehicle",objNull,[objNull]],
	["_radius"]
];

if (isNull _vehicle) exitWith {
	"KISKA_fnc_AAAZone: _vehicle isNull" call BIS_fnc_error;
};

private _gunner = gunner _vehicle;
if (isNull _gunner) exitWith {
	"KISKA_fnc_AAAZone: _vehicle does not have a gunner" call BIS_fnc_error;
};
// stop gunner from engaging targets
_gunner disableAI "WEAPONAIM";

private _AAAside = side _vheicle;
private _doFire = false;
private "_entitiesInRadius";

_vehicle setVariable ["KISKA_doAAA",true];
while {_vehicle getVariable "KISKA_doAAA"} do {
	_entitiesInRadius = nearEntities ["air",_radius];

	// if any air units are found
	if (_entitiesInRadius isEqualTo []) then {
		private _index = _entitiesInRadius findIf {
			[side _x,_AAAside] call BIS_fnc_sideIsEnemy;
		};

		// if an enemy aircraft is found AND _vehicle is not already engaging
		if (_index != -1 AND {!_doFire}) then {
			_doFire = true;
			_gunner enableAI "WEAPONAIM";
		} else {
			_doFire = false;
			_gunner disableAI "WEAPONAIM";
		};
	} else {
		if (_doFire) then {
			_doFire = false;
		};
	};

	// if vehicle is dead or gunner is absent
	if (!alive _vehicle OR {!alive _gunner}) exitWith {
		_vehicle setVariable ["KISKA_doAAA",nil];
	};
};