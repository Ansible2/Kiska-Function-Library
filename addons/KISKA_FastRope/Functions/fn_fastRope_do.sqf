/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_do

Description:
    Sends a vehicle to a given point and fastropes the given units from the helicopter.

    Pilots should ideally be placed in "CARELESS" behaviour when around enemies.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _dropPosition <ARRAY or OBJECT> - The positionASL to drop the units off at; Z coordinate
        matters
    2: _unitsToDeploy <CODE, STRING, [ARRAY,CODE], [ARRAY,STRING], OBJECT[], GROUP, or OBJECT> - 
        An array of units to drop from the _vehicle or code that will run once the helicopter 
        has reached the drop point that must return an array of object
        (see `KISKA_fnc_callBack` for examples).

        Parameters:
        - 0: _vehicle - The drop vehicle

    3: _afterDropCode <CODE, STRING or ARRAY> - Code to execute after the drop is complete, 
        see `KISKA_fnc_callBack`.
        
        Parameters:
        - 0: _vehicle - The drop vehicle

    4: _hoverHeight <NUMBER> - The height the helicopter should hover above the drop position
        while units are fastroping. Max is 28, min is 5.
    5: _ropeOrigins <(String | Vector3D[])[]> - An array of relative (to the vehicle) attachment
        points for the ropes and/or memory points to `attachTo` the ropes to the vehicle.

Returns:
    NOTHING

Examples:
    (begin example)
        //  basic example
        [
            _vehicle,
            _position,
            (fullCrew [_vehicle,"cargo"]) apply {
                _x select 0
            },
            {hint "fastrope done"},
            28,
            [[0,0,0]]
        ] call KISKA_fnc_fastRope_do;
    (end)

    (begin example)
        // using code instead to defer the list of units to drop
        // until the helicopter is over the drop point
        [
            _vehicle,
            _position,
            {
                params ["_vehicle"];

                (fullCrew [_vehicle,"cargo"]) apply {
                    _x select 0
                }
            },
            {hint "fastrope done"},
            28,
            [[0,0,0]]
        ] call KISKA_fnc_fastRope_do;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_do";

#define MIN_HOVER_HEIGHT 5
#define MAX_HOVER_HEIGHT 28
#define CALL_BACK_TYPES [{},"",[]]

private _defaultMap = createHashMap;
params [
    ["_argsMap",_defaultMap,[_defaultMap]]
];

private _paramDetails = [
    ["vehicle",{objNull},[objNull]],
    ["dropPosition",{[]},[[],objNull]],
    ["unitsToDeploy",{[]},[[],grpNull,objNull,{},""]],
    [
        "onDropEnded",
        {{
            params ["_fastRopeInfoMap"];
            private _vehicleConfig = _fastRopeInfoMap getOrDefaultCall ["_vehicleConfig",{configNull}];

            private _onDropEnded = [_vehicleConfig,"onDropEnded"] call KISKA_fnc_fastRope_getConfigData;
            if (_onDropEnded isNotEqualTo {}) exitWith { _fastRopeInfoMap call _onDropEnded };

            _fastRopeInfoMap call KISKA_fnc_fastRopeEvent_onDropEndedDefault;
        }},
        CALL_BACK_TYPES
    ],
    ["hoverHeight",{20},[123]],
    [
        "getRopeOrigins",
        {{
            params ["_vehicle"];
            [_vehicle,"ropeOrigins"] call KISKA_fnc_fastRope_getConfigData
        }},
        CALL_BACK_TYPES
    ],
    [
        "onHoverStarted",
        {{
            params ["_fastRopeInfoMap"];
            private _vehicleConfig = _fastRopeInfoMap getOrDefaultCall ["_vehicleConfig",{configNull}];
            
            private _onHoverStarted = [_vehicleConfig,"onHoverStarted"] call KISKA_fnc_fastRope_getConfigData;
            if (_onHoverStarted isNotEqualTo {}) exitWith { _fastRopeInfoMap call _onHoverStarted };
            
            _fastRopeInfoMap call KISKA_fnc_fastRopeEvent_onHoverStartedDefault;
        }},
        CALL_BACK_TYPES
    ]
];
private _paramValidationResult = [_argsMap,_paramDetails] call KISKA_fnc_hashMapParams;
if (_paramValidationResult isEqualType "") exitWith {
    [_paramValidationResult,true] call KISKA_fnc_log;
    nil
};
(_paramValidationResult select 0) params (_paramValidationResult select 1);


/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if !(alive _vehicle) exitWith {
    ["_vehicle is not alive!",true] call KISKA_fnc_log;
    nil
};

private _ropeOrigins = [_vehicle,_getRopeOrigins] call KISKA_fnc_callBack;
if (
    !(_ropeOrigins isEqualType []) OR
    {_ropeOrigins isEqualTo []}
) exitWith {
    ["No rope origins were provided for the vehicle!",true] call KISKA_fnc_log;
    nil
};


