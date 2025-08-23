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
        "onRopesCut",
        {{
            params ["_vehicle"];
            private _onRopesCut = [
                _vehicle,
                "onRopesCut"
            ] call KISKA_fnc_fastRope_getConfigData;
            if (_onRopesCut isNotEqualTo {}) exitWith { 
                [_vehicle] call _onRopesCut;
            };
            
            [_vehicle] call KISKA_fnc_fastRopeEvent_onRopesCutDefault;
        }},
        CALL_BACK_TYPES
    ],
    [
        "onDroppedUnits",
        {{}},
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
        "onInitiated",
        {{
            params ["_vehicle"];
            private _onInitiated = [
                _vehicle,
                "onInitiated"
            ] call KISKA_fnc_fastRope_getConfigData;
            if (_onInitiated isNotEqualTo {}) exitWith { 
                [_vehicle] call _onInitiated;
            };
            
            [_vehicle] call KISKA_fnc_fastRopeEvent_onInitiatedDefault;
        }},
        CALL_BACK_TYPES
    ],
    [
        "onHoverStarted",
        {{
            params ["_vehicle"];
            private _onHoverStarted = [
                _vehicle,
                "onHoverStarted"
            ] call KISKA_fnc_fastRope_getConfigData;
            if (_onHoverStarted isNotEqualTo {}) exitWith { 
                [_vehicle] call _onHoverStarted;
            };
            
            [_vehicle] call KISKA_fnc_fastRopeEvent_onHoverStartedDefault;
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

[
    {
        params ["_vehicle","_onInitiated"];
        [_vehicle,_onInitiated] call KISKA_fnc_callBack;
    },
    [_vehicle,_onInitiated]
] call CBA_fnc_execNextFrame;


/* ----------------------------------------------------------------------------
    Move to target and hover
---------------------------------------------------------------------------- */
[_vehicle, false] call KISKA_fnc_fastRope_areUnitsDroppedOff;

_hoverHeight = _hoverHeight max MIN_HOVER_HEIGHT;
_hoverHeight = _hoverHeight min MAX_HOVER_HEIGHT;
if (_dropPosition isEqualType objNull) then {
    _dropPosition = getPosASL _dropPosition;
};
private _hoverPosition_ASL = _dropPosition vectorAdd [0,0,_hoverHeight];

[
    _vehicle,
    _hoverPosition_ASL,
    createHashMapFromArray [
        [
            "_shouldHoverStop",
            { (_this select 0) call KISKA_fnc_fastRope_areUnitsDroppedOff }
        ],
        [
            "_onHoverStart",
            [[_unitsToDeployIsCode,_unitsToDeployFiltered,_ropeOrigins,_hoverHeight,_onHoverStarted], {
                params ["_vehicle"];

                private _onHoverStarted = _thisArgs deleteAt 4;
                [_vehicle,_onHoverStarted] call KISKA_fnc_callBack;

                _thisArgs insert [0,[_vehicle]];
                _thisArgs call KISKA_fnc_fastRope_startDeploymentProcess;
            }]
        ],
        [
            "_onHoverEnd",
            [[_vehicle,_onDroppedUnits,_onRopesCut], {
                _thisArgs params ["_vehicle","_onDroppedUnits","_onRopesCut"];

                [_vehicle,false] call KISKA_fnc_fastRope_areUnitsDroppedOff;

                private _fries = _vehicle call KISKA_fnc_fastRope_fries;
                if (_fries isNotEqualTo _vehicle) then {
                    deleteVehicle _fries;
                };
                [_vehicle,objNull] call KISKA_fnc_fastRope_fries;

                [_vehicle, _onRopesCut] call KISKA_fnc_callBack;
                [_vehicle, _onDroppedUnits] call KISKA_fnc_callBack;
            }]
        ]
    ]
] call KISKA_fnc_hover;


nil
