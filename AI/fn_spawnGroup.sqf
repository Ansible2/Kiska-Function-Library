/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spawnGroup

Description:
	Spawns a group, adds to curator, and sets to aware. Based on selected unit types

Parameters:

	0: _numberOfUnits <NUMBER> - Number of units to spawn
	1: _unitTypes <ARRAY> - Unit types to select randomly from (can be weighted array)
	2: _side <SIDE> - ...
	3. _position <ARRAY, OBJECT, GROUP> - Position to spawn on
	4. _enableDynamicSimulation <BOOL> - ... (optional)

Returns:
	_spawnedGroup <GROUP> 

Examples:
    (begin example)

		_spawnedGroup = [4, _listOfUnitTypes, OPFOR, [0,0,0], true] call KISKA_fnc_spawnGroup;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spawnGroup";

params [
	["_numberOfUnits",1,[1]],
	["_unitTypes",["O_Soldier_F"],[[]]],
	["_side",OPFOR,[sideUnknown]],
	["_position",[0,0,0],[objNull,grpNull,[]]],
	["_enableDynamicSimulation",true,[true]]
];

// Verify params
if (_numberOfUnits < 1) exitWith {
	["Less then one unit to spawn"] call BIS_fnc_error;
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

if (_unitTypesFiltered isEqualTo []) exitWith {
	["No valid unitTypes passed"] call BIS_fnc_error;
};


// create units
private _group = createGroup [_side,true];

for "_i" from 1 to _numberOfUnits do {

	private "_selectedUnitType";
	if (_weightedArray) then {
		_selectedUnitType = selectRandomWeighted _unitTypesFiltered;
	} else {
		_selectedUnitType = selectRandom _unitTypesFiltered;
	};

	private _unit = _group createUnit [_selectedUnitType,_position,[],5,"NONE"];

	[_unit] joinSilent _group;
	
	_unit triggerDynamicSimulation false;

	if (_i isEqualTo 1) then {_unit setUnitRank "LIEUTENANT"};
	if (_i isEqualTo 2) then {_unit setUnitRank "SERGEANT"};
};

_group setBehaviour "AWARE";
_group setCombatMode "RED";

allCurators apply {
	_x addCuratorEditableObjects [units _group,false]; // look into adding in something to check if the object is a vehicle and adjust this accordingly in the future
};

if (_enableDynamicSimulation) then {
	_group enableDynamicSimulation true;
};

_group