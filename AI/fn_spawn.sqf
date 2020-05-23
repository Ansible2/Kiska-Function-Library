/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spawn

Description:
	Randomly spawns units on an array of positions.

Parameters:

	0: _numberOfUnits <NUMBER> - Number of units to spawn
	1: _numberOfUnitsPerGroup <NUMBER> - Number of units per group
	2: _unitTypes <ARRAY> - Unit types to select randomly from (can be weighted or unweighted array)
	3. _spawnPositions <ARRAY> - List of positions at which units will randomly spawn, the array can be positions and/or objects
	
	4. _canUnitsMove <BOOL> - Can units walk (optional)
	5. _enableDynamic <BOOL> - Should the units be dynamically simmed (Optional)
	6. _side <SIDE> - Side of units (optional)
	7. _debug <BOOL> - Do you want a debug indications of when and the number of units spawned (optional)

Returns:
	_spawnedUnits <ARRAY> 

Examples:
    (begin example)

		_spawnedUnits = [2, 2, _arrayOfTypes, [[0,0,0],spawnLogic]] call KISKA_fnc_spawn;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spawn";

params [
	["_numberOfUnits",1,[1]],
	["_numberOfUnitsPerGroup",1,[1]],
	["_unitTypes",["O_Soldier_F"],[[]]],
	["_spawnPositions",[],[[]]],

	["_canUnitsMove",false,[true]],
	["_enableDynamic",true,[true]],
	["_side",OPFOR,[sideUnknown]],
	["_debug",false,[true]]									
];

// Verify Params

// Check atleast one unit to spawn
if (_numberOfUnits < 1) exitWith {
	"Less than 1 unit to spawn" call BIS_fnc_error;
};

// Is there at least on position to spawn on
if (count _spawnPositions < 1) exitwith {
	if (_debug) then {
		["No spawnpoints found"] remoteExecCall ["systemChat", [0,-2] select isDedicated];
	};

	"Less then 1 spawn position" call BIS_fnc_error;
};

// Re adjust number of units if there are not enough spawn points
if (count _spawnPositions < _numberOfUnits) then {
	if (_debug) then {
		["Not enough spawn points, will spawn max number"] remoteExecCall ["systemChat", [0,-2] select isDedicated];
	};

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
			["Unit type %1 is invalid",_x] call BIS_fnc_error;
		};
	};
} forEach _unitTypes;

// exit if no valid types
if (_unitTypesFiltered isEqualTo []) exitWith {
	"No valid unit types passed" call BIS_fnc_error;
};



// create units
private _spawnedUnits = [];

private _numberOfGroups = ceil (_numberOfUnits/_numberOfUnitsPerGroup);

for "_i1" from 1 to _numberOfGroups do {
	// create group
	private _group = createGroup [_side,true];
	_group setCombatMode "RED";
	if (_enableDynamic) then {
		_group enableDynamicSimulation true;
	};

	// create units for group
	for "_i2" from 1 to _numberOfUnitsPerGroup do {
		// check if number of units requested have been created
		if ((count _spawnedUnits) isEqualTo _numberOfUnits) exitWith {};

		// get spawn position
		private _selectedSpawnPosition = selectRandom _spawnPositions;
		_spawnPositions deleteAt (_spawnPositions findIf {_x isEqualTo _selectedSpawnPosition});

		// get unit type
		private "_selectedUnitType";
		if (_weightedArray) then {
			_selectedUnitType = selectRandomWeighted _unitTypesFiltered;
		} else {
			_selectedUnitType = selectRandom _unitTypesFiltered;
		};

		// create unit and make sure it was made
		private _unit = _group createUnit [_selectedUnitType,_selectedSpawnPosition,[],0,"Can_Collide"];

		// units with different default sides then what was selected will not be set to the selected side without this command
		[_unit] joinSilent _group;

		// if spawn position is object, set the rotation of the unit to that of the object
		if (_selectedSpawnPosition isEqualType objNull) then {
			_unit setDir (getDir _selectedSpawnPosition)
		} else {
			_unit setDir (floor (random 360));
		};

		// set a random stance and stop unit in place
		_unit setUnitPos (selectRandomWeighted ["up",0.7,"middle",0.3]);
		doStop _unit;
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
	_x addCuratorEditableObjects [_spawnedUnits,false];
};

if (_debug) then {
	[["Enemies spawned:",str (count _spawnedUnits)] joinString " "] remoteExecCall ["systemChat", allPlayers];
};

_spawnedUnits