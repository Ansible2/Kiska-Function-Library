/* ----------------------------------------------------------------------------
Function: KISKA_fnc_assignUnitLoadout

Description:
	Searches a config class for an array that matches the units classname.
	This array is filled with potential loadout arrays for the unit.

Parameters:
	0: _config <CONFIG> - The config to search for the array of loadouts in
	1: _units <ARRAY, GROUP, or OBJECT> - The unit(s) to apply the function to

Returns:
	NOTHING

Examples:
    (begin example)
		[
			missionConfigFile >> "KISKA_loadouts" >> ONL,
			unit1
		] spawn KISKA_fnc_assignUnitLoadout

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
params [
	["_configPath",configNull,[configNull]],
	["_units",[],[[],objNull,grpNull]]
];


// verify params
if (isNull _configPath) exitWith {
	["A null config was passed",true] call KISKA_fnc_log;
	nil
};
if (_units isEqualTo []) exitWith {
	["Empty array for _units",true] call KISKA_fnc_log;
	nil
};
if (_units isEqualTypeAny [objNull,grpNull] AND {isNull _units}) exitWith {
	["_units is null",true] call KISKA_fnc_log;
	nil
};


// organize other data types into array
if (_units isEqualType objNull) then {
	_units = [_units];
};
if (_units isEqualType grpNull) then {
	_units = units _units;
};


// assign loadouts
private _loadoutHashmap = createHashMap;
private ["_loadoutsForClass","_simEnabled","_unit","_unitClass","_loadout"];
_units apply {
	_unit = _x;

	if (alive _unit AND {!isNull _unit}) then {

		_unitClass = typeOf _unit;
		if (_unitClass in _loadoutHashmap) then {
			_loadoutsForClass = _loadoutHashmap get _unitClass;

		} else {
			_loadoutsForClass = getArray(_configPath >> _unitClass);
			_loadoutHashmap set [_unitClass,_loadoutsForClass];

		};


		if (_loadoutsForClass isEqualTo []) then {
			[["Class ", _unitClass, " does not have any configed loadouts in directory: ",_configPath],true] call KISKA_fnc_log;

		} else {
			// units don't like being not simmed on dedicated servers while changing loadouts this, so do it temporarily if needed
			_simEnabled = simulationEnabled _unit;
			if (!_simEnabled) then {
				[_unit,true] remoteExecCall ["enableSimulationGlobal",2];
			};

			_loadout = selectRandom _loadoutsForClass;
			_unit setUnitLoadout _loadout;
			// making sure changes took over network
			waitUntil {
				if (_loadout isEqualTo (getUnitLoadout _unit)) exitWith {true};
				_unit setUnitLoadout _loadout;
				sleep 0.5;
				false
			};

			// return units to being unsimmed if they were before
			if (!_simEnabled) then {
				_unit enableSimulationGlobal false;
			};
		};

	};
};


nil
