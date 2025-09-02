/* ----------------------------------------------------------------------------
Function: KISKA_fnc_invisibleWalls_create

Description:
    Creates invisible walls at the given locations. When an object is used
    as a reference, the object's vector direction and up will also be 
    copied.

Parameters:
    0: _wallType <STRING> - The type to us for an invisible wall; most likely
        a VR block.
    1: _localOnly <BOOL> - Whether or not to create the wall locally only (`createVehicleLocal`).
    2: _spawnPositions <(OBJECT | [PositionWorld[],VectorDir[],VectorUp[]])[]> - 
        An array of objects and/or positions and vectors to create the walls 
        at.

Returns:
    <OBJECT[]> - The created invisible walls. If a spawn position is a null object,
        the invisible wall for that object will not be created and the resulting
        array will have `objNull` at that index.

Examples:
    (begin example)
        private _invisibleWalls = [
            "Land_VR_Slope_01_F",
            false,
            [
                MyObject
                // [getPosWorld MyObject,vectorDir MyObject, vectorUp MyObject] // same as MyObject
            ]
        ] call KISKA_fnc_invisibleWalls_create;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_invisibleWalls_create";

params [
    ["_wallType","",[""]],
    ["_localOnly",true,[true]],
    ["_spawnPositions",[],[[]]]
];

if (_spawnPositions isEqualTo []) exitWith {[]};

_spawnPositions apply {
    _x params [
        ["_spawnPosition",objNull,[objNull,[]],3],
        ["_vectorDir",nil,[[]],3],
        ["_vectorUp",nil,[[]],3]
    ];

    if (_spawnPosition isEqualType objNull) then {
        if (isNull _spawnPosition) then {
            continueWith objNull;
        };

        _vectorDir = vectorDir _spawnPosition;
        _vectorUp = vectorUp _spawnPosition;
        _spawnPosition = getPosWorld _spawnPosition;
    };

    private "_invisibleWall";
    if (_localOnly) then {
        _invisibleWall = _wallType createVehicleLocal [0,0,0];
        _invisibleWall setObjectMaterial [0,""];
        _invisibleWall setObjectTexture [0,""];
        _invisibleWall setObjectMaterial [1,""];
        _invisibleWall setObjectTexture [1,""];
        _invisibleWall enableSimulation false;
    } else {
        _invisibleWall = _wallType createVehicle [0,0,0];
        _invisibleWall setObjectMaterialGlobal [0,""];
        _invisibleWall setObjectTextureGlobal [0,""];
        _invisibleWall setObjectMaterialGlobal [1,""];
        _invisibleWall setObjectTextureGlobal [1,""];
        _invisibleWall enableSimulationGlobal false;
    };

    if (isNil "_vectorDir") then {
        _vectorDir = vectorDir _invisibleWall;
    };
    if (isNil "_vectorUp") then {
        _vectorUp = vectorUp _invisibleWall;
    };
    _invisibleWall setPosWorld _spawnPosition;
    _invisibleWall setVectorDirAndUp [_vectorDir,_vectorUp];

    _invisibleWall
};