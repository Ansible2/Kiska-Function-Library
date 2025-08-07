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
#define HOVER_INTERVAL 0.05
#define CALL_BACK_TYPES [{},"",[]]
#define ROPE_HOOK_OBJECT_CLASS "KISKA_FastRope_helper"
#define HELPER_OBJECT_CLASS "KISKA_FastRope_helper"

private _defaultMap = createHashMap;
params [
    ["_argsMap",_defaultMap,[_defaultMap]]
];

private _paramDetails = [
    ["vehicle",{objNull},[objNull]],
    ["dropPosition",{[]},[[],objNull]],
    ["unitsToDeploy",{[]},[[],grpNull,objNull,{},""]],
    ["afterDropCode",{{}},["",{},[]]],
    ["hoverHeight",{20},[123]],
    [
        "getRopeOrigins",
        {{
            params ["_vehicle"];
            [_vehicle,"ropeOrigins"] call KISKA_fnc_fastRopeEvent_getConfigData
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
            ] call KISKA_fnc_fastRopeEvent_getConfigData;
            if (_onInitiated isNotEqualTo {}) exitWith { _onInitiated };
            
            KISKA_fnc_fastRopeEvent_onInitiatedDefault
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
            ] call KISKA_fnc_fastRopeEvent_getConfigData;
            if (_onHoverStarted isNotEqualTo {}) exitWith { _onHoverStarted };
            
            KISKA_fnc_fastRopeEvent_onHoverStartedDefault
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
_vehicle setVariable ["KISKA_fastRope_doHover",true];
_hoverHeight = _hoverHeight max MIN_HOVER_HEIGHT;
_hoverHeight = _hoverHeight min MAX_HOVER_HEIGHT;
if (_dropPosition isEqualType objNull) then {
    _dropPosition = getPosASL _dropPosition;
};
private _hoverPosition_ASL = _dropPosition vectorAdd [0,0,_hoverHeight];

private _onHoverStart = [[
    _unitsToDeployIsCode,
    _unitsToDeployFiltered,
    _ropeOrigins,
    _hoverHeight
], {
    params ["_vehicle"];

    _vehicle call KISKA_fnc_fastRopeEvent_onHoverStartedDefault;

    _thisArgs insert [0,_vehicle];
    [
        {
            params ["_vehicle"];
            
            !(alive _vehicle) OR 
            { [_vehicle] call KISKA_fnc_fastRope_canDeployRopes }
        },
        {
            params [
                "_vehicle",
                "_unitsToDeployIsCode",
                "_unitsToDeploy",
                "_ropeOrigins",
                "_hoverHeight"
            ];
            
            if (_unitsToDeployIsCode) then {
                _unitsToDeploy = [[_vehicle],_unitsToDeploy] call KISKA_fnc_callBack;
            };

            private _fries = _vehicle getVariable ["KISKA_fastRope_fries",objNull]; // TODO: abstract this away into a function maybe?
            private _deployedRopeInfo = [];
            _vehicle setVariable ["KISKA_fastRope_deployedRopeInfo",_deployedRopeInfo];
            private _ropes = _ropeOrigins apply {
                private _hook = ROPE_HOOK_OBJECT_CLASS createVehicle [0,0,0];
                _hook allowDamage false;
                if (_x isEqualType []) then {
                    _hook attachTo [_fries,_x];
                } else {
                    _hook attachTo [_fries,[0,0,0],_x];
                };

                // using dummy objects with the hooks so that the ropes
                // can unwind. Otherwise, they'd need to be attached to
                // something on the ground instantly at the time of creation
                // and be their full length.
                private _ropeAttachmentDummy = createVehicle [
                    HELPER_OBJECT_CLASS,
                    ((getPosATL _hook) vectorAdd [0,0,-1]),
                    [],
                    0,
                    "CAN_COLLIDE"
                ];
                _ropeAttachmentDummy allowDamage false;
                _ropeAttachmentDummy disableCollisionWith _vehicle; // TODO: remote exec onto where vehicle is local too? This whole function should probably be executed on where the vehicle is local tbh
                
                // TODO: why is there a ropeTop and a ropeBottom and why do we need
                // dummy objects? It seems like all you need is ropeBottom
                private _ropeTop = ropeCreate [_ropeAttachmentDummy, [0, 0, 0], _hook, [0, 0, 0], 0.5];
                private _ropeBottom = ropeCreate [_ropeAttachmentDummy, [0, 0, 0], 1];
                ropeUnwind [_ropeBottom, 30, _ropelength, false];

                [
                    _ropeTop,
                    "RopeBreak",
                    {
                        params ["_rope"];
                        _thisArgs params ["_vehicle", "_ropeAttachmentDummy"];
                        private _brokenRopeInfo = [_rope,_vehicle] call KISKA_fnc_fastRopeEvent_onRopeBreak;

                        if !(isNil "_brokenRopeInfo") then {
                            private _unitOnRope = (attachedObjects _ropeAttachmentDummy) findIf {
                                _x isKindOf "CAManBase"
                            };
                            detach _unitOnRope;
                        };
                    },
                    [_vehicle,_ropeAttachmentDummy]
                ] call CBA_fnc_addBISEventHandler;

                [
                    _ropeTop,
                    "RopeBreak",
                    {
                        params ["_rope"];
                        _thisArgs params ["_vehicle"];
                        [_rope,_vehicle] call KISKA_fnc_fastRopeEvent_onRopeBreak;
                    },
                    [_vehicle]
                ] call CBA_fnc_addBISEventHandler;

                // TODO: make hashmap?
                _deployedRopeInfo pushBack [
                    _x,
                    _ropeTop,
                    _ropeBottom,
                    _ropeAttachmentDummy,
                    _hook,
                    false,
                    false
                ];

                _ropeBottom
            };

            [
                {
                    private _indexOfRopeNotUnwound = _this findIf { !(ropeUnwound _x) };
                    _indexOfRopeNotUnwound isEqualTo -1
                },
                [[_vehicle],{
                    _thisArgs params ["_vehicle"];
            
                    // TODO:
                    // deploy units
                }],
                0.25,
                _ropes
            ] call KISKA_fnc_waitUntil;
        },
        0.25,
        _thisArgs
    ] call KISKA_fnc_waitUntil;
}];

[
    _vehicle,
    _hoverPosition_ASL,
    createHashMapFromArray [
        [
            "_shouldHoverStop",
            {
                params ["_vehicle"];
                !(_vehicle getVariable ["KISKA_fastRope_doHover",false])
            }
        ],
        ["_onHoverStart",_onHoverStart],
        [
            "_onHoverEnd",
            {
                // TODO: 
                // egress heli
            }
        ]
    ]
] call KISKA_fnc_hover;


nil
