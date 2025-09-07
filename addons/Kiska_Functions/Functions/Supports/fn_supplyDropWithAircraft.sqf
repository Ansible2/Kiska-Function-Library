/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supplyDropWithAircraft

Description:
    A sub implementation of `KISKA_fnc_supplyDrop` that will in addition to dropping
    a set of objects, will have an aircraft fly over the drop zone simulating the cargo
    drop.

Parameters:
    0: _argsMap <HASHMAP> - a map of arguments for the supply drop:

        - `dropPosition`: <PositionASL[] or OBJECT> - See `KISKA_fnc_supplyDrop`.
        - `dropAltitude`: <NUMBER> - See `KISKA_fnc_supplyDrop`.
        - `aircraftClass: <STRING> - The class name of the aircraft that will be created
            to fly over the drop zone.
        - `side`: <SIDE> Default: `BLUFOR` - The side of the created aircraft.
        - `directionOfAircraft`: <NUMBER> Default: `-1` - The bearing the aircraft 
            will be flying towards. `-1` denotes a random direction.
        - `spawnDistance`: <NUMBER> Default: `2000` - How far away from the
            drop zone to spawn the aircraft.
        - `objectClassNames`: <STRING[]> - See `KISKA_fnc_supplyDrop`.
        - `dropPositionRadius`: <NUMBER> - See `KISKA_fnc_supplyDrop`.
        - `parachuteClass`: <NUMBER> - See `KISKA_fnc_supplyDrop`.
        - `dropZVelocity`: <NUMBER> - See `KISKA_fnc_supplyDrop`.
        - `velocityUpdateFrequency`: <NUMBER> - See `KISKA_fnc_supplyDrop`.
        - `distanceToStopVelocityUpdates`: <NUMBER> - See `KISKA_fnc_supplyDrop`.
        - `allowDamage`: <BOOL> - See `KISKA_fnc_supplyDrop`.
        - `addArsenals`: <BOOL> - See `KISKA_fnc_supplyDrop`.
        - `clearCargo`: <BOOL> - See `KISKA_fnc_supplyDrop`.

Returns:
    NOTHING

Examples:
    (begin example)
        private _argsMap = createHashMapFromArray [
            ["objectClassNames",["B_supplyCrate_F","B_supplyCrate_F"]],
            ["dropPosition",target],
            ["aircraftClass","B_T_VTOL_01_vehicle_F"]
        ];
        [_argsMap] call KISKA_fnc_supplyDropWithAircraft;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supplyDropWithAircraft";

#define DROP_POSITION_THRESHHOLD 40
#define DELETION_POSITION_THRESHHOLD 100

params [
    ["_argsMap",[],[createHashMap]]
];

private _paramDetails = [
    ["aircraftClass",{""},[""]],
    ["side",{BLUFOR},[sideUnknown]],
    ["directionOfAircraft",{-1},[123]],
    ["spawnDistance",{2000},[123]],
    ["dropPosition",{objNull},[objNull,[]]],
    ["dropAltitude",{100},[123]],
    ["objectClassNames",{[]},[[]]]
];
private _paramValidationResult = [_argsMap,_paramDetails] call KISKA_fnc_hashMapParams;
if (_paramValidationResult isEqualType "") exitWith {
    [_paramValidationResult,true] call KISKA_fnc_log;
    []
};
(_paramValidationResult select 0) params (_paramValidationResult select 1);

if (_aircraftClass isEqualTo "") exitWith {
    ["aircraftClass is not provided",true] call KISKA_fnc_log;
    []
};

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


private _spawnPosition = [
    _dropPosition,
    _spawnDistance,
    _directionOfAircraft + 180,
    _dropAltitude
] call KISKA_fnc_getPosRelativeASL;
private _pilotClass = getText(configFile >> "CfgVehicles" >> _aircraftClass >> "Crew");
private _vehicleArray = [
    _spawnPosition,
    _directionOfAircraft,
    _aircraftClass,
    _side,
    [_pilotClass]
] call KISKA_fnc_spawnVehicle;
_vehicleArray params ["_aircraft","_crew","_group"];

_crew apply { _x setCaptive true; };
_group setCombatBehaviour "CARELESS";
_group setCombatMode "BLUE";
[_group,true] call KISKA_fnc_ACEX_setHCTransfer;

_aircraft move (ASLToATL _dropPosition);
_aircraft flyinHeight _dropAltitude;


private _deletionPosition = AGLToASL (_dropPosition getPos [_spawnDistance,_directionOfAircraft]);
private _start = time;
[
    {
        params ["_args","_id"];
        _args params [
            "_aircraft",
            "_deletionPosition", 
            "_dropPosition", 
            "_objectClassNames",
            "_start",
            "_argsMap"
        ];

        private _cargoDropped = _aircraft getVariable ["KISKA_supplyDrop_isCargoDropped",false];
        if (_cargoDropped) exitWith {
            if (
                (_aircraft distance2D _deletionPosition) > DELETION_POSITION_THRESHHOLD AND 
                (_start < (_start + 60))
            ) exitWith {};
            
            deleteVehicleCrew _aircraft;
            deleteVehicle _aircraft;
            [_id] call KISKA_fnc_CBA_removePerFrameHandler;
        };

        if ((_aircraft distance2D _dropPosition) <= DROP_POSITION_THRESHHOLD) then {
            private _updatedDropPosition = _aircraft getRelPos [10 * (count _objectClassNames),180];
            _argsMap set ["dropPosition",_updatedDropPosition];
            [_argsMap] call KISKA_fnc_supplyDrop;
            _aircraft setVariable ["KISKA_supplyDrop_isCargoDropped",true];
            _aircraft move (ASLToATL _deletionPosition);
        };
    },
    0.5,
    [
        _aircraft,
        _deletionPosition, 
        _dropPosition, 
        _objectClassNames,
        _start,
        _argsMap
    ]
] call CBA_fnc_addPerFrameHandler;


nil