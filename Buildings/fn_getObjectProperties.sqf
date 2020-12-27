/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getObjectProperties

Description:
    Used in KISKA_fnc_exportBuildingTemplate to get the information to save
     about each object.
	
Parameters:
	0: _objects : <ARRAY> - The objects to check save info on
    1: _building : <OBJECT> - The building the objects are on

Returns:
	<CONFIG> - The first config path if found or configNull if not

Examples:
    (begin example)
		_offsetDump = [_capturedObjects,_building] call KISKA_fnc_getObjectProperties;
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_findConfigAny"
scriptName SCRIPT_NAME;

params [
    ["_objects",[],[[]]],
    ["_building",objNull,[objNull]]
];

private _dumpArray = [];

_objects apply {
    
    private _objectClassname = typeOf _x; 
    private _objectPostionRelative = _building worldToModel (getPosWorld _x);
    private _objectVectorRelative = [_x,_building] call BIS_fnc_vectorDirAndUpRelative;

    private _isSimpleObject = isSimpleObject _x;
    private ["_isDynamic","_isSimulated"];

    if (_isSimpleObject) then {
        _isSimulated = false;
        _isDynamic = false;
    } else {
        _isDynamic = dynamicSimulationEnabled _x;	
        _isSimulated = simulationEnabled _x;
    };
   
    _dumpArray pushBack [_objectClassname,_objectPostionRelative,_objectVectorRelative,_isSimpleObject,_isSimulated,_isDynamic];
};

if (_building isKindOf "static") then {
    private _buildingClassname = typeOf _building;

    [_dumpArray, 0, [_buildingClassname]] call CBA_fnc_insert;
};


_dumpArray