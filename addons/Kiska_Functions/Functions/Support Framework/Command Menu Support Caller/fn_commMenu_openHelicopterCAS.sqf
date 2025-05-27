/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openHelicopterCAS

Description:
    Opens a commanding menu that will allow the player to select the parameters
    of a helicopter version 1 CAS support.

Parameters:
    0: _supportId <STRING> - The ID of the specific support.
    1: _supportConfig <CONFIG> - The support's config path.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_support_1",
            configFile >> "MyHelicopterCAS"
        ] call KISKA_fnc_commMenu_openHelicopterCAS;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openHelicopterCAS";

#define DEFAULT_PATROL_RADIUS 200
#define DEFAULT_PATROL_ALTITUDE 50
#define SPEED_LIMIT 10
#define MY_DIRECTION_VALUE "my direction"

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

private _menuPath = [];

/* ----------------------------------------------------------------------------
    Ingress Direction Options
---------------------------------------------------------------------------- */
private _canSelectIngressDirection = [_commMenuDetailsConfig >> "canSelectIngress",true] call KISKA_fnc_getConfigData;
if (_canSelectIngressDirection) then {
    private _ingressDirectionOptions = [
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
    _ingressDirectionOptions pushBack ["My Direction",MY_DIRECTION_VALUE];
    _menuPath pushBack ["Ingress Direction",_ingressDirectionOptions];
};


/* ----------------------------------------------------------------------------
    Patrol Zone Radius Menu
---------------------------------------------------------------------------- */
private _selectableRadiuses = getArray(_commMenuDetailsConfig >> "patrolRadiuses");
if (_selectableRadiuses isEqualTo []) then {
    _selectableRadiuses = missionNamespace getVariable ["KISKA_CBA_supp_radiuses_arr",[]];

    if (_selectableRadiuses isEqualTo []) then {
        _selectableRadiuses = [DEFAULT_PATROL_RADIUS];
    };
};
private _patrolZoneOptions = _selectableRadiuses apply {
    private _label = [_x,"m"] joinString "";
    [_label,_x]
};
_menuPath pushBack ["Patrol Zone Radius",_patrolZoneOptions];


/* ----------------------------------------------------------------------------
    Patrol Altitude
---------------------------------------------------------------------------- */
private _selectableAltitudes = getArray(_commMenuDetailsConfig >> "patrolAltitudes");
if (_selectableAltitudes isEqualTo []) then {
    _selectableAltitudes = missionNamespace getVariable ["KISKA_CBA_supp_flyInHeights_arr",[]];

    if (_selectableAltitudes isEqualTo []) then {
        _selectableAltitudes = [DEFAULT_PATROL_ALTITUDE];
    };
};
private _patrolAltitudeOptions = _selectableAltitudes apply {
    private _label = [_x,"m"] joinString "";
    [_label,_x]
};
_menuPath pushBack ["Patrol Altitude",_patrolAltitudeOptions];


/* ----------------------------------------------------------------------------
    Create Menu
---------------------------------------------------------------------------- */
private _patrolDuration = getNumber(_commMenuDetailsConfig >> "patrolDuration");
private _draw3dMarker = [_commMenuDetailsConfig >> "draw3dMarker",true] call KISKA_fnc_getConfigData;
if (_draw3dMarker) then { call KISKA_fnc_drawLookingAtMarker_start };

[
    _menuPath,
    [[_supportId,_aircraftClass,_patrolDuration], {
        private _playerDirection = getDir player;
        params [
            ["_ingressDirection",_playerDirection],
            "_patrolZoneRadius",
            "_patrolAltitude"
        ];
        if (_ingressDirection isEqualTo MY_DIRECTION_VALUE) then {
            _ingressDirection = _playerDirection;
        };
        _thisArgs params ["_supportId","_aircraftClass","_patrolDuration"];

        [
            _supportId,
            call KISKA_fnc_supports_getCommonTargetPosition,
            1,
            [
                call KISKA_fnc_supports_getCommonTargetPosition,
                _patrolZoneRadius,
                _aircraftClass,
                _patrolDuration,
                SPEED_LIMIT,
                _patrolAltitude,
                _ingressDirection,
                side player
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
