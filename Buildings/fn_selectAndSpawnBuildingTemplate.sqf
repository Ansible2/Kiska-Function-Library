/* ----------------------------------------------------------------------------
Function: KISKA_fnc_selectAndSpawnBuildingTemplate

Description:
	Takes a building and spawns a random fortification template configed in KISKA's
     library

Parameters:
	0: _building : <OBJECT> - The building to spawn a template on

Returns:
	<ARRAY> - An array with the objects spawned for the template

Examples:
    (begin example)
		[myBuilding] call KISKA_fnc_selectAndSpawnBuildingTemplate;
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_selectAndSpawnBuildingTemplate"
scriptName SCRIPT_NAME;

params [
    ["_building",objNull,[objNull]]
];

private _buildingClass = typeof _building;

private _configPath = [["KISKA_fortificationTemplates",_buildingClass]] call KISKA_fnc_findConfigAny;
if (isNull _configPath) exitWith {
    [["Did not find building templates for ",_buildingClass],true] call KISKA_fnc_log;
    []
};

private _templates = "true" configClasses _configPath;
private _templateClass = selectRandom _templates;
private _buildingTemplate = _templateClass call BIS_fnc_getCfgDataArray;

// getting rid of index with the buidling's type so can use apply command easier
private _buildingClass = _buildingTemplate deleteAt 0;
private _spawnedObjects = []; // this should be pushBack to the master array, once done, get its index in the master and attach it to a missionNamespace variable so that all the objects can be deleted after the DSO is complete

private "_object";
_buildingTemplate apply {
    _object = [_x,_building] call KISKA_fnc_createAndSetObject;
    
    _spawnedObjects pushBack _object;
};

_spawnedObjects