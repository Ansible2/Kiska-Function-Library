params [
	["_controlPanel",objNull,[objNull]],
	["_spawnPosition",objNull,[[],objNull]],
	["_vehicleTypes",[],[[],""]],
	["_onCreateCode",{},[{}]]
];

if (isNull _controlPanel) exitWith {
	"_controlPanel isNull" call BIS_fnc_error;
	false
};

if (_vehicleTypes isEqualTo [] OR {_vehicleTypes isEqualTo ""}) exitWith {
	"_vehicleTypes is empty" call BIS_fnc_error;
	false
};

if (_vehicleTypes isEqualType "") then {
	_vehicleTypes = [_vehicleTypes];
};


_vehicleTypes apply {

	private _type = _x;
	
	// check if class exists
	if (isClass (configFile >> "cfgVehicles" >> _type) OR {isClass (missionConfigFile >> "cfgVehicles" >> _type)}) then {
		
		// get displayName
		private _displayName = getText (configFile >> "cfgVehicles" >> _type >> "displayname");
		if (_displayName isEqualTo "") then {
			
			private _altText = getText (missionConfigFile >> "cfgVehicles" >> _type >> "displayname");
			if !(_altText isEqualTo "") then {
				_displayName = _altText;
			} else {
				_displayName = "Unkown Vehicle";
			};	
		};
		
		[
			_controlPanel,
			("Spawn " + _displayName),
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa", 
			{}, 
			{
				private _spawnPosition = (_this select 3) select 1;

				if !((_spawnPosition nearEntities ["landVehicle","air","ship"]) isEqualTo []) exitWith {
					hint "Pad Must Be Clear Of Vehicles";
					false
				};

				true
			}, 
			{}, 
			{}, 
			{
				(_this select 3) params [
					"_type",
					"_spawnPosition",
					"_onCreateCode"
				];

				private _vehicle = _type createVehicle _spawnPosition;

				if !(_onCreateCode isEqualTo {}) then {
					[_vehicle] call _onCreatedCode;
				};
			}, 
			{}, 
			[_type,_spawnPosition,_onCreateCode], 
			2, 
			10, 
			false, 
			false, 
			false
		] call BIS_fnc_holdActionAdd;
	};
};

[
	_controlPanel,
	"<t color='#ba1000'>Clear Spawn</t>",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa", 
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa", 
	{}, 
	{},
	{}, 
	{}, 
	{
		private _spawnPosition = (_this select 3) select 0;
		private _entities = _spawnPosition nearEntities ["landVehicle","air","ship"];

		_entities apply {
			[_x] remoteExec ["deleteVehicle",2];
		};
	}, 
	{}, 
	[_spawnPosition], 
	2, 
	20, 
	false, 
	false, 
	false
] call BIS_fnc_holdActionAdd;