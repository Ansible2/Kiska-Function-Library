/* ----------------------------------------------------------------------------
Function: KISKA_fnc_randomLoadout

Description:
	Randomly assigns a loadout from the inputed array to the unit(s) provided.

Parameters:
	0: _units <OBJECT, GROUP, or ARRAY> - The unit or units you want to select the
		random loadout for. If array, accepts and array of objects.
	1: _loadoutArray <ARRAY> - An array containing each loadout array.
		Same syntax as getUnitLoadout return.

Returns:
	_unitsChanged <ARRAY> - All the units changed

Examples:
    (begin example)
		[guy,[globalLoadout1,globalLoadout2]] call KISKA_fnc_randomLoadout;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_randomLoadout";

params [
	["_units",objNull,[objNull,grpNull,[]]],
	["_loadoutArray",[],[[]]]
];

if (_units isEqualType grpNull) then {
	_units = units _units;
};

if (_units isEqualType objNull) then {
	_units = [_units];
};

private _unitsChanged = [];

_units apply {
	if (alive _x AND {!isNull _x}) then {
		_x setUnitLoadout (selectRandom _loadoutArray);
		_x pushBack _unitsChanged;
	};
};

_unitsChanged
