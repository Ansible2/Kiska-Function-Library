/* ----------------------------------------------------------------------------
Function: KISKA_fnc_randomGear

Description:
    Randomizes gear based upon input arrays for each slot. Be aware that this function
     is very slow (can take >1ms) and should be used ideally on initialization for large
     numbers of units. 

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


private _primaryWeaponGearSelector = [
	_primaryWeapons, 
	{ 
		_selectedGear params [
			"_weapon",
			["_weaponItems",[]]
		];
		_unit addWeapon _weapon;
		_weaponItems apply { _unit addPrimaryWeaponItem _x };
	},
	[]
];

private _handgunGearSelector = [
	_handguns, 
	{ 
		_selectedGear params [
			"_weapon",
			["_weaponItems",[]]
		];
		_unit addWeapon _weapon;
		_weaponItems apply { _unit addHandgunItem _x };
	},
	[]
];

private _secondaryWeaponGearSelector = [
	_secondaryWeapons, 
	{ 
		_selectedGear params [
			"_weapon",
			["_weaponItems",[]]
		];
		_unit addWeapon _weapon;
		_weaponItems apply { _unit addSecondaryWeaponItem _x };
	},
	[]
];

[
	[_uniforms, { _unit forceAddUniform _selectedGear }],
	[_headgear, { _unit addHeadgear _selectedGear; }],
	[_facewear, { _unit addGoggles _selectedGear; }],
	[_vests, { _unit addVest _selectedGear; }],
	[_backpacks, { _unit addBackpack _selectedGear; }],
	_primaryWeaponGearSelector,
	_handgunGearSelector,
	_secondaryWeaponGearSelector
] apply {
	_x params [
		"_availableGear",
		"_fn_addGear",
		["_valueType",""]
	];

	if (_availableGear isEqualTo []) then { continue };
	
	private _selectedGear = [_availableGear,_valueType] call KISKA_fnc_selectRandom;
	[_unit,_selectedGear] call _fn_addGear;
};

nil
