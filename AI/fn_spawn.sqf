/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spawn

Description:
	Randomly spawns units on an array of positions.

Parameters:
	0: _numberOfUnits <NUMBER> - Number of units to spawn
	1: _numberOfUnitsPerGroup <NUMBER> - Number of units per group
	2: _unitTypes <ARRAY> - Unit types to select randomly from (can be weighted or unweighted array)
	3. _spawnPositions <ARRAY> - List of positions at which units will randomly spawn, the array can be positions and/or objects.
		If given an empty array, all units will spawn at [0,0,0]

	4. _canUnitsMove <BOOL> - Can units walk (optional)
	5. _enableDynamic <BOOL> - Should the units be dynamically simmed (Optional)
	6. _side <SIDE> - Side of units (optional)

Returns:
	<ARRAY> - All units spawned by the function

Examples:
    (begin example)
		_spawnedUnits = [2, 2, _arrayOfTypes, [[0,0,0],spawnLogic]] call KISKA_fnc_spawn;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spawn";

params [
	["_numberOfUnits",1,[1]],
	["_numberOfUnitsPerGroup",1,[1]],
	["_unitTypes",["O_Soldier_F"],[[]]],
	["_spawnPositions",[],[[]]],

	["_canUnitsMove",false,[true]],
	["_enableDynamic",true,[true]],
	["_side",OPFOR,[sideUnknown]]
];

// Verify Params

// Check atleast one unit to spawn
if (_numberOfUnits < 1) exitWith {
	[["_numberOfUnits is ",_numberOfUnits," needs to be atleast 1. Exiting..."],true] call KISKA_fnc_log;
	[]
};

// Is there at least on position to spawn on
if (count _spawnPositions < 1) then {
	for "_i" from 1 to _numberOfUnits do {
		_spawnPositions pushBack [0,0,0];
	};
};

// Re adjust number of units if there are not enough spawn points
if (count _spawnPositions < _numberOfUnits) then {
	[["Count of _spawnPositions is ",_spawnPositions," and _numberOfUnits is ",_numberOfUnits," ReAdjusting _numberOfUnits to _spawnPositions"]] call KISKA_fnc_log;

	_numberOfUnits = count _spawnPositions;
};


// filter out bad unit types
private _unitTypesFiltered = [];
private _weightedArray = _unitTypes isEqualTypeParams ["",1];
{
	if (_x isEqualType "") then {
		if (isClass (configFile >> "cfgVehicles" >> _x) OR {isClass (missionConfigFile >> "cfgVehicles" >> _x)}) then {
			_unitTypesFiltered pushBack _x;

			if (_weightedArray) then {
				_unitTypesFiltered pushBack (_unitTypes select (_forEachIndex + 1));
			};
		} else {
			[["Found invalid class ",_x]] call KISKA_fnc_log;
		};
	};
} forEach _unitTypes;

// exit if no valid types
if (_unitTypesFiltered isEqualTo []) exitWith {
	[["Did not find any valid unit types in ",_unitTypes],true] call KISKA_fnc_log;
};



// create units
private _spawnedUnits = [];

private _numberOfGroups = ceil (_numberOfUnits/_numberOfUnitsPerGroup);

private [
	"_group",
	"_unit",
	"_selectedSpawnPosition",
	"_selectedUnitType"
];

for "_i1" from 1 to _numberOfGroups do {
	// create group
	_group = createGroup [_side,true];
	_group setCombatMode "RED";
	if (_enableDynamic) then {
		_group enableDynamicSimulation true;
	};

	// create units for group
	for "_i2" from 1 to _numberOfUnitsPerGroup do {
		// check if number of units requested have been created
		if ((count _spawnedUnits) isEqualTo _numberOfUnits) exitWith {};

		// get spawn position
		_selectedSpawnPosition = selectRandom _spawnPositions;
		_spawnPositions deleteAt (_spawnPositions findIf {_x isEqualTo _selectedSpawnPosition});

		// get unit type
		if (_weightedArray) then {
			_selectedUnitType = selectRandomWeighted _unitTypesFiltered;
		} else {
			_selectedUnitType = selectRandom _unitTypesFiltered;
		};

		// create unit and make sure it was made
		_unit = _group createUnit [_selectedUnitType,_selectedSpawnPosition,[],0,"Can_Collide"];

		// units with different default sides then what was selected will not be set to the selected side without this command
		[_unit] joinSilent _group;

		doStop _unit;

		// if spawn position is object, set the rotation of the unit to that of the object else random
		if (_selectedSpawnPosition isEqualType objNull) then {
			_unit setDir (getDir _selectedSpawnPosition);
			_unit doWatch (_selectedSpawnPosition getRelPos [50,0]);
		} else {
			private _randomDir = floor (random 360);
			_unit setDir _randomDir;
			_unit doWatch (_unit getRelPos [50,_randomDir]);
		};

		// set a random stance and stop unit in place
		_unit setUnitPos (selectRandomWeighted ["up",0.7,"middle",0.3]);
		if !(_canUnitsMove) then {
			_unit disableAI "path";
		};

		// make sure units don't trigger dynamic sim
		if (_enableDynamic) then {
			_unit triggerDynamicSimulation false;
		};

		// put unit in master array
		if (!isNull _unit) then {
			_spawnedUnits pushBack _unit;
		};
	};
};

// add to zeus
allCurators apply {
	[_x,[_spawnedUnits,false]] remoteExec ["addCuratorEditableObjects",2];
};

[["Spawned ",(count _spawnedUnits)],false] call KISKA_fnc_log;


_spawnedUnits
