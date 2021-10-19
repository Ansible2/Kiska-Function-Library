/* ----------------------------------------------------------------------------
Function: KISKA_fnc_vehicleFactory

Description:
	Add an action to given object that allows the spawn of a vehicle

Parameters:
	0: _controlPanel <OBJECT> - The object to add the action to
	1: _spawnPosition <OBJECT or ARRAY> - Where to spawn the vehicle (ASL)
	2: _vehicleTypes <ARRAY or STRING> - The class names of vehicles to create an action for (each will get its own action if in an array)
	3: _clearRadius <NUMBER> - How far until pad is considered clear of entities
	4: _onCreateCode <CODE> - Code to run upon vehicle creation. Passed arg is the created vehicle

Returns:
	<BOOL> - false if not added, true otherwise

Examples:
	(begin example)
		[player,(getPosATL player) vectorAdd [2,2,0],"B_MRAP_01_F"] spawn KISKA_fnc_vehicleFactory;
	(end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_vehicleFactory";

if (!canSuspend) exitWith {
	["Must be run in scheduled envrionment, exiting to scheduled"] call KISKA_fnc_log;
	_this spawn KISKA_fnc_vehicleFactory;
};

params [
	["_controlPanel",objNull,[objNull]],
	["_spawnPosition",objNull,[[],objNull]],
	["_vehicleTypes",[],[[],""]],
	["_clearRadius",10,[123]],
	["_onCreateCode",{},[{}]]
];

if (isNull _controlPanel) exitWith {
	["_controlPanel isNull",true] call KISKA_fnc_log;
	false
};

if (_vehicleTypes isEqualTo [] OR {_vehicleTypes isEqualTo ""}) exitWith {
	["_vehicleTypes is empty",true] call KISKA_fnc_log;
	false
};

if (_vehicleTypes isEqualType "") then {
	_vehicleTypes = [_vehicleTypes];
};

if (_spawnPosition isEqualType objNull) then {
	_spawnPosition = getPosASL _spawnPosition;
};


private ["_type","_config","_displayName"];
_vehicleTypes apply {

	_type = _x;
	_config = configFile >> "cfgVehicles" >> _type;

	if (isClass _config) then {

		// get displayName
		_displayName = getText (_config >> "displayname");
		if (_displayName isEqualTo "") then {

			_displayName = getText (missionConfigFile >> "cfgVehicles" >> _type >> "displayname");
			if (_displayName isEqualTo "") then {
				_displayName = "Unknown Vehicle";
			};
		};

		[
			_controlPanel,
			("Spawn " + _displayName),
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",
			"true",
			"true",
			{},
			{},
			{
				(_this select 3) params [
					"_type",
					"_spawnPosition",
					"_clearRadius",
					"_onCreateCode"
				];

				if !(((ASLToAGL _spawnPosition) nearEntities [['landVehicle','air','ship'],_clearRadius]) isEqualTo []) exitWith {
					hint 'Pad Must Be Clear Of Vehicles';
					false
				};

				private _vehicle = createVehicle [_type,ASLToATL _spawnPosition,[],0,"CAN_COLLIDE"];

				if !(_onCreateCode isEqualTo {}) then {
					[_vehicle] call _onCreateCode;
				};

				hint "Vehicle Created";
			},
			{},
			[_type,_spawnPosition,_clearRadius,_onCreateCode],
			0.5,
			10,
			false,
			false,
			false
		] call BIS_fnc_holdActionAdd;
	};

	// hold action conditions seem to fail if added too quickly
	sleep 0.1;
};


if !(_controlPanel getVariable ["KISKA_vehicleFactory",false]) then {

	[
		_controlPanel,
		"<t color='#ba1000'>Clear Spawn</t>",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",
		"true",
		"true",
		{},
		{},
		{
			(_this select 3) params ["_spawnPosition","_clearRadius"];
			private _entities = (ASLToAGL _spawnPosition) nearEntities [['landVehicle','air','ship'],_clearRadius];

			_entities apply {
				[_x] remoteExecCall ["deleteVehicle",2];
			};

			hint "Pad Cleared";
		},
		{},
		[_spawnPosition,_clearRadius],
		0.5,
		20,
		false,
		false,
		false
	] call BIS_fnc_holdActionAdd;

	_controlPanel setVariable ["KISKA_vehicleFactory",true];
};


true
