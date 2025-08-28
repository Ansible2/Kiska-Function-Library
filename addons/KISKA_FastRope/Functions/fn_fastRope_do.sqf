/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_do

Description:
    Sends a vehicle to a given point and fastropes the given units from the helicopter.

    Pilots should ideally be placed in "CARELESS" behaviour when around enemies.

Parameters:
    0: _argsMap <HASHMAP> - A hashmap of various parameters for the fastrope.
        - `vehicle`: <OBJECT> - The vehicle to fastrope units from.
        - `dropPosition`: <PositionsASL[] | OBJECT> - The position to drop units off.
        - `hoverHeight`: <NUMBER> - The height above the drop position that the helicopter
            will hover. Defaults to `20`, min is `5`, max is `28`.
        - `unitsToDeploy`: <CODE, STRING, [ARRAY,CODE], [ARRAY,STRING], OBJECT[], GROUP, or OBJECT> - 
            An array of units to drop from the `_vehicle` or code that will run once the helicopter 
            has reached the drop point that must return an OBJECT[].
            (see `KISKA_fnc_callBack` for examples).

            Parameters:

                - 0: <OBJECT> - The fastrope vehicle.

        - `onDropEnded`: <CODE, STRING, [ARRAY,CODE]> - Code that will be executed once
            all the units have been dropped off, the vehicle's engine is no longer on,
            or the vehicle is no longer alive. The default behaviour can be found
            in `KISKA_fnc_fastRopeEvent_onDropEndedDefault`. However, the vehicle's config
            will also be searched for the event first (see `KISKA_fnc_fastRope_getConfigData`).
            (see `KISKA_fnc_callBack` for type examples).

            Parameters:

                - 0: <HASHMAP> - A hashmap containing various pieces of information
                    pertaining to the drop.

        - `onDropComplete`: <CODE, STRING, [ARRAY,CODE]> - Code that will be executed once
            all the units have been dropped off, the vehicle's engine is no longer on,
            or the vehicle is no longer alive, AND the `onDropEnded` has run. This
            defaults to empty code and is used in case a user does not want to overwrite
            `onDropEnded`'s behaviour.
            (see `KISKA_fnc_callBack` for type examples).

            Parameters:

                - 0: <HASHMAP> - A hashmap containing various pieces of information
                    pertaining to the drop.

        - `onHoverStarted`: <CODE, STRING, [ARRAY,CODE]> - Code that will be executed once
            the vehicle has approixmately reached its hover position. The default behaviour can be found
            in `KISKA_fnc_fastRopeEvent_onHoverStartedDefault`. However, the vehicle's config
            will also be searched for the event first (see `KISKA_fnc_fastRope_getConfigData`).
            (see `KISKA_fnc_callBack` for type examples).

            Parameters:

                - 0: <HASHMAP> - A hashmap containing various pieces of information
                    pertaining to the drop.

        - `getRopeOrigins`: <CODE, STRING, [ARRAY,CODE]> - Code that will be executed once
            in and must return a type of `(STRING | PostiionRelative[])[]`. These will be where ropes
            will hang from relative to either String entries are memory points. The default 
            behaviour is to get the rope origins from the vehicle's config using
            `KISKA_fnc_fastRope_getConfigData`.
            (see `KISKA_fnc_callBack` for type examples).

            Parameters:
            
                - 0: <OBJECT> - The fastrope vehicle.

Returns:
    NOTHING

Examples:
    (begin example)
        private _paramsMap = createHashMapFromArray [
            ["vehicle",MyHelicopter],
            ["dropPosition",MyDropPosition],
            [
                "unitsToDeploy",
                (fullCrew [_vehicle,"cargo"]) apply {
                    _x select 0
                }
            ],
            [
                "onDropComplete",
                {
                    hint "fastrope done"
                }
            ]
        ];
        _paramsMap call KISKA_fnc_fastRope_do;
    (end)

    (begin example)
        // using code instead to defer the list of units to drop
        // until the helicopter is over the drop point
        private _paramsMap = createHashMapFromArray [
            ["vehicle",MyHelicopter],
            ["dropPosition",MyDropPosition],
            [
                "unitsToDeploy",
                {
                    params ["_vehicle"];
                    (fullCrew [_vehicle,"cargo"]) apply {
                        _x select 0
                    }
                }
            ],
            [
                "onDropComplete",
                {
                    hint "fastrope done"
                }
            ],
            [
                "getRopeOrigins",
                { [[0,0,0]] }
            ]
        ];
        _paramsMap call KISKA_fnc_fastRope_do;
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
    ["hoverHeight",{20},[123]],
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
    [
        "onDropComplete",
        {{}},
        CALL_BACK_TYPES
    ],
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
            [[_fastRopeInfoMap,_onDropEnded,_fastRopeInfoMap_var,_onDropComplete], {
                _thisArgs params ["_fastRopeInfoMap","_onDropEnded","_fastRopeInfoMap_var","_onDropComplete"];
                localNamespace setVariable [_fastRopeInfoMap_var,nil];
                [_fastRopeInfoMap, _onDropEnded] call KISKA_fnc_callBack;
                [_fastRopeInfoMap, _onDropComplete] call KISKA_fnc_callBack;
            }]
        ]
    ]
] call KISKA_fnc_hover;


nil
