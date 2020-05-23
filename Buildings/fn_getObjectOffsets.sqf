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


    //private _objectDirectionOffset = abs (_buildinDirection - (getDir _x));

    //_dumpArray pushBack [_objectClassname,_objectPostionRelative,_objectVectorRelative];
};

if (_building isKindOf "static") then {
    private _buildingClassname = typeOf _building;

    [_dumpArray, 0, [_buildingClassname]] call CBA_fnc_insert;
};

_dumpArray