/* ----------------------------------------------------------------------------
    Verify _unitsToDeploy
---------------------------------------------------------------------------- */
private _unitsToDeployFiltered = [];
private _unitsToDeployIsCode = false;
call {
    if (_unitsToDeploy isEqualType grpNull) exitWith {
        (units _unitsToDeploy) apply {
            if !(alive _x) then { continue };
            _unitsToDeployFiltered pushBack _x;
        };
    };

    if (
        (_unitsToDeploy isEqualType objNull) AND 
        { alive _unitsToDeploy }
    ) exitWith {
        _unitsToDeployFiltered = [_unitsToDeploy];
    };

    if (_unitsToDeploy isEqualType []) exitWith {
        _unitsToDeployIsCode = 
            (_unitsToDeploy isEqualTypeParams [[],{}]) OR 
            {_unitsToDeploy isEqualTypeParams [[],""]} OR
            {_unitsToDeploy isEqualType ""} OR 
            {_unitsToDeploy isEqualType {}};

        if (_unitsToDeployIsCode) exitWith {
            _unitsToDeployFiltered = _unitsToDeploy
        };

        _unitsToDeploy apply {
            if (_x isEqualType grpNull) then {
                _unitsToDeployFiltered append (units _x);
                continue;
            };

            if ((_x isEqualType objNull) AND {alive _x}) then {
                _unitsToDeployFiltered pushBackUnique _x;
                continue;
            };
        };
    };
};


if (_unitsToDeployFiltered isEqualTo []) exitWith {
    ["Could not find any units to deploy",true] call KISKA_fnc_log;
    false
};

private _fastRopeInfoMap = createHashMapFromArray [
    ["_unitsToDeploy",_unitsToDeployFiltered],
    ["_unitsToDeployIsCode",_unitsToDeployIsCode],
    ["_ropeOrigins",_ropeOrigins],
    ["_fastRopeEnded",false],
    ["_canDeployRopes",false],
    ["_vehicle",_vehicle],
    ["_vehicleConfig",configOf _vehicle]
];

[
    {
        params ["_vehicle","_fastRopeInfoMap"];

        if !(alive _vehicle) exitWith {};

        private _vehicleConfig = _fastRopeInfoMap getOrDefaultCall ["_vehicleConfig",{configNull}];
        private _friesType = [_vehicleConfig,"friesType"] call KISKA_fnc_fastRope_getConfigData;

        if (_friesType isEqualTo "") exitWith {
            _fastRopeInfoMap set ["_fries",_vehicle];
        };

        private _friesAttachmentPoint = [_vehicleConfig,"friesAttachmentPoint"] call KISKA_fnc_fastRope_getConfigData;
        private _fries = _friesType createVehicle [0,0,0];
        _fries attachTo [_vehicle,_friesAttachmentPoint];

        _fastRopeInfoMap set ["_fries",_fries];
    },
    [_vehicle,_fastRopeInfoMap]
] call CBA_fnc_execNextFrame;


/* ----------------------------------------------------------------------------
    Move to target and hover
---------------------------------------------------------------------------- */
_hoverHeight = _hoverHeight max MIN_HOVER_HEIGHT;
_hoverHeight = _hoverHeight min MAX_HOVER_HEIGHT;
_fastRopeInfoMap set ["_hoverHeight",_hoverHeight];

if (_dropPosition isEqualType objNull) then {
    _dropPosition = getPosASL _dropPosition;
};
private _hoverPosition_ASL = _dropPosition vectorAdd [0,0,_hoverHeight];

private _fastRopeInfoMap_var = ["KISKA_fastRope_infoMap"] call KISKA_fnc_generateUniqueId;
localNamespace setVariable [_fastRopeInfoMap_var,_fastRopeInfoMap];
[
    _vehicle,
    _hoverPosition_ASL,
    createHashMapFromArray [
        [
            "_shouldHoverStop",
            compileFinal (format ['(localNamespace getVariable "%1") getOrDefaultCall ["_fastRopeEnded",{true}]',_fastRopeInfoMap_var])
        ],
        [
            "_onHoverStart",
            [[_fastRopeInfoMap,_onHoverStarted], {
                _thisArgs call KISKA_fnc_callBack;
                (_thisArgs select 0) call KISKA_fnc_fastRope_startDeploymentProcess;
            }]
        ],
        [
            "_onHoverEnd",
            [[_fastRopeInfoMap,_onDropEnded,_fastRopeInfoMap_var], {
                _thisArgs params ["_fastRopeInfoMap","_onDropEnded","_fastRopeInfoMap_var"];
                localNamespace setVariable [_fastRopeInfoMap_var,nil];
                [_fastRopeInfoMap, _onDropEnded] call KISKA_fnc_callBack;
            }]
        ]
    ]
] call KISKA_fnc_hover;


nil
