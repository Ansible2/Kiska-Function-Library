params [
    ["_building",objNull,[objNull]]
];

private _buildingDSOVariableName = ["DSO_",(typeOf _building)] joinString "";

if (isNil _buildingDSOVariableName) exitWith { 
    hint "No templates exist for this building type";
};

private _buildingClass = typeof _building;

private _buildingTemplate = selectRandom (missionNamespace getVariable _buildingDSOVariableName);
private _buildingClass = _buildingTemplate select 0;
_buildingTemplate deleteAt 0; // getting rid of index with the buidling's type so can use apply command easier

private _spawnedObjects = []; // this should be pushBack to the master array, once done, get its index in the master and attach it to a missionNamespace variable so that all the objects can be deleted after the DSO is complete

_buildingTemplate apply {
    _object = [_x,_building] call KISKA_fnc_createAndSetObject;
    
    _spawnedObjects pushBack _object;
};

_spawnedObjects