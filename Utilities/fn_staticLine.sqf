/* ----------------------------------------------------------------------------
Function: KISKA_fnc_staticLine

Description:
	Ejects units from vehicle and deploys chutes, will select CUP T10 chute if available

Parameters:

	0: _dropArray <ARRAY, GROUP, OBJECT> - Units to drop. If array, can be groups and/or objects (example 2)

Returns:
	BOOL

Examples:
    (begin example)

		[group1] call KISKA_fnc_staticLine;

    (end)

	(begin example)

		[[group1,unit2]] call KISKA_fnc_staticLine;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */


// try testing with verification of param in wrapped in spawn and used with exitWith
params [
	["_dropArray",[],[[],grpNull,objNull]]
];

if (_dropArray isEqualTo []) exitWith {
	false
};

if (_dropArray isEqualTypeAny [objNull,grpNull] AND {isNull _dropArray}) exitWith {
	["_dropArray isNull"] call BIS_fnc_error;
};

if (_dropArray isEqualType grpNull) then {
	_dropArray = units _dropArray;
};

if (_dropArray isEqualType objNull) then {
	_dropArray = [_dropArray];
};

private _dropArrayFiltered = [];

if (_dropArray isEqualType []) then {
	_dropArray apply {
		if (_x isEqualType grpNull) then {
			_dropArrayFiltered append (units _x);
		};

		if (_x isEqualType objNull) then {
			_dropArrayFiltered pushBack _x;
		};
	};
};

private _chuteType = ["CUP_T10_Parachute_backpack","Steerable_Parachute_F"] select (isNull (configfile >> "CfgVehicles" >> "CUP_T10_Parachute_backpack"));

{
	[
		{
			params [
				["_unit",objNull,[objNull]],
				["_chuteType","",[""]],
				["_index",0,[123]]
			];

			private _loadout = getUnitLoadout _unit;
			
			if !(isNull (unitbackpack _unit)) then {
				removeBackpackGlobal _unit;
			};	
			_unit addBackpackGlobal _chuteType;

			[_unit,false] remoteExec ["allowDamage",_unit];

			private _aircraft = objectParent _unit;
			
			//[_unit] remoteExec ["unassignVehicle",_unit];
			[_unit,_aircraft] remoteExec ["leaveVehicle",_unit];
			[_unit] remoteExec ["moveOut",_unit];
			
			// determine the side of the aircraft to eject on
			private _sideOfAircraft = [10,-10] select ((_index mod 2) isEqualTo 0);
			

			// delay chute open to create some distance with plane
			[
				{
					params [
						"_unit",
						"_aircraft",
						"_sideOfAircraft"
					];

					_unit setPosATL ((getPosATLVisual _unit) vectorAdd (_aircraft vectorModelToWorldVisual [_sideOfAircraft,0,0]));

					[_unit,["OpenParachute", _unit]] remoteExec ["action",_unit];
				},
				[_unit,_aircraft,_sideOfAircraft],
				1
			] call CBA_fnc_waitAndExecute;


			// wait a bit to start loop and allow damage
			[
				{
					params ["_unit","_loadout"];
					[_unit,false] remoteExec ["allowDamage",_unit];

					// waitUntil unit hits ground to give his backpack back
					[
						1,
						{
							(_this select 0) setUnitLoadout (_this select 1);
						},
						{
							((getPosATLVisual (_this select 0)) select 2) < 1
						},
						[_unit,_loadout],
						true
					] call KISKA_fnc_waitUntil;
				},
				[_unit,_loadout],
				3
			] call CBA_fnc_waitAndExecute;

		},
		[_x,_chuteType,_forEachIndex],
		_forEachIndex / 5
	] call CBA_fnc_waitAndExecute;
	
} forEach ([_dropArrayFiltered,_dropArray] select (_dropArrayFiltered isEqualTo []));

true