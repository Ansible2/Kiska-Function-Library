/* ----------------------------------------------------------------------------
Function: KISKA_fnc_randomGear

Description:
	Randomizes gear based upon input arrays for each slot. Designed with civillians in mind.

Parameters:
	0: _unit : <OBJECT> - The unit to randomize gear
	1: _uniforms : <ARRAY> - Potential uniforms to wear, array can be formated as random or weighted random
	2: _headgear : <ARRAY> - Potential headgear to wear, array can be formated as random or weighted random
	3: _facewear : <ARRAY> - Potential facewear to wear, array can be formated as random or weighted random
	4: _vests : <ARRAY> - Potential vests to wear, array can be formated as random or weighted random

Returns:
	<BOOL> - true if unit was given random clothes, false if error

Examples:
    (begin example)
		[_unit] call KISKA_fnc_randomGear;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_randomGear";

params [
	["_unit",objNull,[objNull]],
	["_uniforms",[],[[]]],
	["_headgear",[],[[]]],
	["_facewear",[],[[]]],
	["_vests",[],[[]]]
];

if (isNull _unit) exitWith {
	["Null unit was passed",true] call KISKA_fnc_log;
	false
};

if (!local _unit) exitWith {
	[[_unit," is not a local unit; must be executed where unit is local!"],true] call KISKA_fnc_log;
	false
};

// remove all existing stuff
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;


private _selectedGear = "";
private _gearArray = [];

private _fn_selectGear = {
	if (_gearArray isNotEqualTo []) then {
		if (_gearArray isEqualTypeParams ["",123]) then {
			_selectedGear = selectRandomWeighted _gearArray;
		} else {
			_selectedGear = selectRandom _gearArray;
		};
	} else {
		_selectedGear = "";
	};
};


// assign stuff

// uniform
_gearArray = _uniforms;
call _fn_selectGear;
if (_selectedGear isNotEqualTo "") then {
	_unit forceAddUniform _selectedGear;
};

// headgear
_gearArray = _headgear;
call _fn_selectGear;
if (_selectedGear isNotEqualTo "") then {
	_unit addHeadgear _selectedGear;
};

// facewear
_gearArray = _facewear;
call _fn_selectGear;
if (_selectedGear isNotEqualTo "") then {
	_unit addGoggles _selectedGear;
};

// vest
_gearArray = _vests;
call _fn_selectGear;
if (_selectedGear isNotEqualTo "") then {
	_unit addVest _selectedGear;
};


true