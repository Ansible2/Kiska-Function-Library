/* ----------------------------------------------------------------------------
Function: KISKA_fnc_assignUnitLoadout

Description:
	Searches for a global variable loadout array to assign to units based on its classname and a prefix

	See examples...

Parameters:
	0: _prefix <STRING> - The string prefix you put on the end to the units className
	1: _units <ARRAY, GROUP, or OBJECT> - The unit(s) to apply the function to

Returns:
	NOTHING

Examples:
    (begin example)

		_loadout1 = getUnitLoadout player;

		// this is an array of potential loadouts (formatted from the command 'getUnitLoadout')
		JTFS_I_E_Soldier_TL_F = [
			_loadout1
		];

		unit1 = "I_E_Soldier_TL_F" createVehicle (position player);

		["JTFS_",unit1] spawn KISKA_fnc_assignUnitLoadout

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_prefix","",[""]],
	["_units",[],[[],objNull,grpNull]]
];

// verify params
if (_units isEqualTo []) exitWith {
	["Empty array for _units"] call BIS_fnc_error;
};
if (_prefix isEqualTo "") exitWith {
	["_prefix is empty string"] call BIS_fnc_error;
};
if (_units isEqualTypeAny [objNull,grpNull] AND {isNull _units}) exitWith {
	["_units isNull"] call BIS_fnc_error;
};

// organize other data types into array
if (_units isEqualType objNull) then {
	_units = [_units];
};
if (_units isEqualType grpNull) then {
	_units = units _units;
};

// assign loadouts
_units apply {
	private _unit = _x;

	if (alive _unit AND {!isNull _unit}) then {

		// units don't like being not simmed on dedicated servers while performing this
		private _simEnabled = simulationEnabled _unit;
		if (!_simEnabled) then {
			_unit enableSimulationGlobal true;
		};

		private _loadoutVariableName = [_prefix,(typeOf _unit)] joinString "";

		if (isNil _loadoutVariableName) then {
			[[_loadoutVariableName,"isNil. No loadout assigned"] joinString " "] call BIS_fnc_error;
		} else {
			private _loadout = selectRandom (missionNamespace getVariable _loadoutVariableName);
			_unit setUnitLoadout _loadout;

			waitUntil {
				if (_loadout isEqualTo (getUnitLoadout _unit)) exitWith {true};
				_unit setUnitLoadout _loadout;
				
				sleep 0.1;

				false
			};
		};

		// return units to being unsimmed if they were before
		if (!_simEnabled) then {
			_unit enableSimulationGlobal false;
		};
	};
};