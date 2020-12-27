/* ----------------------------------------------------------------------------
Function: KISKA_fnc_exportBuildingTemplate

Description:
	Checks if an array index satisfies the provided code, and returns a BOOL
	 for whether or not one was found.

Parameters:
	0: _building : <ARRAY> - The building to search around
	1: _objectCaptureRadius : <NUMBER> - The radius to search for objects,
        use -1 to use the buildings boundingbox
	2: _copyToClipboard : <BOOL> - Copy the template to clipboard

Returns:
	<ARRAY> - The formatted array to be placed in a config and used with
                KISKA_fnc_selectAndSpawnBuildingTemplate

Examples:
    (begin example)
		_template = [myBuilding] call KISKA_fnc_exportBuildingTemplate;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_exportBuildingTemplate"
scriptName SCRIPT_NAME;

params [
    ["_building",objNull,[objNull]],
    ["_objectCaptureRadius",-1,[123]],
    ["_copyToClipboard",false,[true]]
];

if (isNull _building) exitWith {
    [SCRIPT_NAME,"_building isNull",false,true] call KISKA_fnc_log;
};

if (_objectCaptureRadius <= 0) then {
    _objectCaptureRadius = ((0 boundingBoxReal _building) select 2);
};

private _terrainObjects = nearestTerrainObjects [_building,["object"],_objectCaptureRadius];

private _capturedObjects = (_building nearObjects _objectCaptureRadius) select {
    !(_x in _terrainObjects) AND 
    {!(_x isEqualTo _building)} AND
    {(_x isKindOf "static") OR {_x isKindOf "staticWeapon"} OR {_x isKindOf "thing"}}
};

private _offsetDump = [_capturedObjects,_building] call KISKA_fnc_getObjectProperties;
if (_copyToClipboard) then {
    copyToClipboard str _offsetDump;
};

_offsetDump