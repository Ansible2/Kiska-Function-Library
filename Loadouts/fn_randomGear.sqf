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
	BOOL

Examples:
    (begin example)

		[_unit] call KISKA_fnc_randomGear;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_unit",objNull,[objNull]],
	["_uniforms",[],[[]]],
	["_headgear",[],[[]]],
	["_facewear",[],[[]]],
	["_vests",[],[[]]]
];

if (isNull _unit) exitWith {false};

if (!local _unit) exitWith {false};

if (_uniforms isEqualTo [] OR {_uniforms isEqualTo []} OR {_headgear isEqualTo []} OR {_facewear isEqualTo []} OR {_vests isEqualTo []}) exitWith {
	"A gear array is empty" call BIS_fnc_error;
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


private _fn_chooseGear = {
	params ["_gearArray"];

	private "_selectedGear";

	if (_gearArray isEqualTypeParams ["",123]) then {
		_selectedGear = selectRandomWeighted _gearArray;
	} else {
		_selectedGear = selectRandom _gearArray;
	};

	_selectedGear
};


// assign stuff

// uniform
private _chosen_uniform = [_uniforms] call _fn_chooseGear;
_unit forceAddUniform _chosen_uniform;
// headgear
private _chosen_headgear = [_headgear] call _fn_chooseGear;
_unit addHeadgear _chosen_headgear;
// facewear
private _chosen_facewear = [_facewear] call _fn_chooseGear;
_unit addGoggles _chosen_facewear;
// vest
private _chosen_vest = [_vests] call _fn_chooseGear;
_unit addVest _chosen_vest;

true