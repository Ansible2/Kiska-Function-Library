/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addCrateActions

Description:
	Adds actions required for crate loading and unloading to specific crates.

	This is the "init" script, all other functions are in series with this one. So simply run it on a crate and make sure the vehicle info is defined

Parameters:

	0: _crates <ARRAY or OBJECT> - An array of objects to add actions to.

Returns:
	BOOL

Examples:
    (begin example)

		[crate1] call KISKA_fnc_addCrateActions;

		[[crate2,crate3]] call KISKA_fnc_addCrateActions;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
// prepare globals if necessary
if (isNil "DSO_vehicleTypes") then {
	call KISKA_fnc_baseVehicleInfo;
};

params [
	["_crates",objNull,[objNull,[]]]
];

// check params
if (_crates isEqualTo [] OR {_crates isEqualType objNull AND {isNull _crates}}) exitWith {
	"_crates is undefined" call BIS_fnc_error;
	false
};

if (_crates isEqualType objNull) then {
	_crates = [_crates];
};

// give actions
_crates apply {
	if (_x isEqualType objNull AND {!isNull _x}) then {
		_x addAction [
			"--Pickup Crate",
			{
				params ["_crate","_personGrabbing"];

				[_crate,_personGrabbing] call KISKA_fnc_pickUpCrate;
			},
			nil,
			10,
			true,
			true,
			"",
			"!(_originalTarget getVariable ['DSO_crateLoaded',false]) AND {!(_originalTarget getVariable ['DSO_cratePickedUp',false])}",
			4
		];

		_x addAction [
			"--Load Crate",
			{
				params ["_crate"];
				[_crate] call KISKA_fnc_loadCrate;
			},
			nil,
			10,
			true,
			true,
			"",
			"!((_target nearEntities [['air','car'],10]) isEqualTo []) AND {!(_target getVariable ['DSO_crateLoaded',false])}",
			4
		];
	};
};

true