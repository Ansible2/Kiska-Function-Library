/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supplyDrop

Description:
    Creates a number of specified objects and parachutes for them to drop down from
    the sky.

Parameters:
    0: _argsMap <HASHMAP> - a map of arguments for the supply drop:

        - `objectClassNames`: <STRING[]> - a list of classnames of objects that will
            be created and parachute down.
        - `dropPosition`: <PositionASL[] or OBJECT> - The position around which the objects
            will approximately land.
        - `dropAltitude`: <NUMBER> Default: `100` - The height that the dropped 
            objects begin their descent.
        - `dropPositionRadius`: <NUMBER> Default: `50` - A randomization radius 
            around the `dropPosition` in which the objects will be created.
        - `parachuteClass`: <NUMBER> Default: `b_parachute_02_F` - The classname
            of the parachute.
        - `dropZVelocity`: <NUMBER> Default: `-15` - The m/s rate of descent that
            will be applied to the parachutes while every `velocityUpdateFrequency`
            denoted time and if the object is above a surface beneath it as defined
            with `distanceToStopVelocityUpdates`.
        - `velocityUpdateFrequency`: <NUMBER> Default: `0.1` - How frequently
            to update the objects downward velocity.
        - `distanceToStopVelocityUpdates`: <NUMBER> Default: `80` - At what
            distance to the surface beneath the objects should the velocity
            stop being applied.
        - `allowDamage`: <BOOL> Default: `true` - Whether or not to automatically
            disable damage on the dropped objects.
        - `addArsenals`: <BOOL> Default: `false` - Whether or not to automatically
            add arsenals to the dropped objects with `KISKA_fnc_addArsenal`.
        - `clearCargo`: <BOOL> Default: `false` - Whether or not to automatically
            globally delete the dropped object's cargo with `KISKA_fnc_clearCargoGlobal`.

Returns:
    <OBJECT[]> - The created objects that were dropped.

Examples:
    (begin example)
        private _argsMap = createHashMapFromArray [
            ["objectClassNames",["B_supplyCrate_F","B_supplyCrate_F"]],
            ["dropPosition",target]
        ];
        private _crates = [_argsMap] call KISKA_fnc_supplyDrop;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supplyDrop";

#define MIN_DROP_ALT 1
#define MIN_DROP_RADIUS 10
#define DELAY_FOR_CHUTE_DEPLOYMENT 3
#define MIN_DISTANCE_TO_STOP_VELOCITY_UPDATES 15
#define DISTANCE_TO_DETACH 5
#define VELOCITY_RELEASE_THRESHOLD 0.1

params [
    ["_argsMap",[],[createHashMap]]
];

private _paramDetails = [
    ["objectClassNames",{[]},[[]]],
    ["dropPosition",{objNull},[objNull,[]]],
    ["dropAltitude",{100},[123]],
    ["dropPositionRadius",{50},[123]],
    ["parachuteClass",{"b_parachute_02_F"},[""]],
    ["dropZVelocity",{-15},[123]],
    ["velocityUpdateFrequency",{0.1},[123]],
    ["distanceToStopVelocityUpdates",{80},[123]],
    ["allowDamage",{true},[false]],
    ["addArsenals",{false},[false]],
    ["clearCargo",{false},[false]]
];
private _paramValidationResult = [_argsMap,_paramDetails] call KISKA_fnc_hashMapParams;
if (_paramValidationResult isEqualType "") exitWith {
    [_paramValidationResult,true] call KISKA_fnc_log;
    []
};
(_paramValidationResult select 0) params (_paramValidationResult select 1);


if (_objectClassNames isEqualTo []) exitWith {
    ["objectClassNames is empty!",true] call KISKA_fnc_log;
    []
};
private _dropPositionIsObject = _dropPosition isEqualType objNull;
if (_dropPositionIsObject AND {isNull _dropPosition}) exitWith {
    ["dropPosition is null object",true] call KISKA_fnc_log;
    []
};
if (_dropPositionIsObject) then {
    _dropPosition = getPosASL _dropPosition;
};

_dropPositionRadius = _dropPositionRadius max MIN_DROP_RADIUS;
_dropAltitude = _dropAltitude max MIN_DROP_ALT;
_velocityUpdateFrequency = _velocityUpdateFrequency max 0;
_distanceToStopVelocityUpdates = _distanceToStopVelocityUpdates max MIN_DISTANCE_TO_STOP_VELOCITY_UPDATES;

private _terrainHeighAtDropPosition = getTerrainHeightASL _dropPosition;
if (_terrainHeighAtDropPosition < 0) then {_terrainHeighAtDropPosition = 0};
_dropPosition set [2,_terrainHeighAtDropPosition];
private _aslSpawnHeight = _terrainHeighAtDropPosition + _dropAltitude;
private _objectSpawnCenter = _dropPosition vectorAdd [0,0,_dropAltitude];
_objectClassNames apply {
    private _objectDropPosition = [_objectSpawnCenter,_dropPositionRadius] call CBA_fnc_randPos;
    _objectDropPosition set [2,_aslSpawnHeight];
    private _object = createVehicle [_x,_objectDropPosition,[],0,"FLY"];
    _object setPosASL _objectDropPosition;
    if (!_allowDamage) then { _object allowDamage false };
    if (_addArsenals) then { [_object] call KISKA_fnc_addArsenal };
    if (_clearCargo) then { [_object] call KISKA_fnc_clearCargoGlobal };
    
    private _parachute = createVehicle [_parachuteClass,_objectDropPosition,[],0,"FLY"];
    _parachute setPosASL _objectDropPosition;
    _object attachTo [_parachute,[0,0,0]];

    [
        {
            params ["","","_velocityUpdateFrequency"];
            [
                {
                    params ["_args","_id"];
                    _args params [
                        "_object",
                        "_parachute",
                        "",
                        "_dropZVelocity",
                        "_distanceToStopVelocityUpdates"
                    ];

                    private _distanceToSurface = (getPosVisual _object) select 2;
                    if (_distanceToSurface >= _distanceToStopVelocityUpdates) exitWith {
                        private _chuteVelocity = velocity _parachute;
                        _chuteVelocity set [2,_dropZVelocity];
                        _parachute setVelocity _chuteVelocity;
                    };

                    if (
                        (_distanceToSurface <= DISTANCE_TO_DETACH) OR
                        {
                            private _velocity = velocity _object;
                            (_velocity select 2) <= VELOCITY_RELEASE_THRESHOLD
                        }
                    ) exitWith {
                        detach _object;
                        [_id] call KISKA_fnc_CBA_removePerFrameHandler;
                    };
                },
                _velocityUpdateFrequency,
                _this
            ] call KISKA_fnc_CBA_addPerFrameHandler;
        },
        [
            _object,
            _parachute,
            _velocityUpdateFrequency,
            _dropZVelocity,
            _distanceToStopVelocityUpdates
        ],
        DELAY_FOR_CHUTE_DEPLOYMENT
    ] call KISKA_fnc_CBA_waitAndExecute;


    _object
};
