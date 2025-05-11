/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openSupplyDrop

Description:
    Opens a commanding menu that will allow the player to select the parameters
    of a supply drop.

Parameters:
    0: _supportId <STRING> - The ID of the specific support.
    1: _supportConfig <CONFIG> - The support's config path.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_support_1",
            configFile >> "MySupplyDrop"
        ] call KISKA_fnc_commMenu_openSupplyDrop;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openSupplyDrop";

#define DEFAULT_DROP_ALTITUDE 100

params [
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]]
];

if (isNull _supportConfig) exitWith {
    ["null _supportConfig used!",true] call KISKA_fnc_log;
    nil
};

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";
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
    Drop Altitude
---------------------------------------------------------------------------- */
private _selectableAltitudes = getArray(_commMenuDetailsConfig >> "dropAltitudes");
if (_selectableAltitudes isEqualTo []) then {
    _selectableAltitudes = missionNamespace getVariable ["KISKA_CBA_supp_flyInHeights_arr",[]];

    if (_selectableAltitudes isEqualTo []) then {
        _selectableAltitudes = [DEFAULT_DROP_ALTITUDE];
    };
};
private _dropAltitudeOptions = _selectableRadiuses apply {
    private _label = [_x,"m"] joinString "";
    [_label,_x]
};
_menuPath pushBack ["Drop Altitude",_dropAltitudeOptions];


/* ----------------------------------------------------------------------------
    Create Menu
---------------------------------------------------------------------------- */
private _draw3dMarker = [_commMenuDetailsConfig >> "draw3dMarker",true] call KISKA_fnc_getConfigData;
if (_draw3dMarker) then { call KISKA_fnc_drawLookingAtMarker_start };

[
    _menuPath,
    [[_supportId,_commMenuDetailsConfig], {     
        private _playerDirection = getDir player;
        params [
            ["_ingressDirection",_playerDirection],
            "_dropAltitude"
        ];
        if (_ingressDirection isEqualTo MY_DIRECTION_VALUE) then {
            _ingressDirection = _playerDirection;
        };
        private _dropPosition = call KISKA_fnc_supports_getCommonTargetPosition;
        private _argsMapInit = [
            ["dropPosition",_dropPosition],
            ["dropAltitude",_dropAltitude],
            ["directionOfAircraft",_ingressDirection],
            ["side",side player]
        ];
        
        _thisArgs params ["_supportId","_commMenuDetailsConfig"];
        
        [
            "aircraftClass",
            "spawnDistance",
            "objectClassNames",
            "dropPositionRadius",
            "parachuteClass",
            "dropZVelocity",
            "velocityUpdateFrequency",
            "distanceToStopVelocityUpdates",
            ["allowDamage",true],
            ["addArsenals",true],
            ["clearCargo",true]
        ] apply {
            _x params ["_paramName",["_isBool",false]];
            private _value = [_commMenuDetailsConfig >> _paramName,_isBool] call KISKA_fnc_getConfigData;
            if (isNil "_value") then { continue };
            _argsMapInit pushBack [_paramName,_aircraftClass];
        };

        [
            _supportId,
            _dropPosition,
            1,
            createHashMapFromArray _argsMapInit
        ] call KISKA_fnc_supports_call;
    }],
    {},
    [[_draw3dMarker],{
        _thisArgs params ["_draw3dMarker"];
        if !(_draw3dMarker) exitWith {};
        
        call KISKA_fnc_drawLookingAtMarker_stop 
    }]
] spawn KISKA_fnc_openCommandingMenuPath;