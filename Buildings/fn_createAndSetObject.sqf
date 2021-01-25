/* ----------------------------------------------------------------------------
Function: KISKA_fnc_createAndSetObject

Description:
	Used in KISKA_fnc_selectAndSpawnBuildingTemplate to create each object
     on the building.

Parameters:
	0: _createObjectInfo : <ARRAY> - The objects info to create it
    1: _building : <OBJECT> - The building the objects is on

Returns:
	<OBJECT> - The created object

Examples:
    (begin example)
		_object = [_arrayOfInfo,myBuilding] call KISKA_fnc_createAndSetObject;
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_createAndSetObject"
scriptName SCRIPT_NAME;

params [
    ["_createObjectInfo",[],[[]]],
    ["_building",objNull,[objNull]]
];

if (isNull _building) exitWith {
    ["_building is a null object",true] call KISKA_fnc_log;
    objNull
};

_createObjectInfo params [
    "_objectClassname",
    "_objectPostionRelative",
    "_objectVectorRelative",
    ["_isSimpleObject",false],
    ["_isSimulated",true],
    ["_isDynamic",false]
];

//create Object
private "_createdObject";

if (is3DEN) then {
    _createdObject = create3DENEntity ["object",_objectClassname,[0,0,0]];
} else {

    if (_isSimpleObject)	then {
        _createdObject = createSimpleObject [_objectClassname,[0,0,0]];
    } else {
        _createdObject = createVehicle [_objectClassname,[0,0,0]];

        if (_isDynamic) then {
            _createdObject enableDynamicSimulation true;
        } else {
            if !(_isSimulated) then {
                [_createdObject,false] remoteExecCall ["enableSimulationGlobal",2];
            };
        }; 
    };
};

//Set position relative to building
_createdObject setPosWorld (_building modelToWorld _objectPostionRelative);

//Set direction relative to building
private _vectorDir = _createdObject vectorModelToWorldVisual (_objectVectorRelative select 0);
private _vectorUp = _createdObject vectorModelToWorldVisual (_objectVectorRelative select 1);

_createdObject setVectorDirAndUp [_vectorDir,_vectorUp];


/*
//Align Vector
private _buildingVectorDir = vectorDir _building;
private _buildingVectorUp = vectorUp _building;
_createdObject setVectorDirAndUp [_buildingVectorDir,_buildingVectorUp];
*/

//Set direction relative to building
/*
private _createObject_DirectionOffset = _objectVectorRelative;
private _buildingDirection = getDir _building;
private _createdObject_FinalDireaction = _createObject_DirectionOffset + _buildingDirection;

_createdObject setDir _createdObject_FinalDireaction;
*/


_createdObject