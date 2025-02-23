/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spawn

Description:
    Randomly spawns units on an array of positions.

    PositionATL is expected and arrays can have 4 indexes with a direction for the
     unit to face being the 4th. If no direction is specified, a random one is chosen.
     Using an object instead of a position will result in the unit facing the same way
     that the object is.

    This is destructive on the _spawnPositions array so be sure to copy (+_spawnPositions)
     if you need to reuse the array.

Parameters:
    0: _numberOfUnits <NUMBER> - Number of units to spawn, if -1, all provided positions
        will be filled
    1: _numberOfUnitsPerGroup <NUMBER> - Number of units per group
    2: _unitTypes <ARRAY> - Unit types to select randomly from (can be weighted or unweighted array)
    3: _spawnPositions <ARRAY> - List of positions at which units will randomly spawn, the array can be positions and/or objects.
        If given an empty array, all units will spawn at [0,0,0]

    4: _canUnitsMove <BOOL> - Can units walk (optional)
    5: _enableDynamic <BOOL> - Should the units be dynamically simmed (Optional)
    6: _side <SIDE> - Side of units (optional)
    7: _allowedStances <STRING[] or (STRING,NUMBER)[]> - A weighted or unweighted array of setUnitPos compatible 
     values that the units will be randomly set to (`["up",0.7,"middle",0.3]` by default) (optional)

Returns:
    <OBJECT[]> - All units spawned by the function

Examples:
    (begin example)
        _spawnedUnits = [2, 2, _arrayOfTypes, [[0,0,0],spawnObject]] call KISKA_fnc_spawn;
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
    ["_side",OPFOR,[sideUnknown]],
    ["_allowedStances",["up",0.7,"middle",0.3],[[]]]
];

// Verify Params
// Is there at least on position to spawn on
if (count _spawnPositions < 1) then {
    for "_i" from 1 to _numberOfUnits do {
        _spawnPositions pushBack [0,0,0];
    };
};


if (_numberOfUnits < 0) then {
    _numberOfUnits = count _spawnPositions;
};

if (_numberOfUnitsPerGroup < 0) then {
    _numberOfUnitsPerGroup = _numberOfUnits;
};

// Check atleast one unit to spawn
if (_numberOfUnits < 1) exitWith {
    [["_numberOfUnits is ",_numberOfUnits," needs to be atleast 1. Exiting..."],true] call KISKA_fnc_log;
    []
};

if (_allowedStances isEqualTo []) exitWith {
    [["_allowedStances is empty!"],true] call KISKA_fnc_log;
    []
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
    []
};



// create units
private _spawnedUnits = [];

private _numberOfGroups = ceil (_numberOfUnits/_numberOfUnitsPerGroup);

private [
    "_group",
    "_unit",
    "_selectedSpawnPosition",
    "_selectedUnitType",
    "_faceDirection",
    "_watchPosition"
];

for "_i1" from 1 to _numberOfGroups do {
    // create group
    _group = createGroup [_side,true];
    _group setCombatMode "RED";

    // create units for group
    for "_i2" from 1 to _numberOfUnitsPerGroup do {
        // check if number of units requested have been created
        if ((count _spawnedUnits) isEqualTo _numberOfUnits) then {break};

        _selectedSpawnPosition = [_spawnPositions] call KISKA_fnc_deleteRandomIndex;

        // get unit type
        _selectedUnitType = [_unitTypesFiltered,""] call KISKA_fnc_selectRandom;

        // if spawn position includes a rotation param, set it
        if (_selectedSpawnPosition isEqualType objNull) then {
            _faceDirection = getDir _selectedSpawnPosition;

        } else {
            if (count _selectedSpawnPosition isEqualTo 4) then {
                _faceDirection = _selectedSpawnPosition deleteAt 3;

            } else {
                _faceDirection = floor (random 360);

            };

        };
        _watchPosition = _selectedSpawnPosition getPos [50,_faceDirection];

        // create unit and make sure it was made
        _unit = _group createUnit [_selectedUnitType,_selectedSpawnPosition,[],0,"Can_Collide"];
        // units with different default sides then what was selected will not be set to the selected side without this command
        [_unit] joinSilent _group;

        doStop _unit;

        _unit setDir _faceDirection;
        _unit doWatch _watchPosition;

        _unit setUnitPos ([_allowedStances,""] call KISKA_fnc_selectRandom);
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

    // ensuring units are moved into their spawn position before
    // enabling dynamic sin to avoid this bug
    // https://feedback.bistudio.com/T177900
    if (_enableDynamic) then {
        _group enableDynamicSimulation true;
    };
};

// add to zeus
allCurators apply {
    [_x,[_spawnedUnits,false]] remoteExec ["addCuratorEditableObjects",2];
};

[["Spawned ",(count _spawnedUnits)],false] call KISKA_fnc_log;


_spawnedUnits
