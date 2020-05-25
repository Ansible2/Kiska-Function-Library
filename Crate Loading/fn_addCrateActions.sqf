#include "baseVehicleInfo.hpp";

_crates apply {
	_x addAction [
		"--Pickup Crate",
		{
			params ["_crate","_personGrabbing"];

			[_crate,_personGrabbing] call KISKA_fnc_loadCrate;
		},
		[],
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
		[],
		10,
		true,
		true,
		"",
		"!((_target nearEntities [['air','car'],10]) isEqualTo []) AND {!(_target getVariable ['DSO_crateLoaded',false])}",
		4
	];
};