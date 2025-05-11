/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openCAS

Description:
   Opens a commanding menu that will allow the player to select the parameters
   of a CAS strike.

Parameters:
    0: _supportId <STRING> - The ID of the specific support.
    1: _supportConfig <CONFIG> - The support's config path.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_support_1",
            configFile >> "MyCASSupport"
        ] call KISKA_fnc_commMenu_openCAS;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openCAS";

#define MY_DIRECTION_VALUE "my direction"
#define MIN_RADIUS 0

params [
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]]
];

if (isNull _supportConfig) exitWith {
    ["null _supportConfig used!",true] call KISKA_fnc_log;
    nil
};

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";
private _aircraftClass = getText(_commMenuDetailsConfig >> "aircraftClass");
if (_aircraftClass isEqualTo "") exitWith {
    [["`aircraftClass` is not defined in ",_commMenuDetailsConfig],true] call KISKA_fnc_log;
    nil
};

/* ----------------------------------------------------------------------------
    Attack Type Options
---------------------------------------------------------------------------- */
private _attackTypeClasses = configProperties [_commMenuDetailsConfig >> "AttackTypes","isClass _x"];
if (_attackTypeClasses isEqualTo []) exitWith {
    [["No AttackTypes defined in ",_commMenuDetailsConfig],true] call KISKA_fnc_log;
    nil
};
private _attackTypeOptions = _attackTypeClasses apply { [getText(_x >> "label"),_x] };

private _menuPath = [
    ["Attack Type",_attackTypeOptions]
];


/* ----------------------------------------------------------------------------
    Attack Direction Options
---------------------------------------------------------------------------- */
private _canSelectAttackDirection = [_commMenuDetailsConfig >> "canSelectAttackDirection",true] call KISKA_fnc_getConfigData;
if (_canSelectAttackDirection) then {
    private _attackDirectionOptions = [
        [0,"N"],
        [45,"NE"],
        [90,"E"],
        [135,"SE"],
        [180,"S"],
        [225,"SW"],
        [270,"W"],
        [315,"NW"]
    ] apply {
        _x params ["_bearing","_cardinal"];
        private _label = [_bearing,_cardinal] joinString " - ";
        [_label,_bearing]
    };
    _attackDirectionOptions pushBack ["My Direction",MY_DIRECTION_VALUE];
    _menuPath pushBack ["Attack Direction",_attackDirectionOptions];
};


/* ----------------------------------------------------------------------------
    Create Menu
---------------------------------------------------------------------------- */
private _draw3dMarker = [_commMenuDetailsConfig >> "draw3dMarker",true] call KISKA_fnc_getConfigData;
if (_draw3dMarker) then { call KISKA_fnc_drawLookingAtMarker_start };

[
    _menuPath,
    [[_supportId,_aircraftClass], {
        private _playerDirection = getDir player;
        params [
            "_attackTypeConfig",
            ["_attackDirection",_playerDirection]
        ];

        if (_attackDirection isEqualTo MY_DIRECTION_VALUE) then {
            _attackDirection = _playerDirection;
        };

        _thisArgs params ["_supportId","_aircraftClass"];
        private _aircraftParamsMapInitializer = [
            ["aircraftClass",_aircraftClass],
            ["side",side player],
            ["attackPosition",call KISKA_fnc_supports_getCommonTargetPosition],
            ["directionOfAttack",_attackDirection]
        ];

        [
            "allowDamage",
            "initialHeightAboveTarget",
            "initialDistanceToTarget",
            "breakOffDistance",
            "numberOfFlaresToDump",
            "approachSpeed",
            "vectorToTargetOffset"
        ] apply {
            private _cfgData = [_attackTypeConfig >> _x] call KISKA_fnc_getCfgData;
            if (isNil "_cfgData") then { continue };
            _aircraftParamsMapInitializer pushBack [_x, _cfgData];
        };

        [
            _supportId,
            call KISKA_fnc_supports_getCommonTargetPosition,
            1,
            [
                createHashMapFromArray _aircraftParamsMapInitializer,
                getArray(_attackTypeConfig >> "fireOrders")
            ]
        ] call KISKA_fnc_supports_call;
    }],
    {},
    [[_draw3dMarker],{
        _thisArgs params ["_draw3dMarker"];
        if !(_draw3dMarker) exitWith {};
        
        call KISKA_fnc_drawLookingAtMarker_stop 
    }]
] spawn KISKA_fnc_openCommandingMenuPath;


nil
