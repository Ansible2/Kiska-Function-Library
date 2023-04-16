/* ----------------------------------------------------------------------------
Function: KISKA_fnc_randomGear

Description:
    Randomizes gear based upon input arrays for each slot. 

    The unit must be local to the machine where this function is executed.

    All gear arrays can be weighted or unweighted arrays.

Parameters:
    0: _unit : <OBJECT> - The unit to randomize gear
    1: _uniforms : <string[]> - Potential uniforms to wear
    2: _headgear : <string[]> - Potential headgear to wear
    3: _facewear : <string[]> - Potential facewear (goggles) to wear
    4: _vests : <string[]> - Potential vests to wear
    5: _backpacks : <string[]> - Potential backpacks to wear
    6: _primaryWeapons : <[string,string[]][]> - Primary weapons and items to add to them (see example)
    7: _handguns : <[string,string[]][]> - Handgun weapons and items to add to them
    8: _secondaryWeapons : <[string,string[]][]> - Secondary (launcher) weapons and items to add to them

Returns:
    NOTHING

Examples:
    (begin example)
        private _uniforms = ["U_B_CombatUniform_mcam_vest"];
        private _headgear = [];
        private _facewear = [];
        private _vests = [];
        private _backpacks = [];
        private _primaryWeapons = [
            // add a mag an optic to rifle
            ["arifle_MXC_F",["optic_Aco","30Rnd_65x39_caseless_mag"]]
        ];

        [
            _unit,
            _uniforms,
            _headgear,
            _facewear,
            _vests,
            _backpacks,
            _primaryWeapons
        ] call KISKA_fnc_randomGear;
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
    ["_vests",[],[[]]],
    ["_backpacks",[],[[]]],
    ["_primaryWeapons",[],[[]]],
    ["_handguns",[],[[]]],
    ["_secondaryWeapons",[],[[]]]
];

if (isNull _unit) exitWith {
    ["Null unit was passed",true] call KISKA_fnc_log;
    nil
};

if (!local _unit) exitWith {
    [[_unit," is not a local unit; must be executed where unit is local!"],true] call KISKA_fnc_log;
    nil
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
        _selectedGear = [_gearArray,""] call KISKA_fnc_selectRandom;
    } else {
        _selectedGear = "";
    };
};
private _fn_selectWeaponGear = {
    if (_gearArray isNotEqualTo []) then {
        _selectedGear = [_gearArray,[]] call KISKA_fnc_selectRandom;
    } else {
        _selectedGear = [];
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

// backpacks
_gearArray = _backpacks;
call _fn_selectGear;
if (_selectedGear isNotEqualTo "") then {
    _unit addBackpack _selectedGear;
};

// weapons
_gearArray = _primaryWeapons;
call _fn_selectWeaponGear;
if (_selectedGear isNotEqualTo []) then {
    _selectedGear params [
        "_weapon",
        ["_weaponItems",[]]
    ];
    _unit addWeapon _weapon;
    _weaponItems apply { _unit addPrimaryWeaponItem _x };
};

_gearArray = _secondaryWeapons;
call _fn_selectWeaponGear;
if (_selectedGear isNotEqualTo []) then {
        _selectedGear params [
        "_weapon",
        ["_weaponItems",[]]
    ];
    _unit addWeapon _weapon;
    _weaponItems apply { _unit addHandgunItem _x };
};


nil
