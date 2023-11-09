/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_fastRope

Description:
    Sends a vehicle to a given point and fastropes the given units from the helicopter.

    Pilots should ideally be placed in "CARELESS" behaviour when around enemies.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _dropPosition <ARRAY or OBJECT> - The positionASL to drop the units off at; Z coordinate
        matters
    2: _unitsToDeploy <CODE, STRING, ARRAY, OBJECT[], GROUP, or OBJECT> - An array of units to drop from the _vehicle,
        Or code that will run once the helicopter has reached the drop point that must return an array of object
        (see KISKA_fnc_callBack for examples)

        Parameters:
        - 0: _vehicle - The drop vehicle

    3: _afterDropCode <CODE, STRING or ARRAY> - Code to execute after the drop is complete, see KISKA_fnc_callBack
        
        Parameters:
        - 0: _vehicle - The drop vehicle

    4: _hoverHeight <NUMBER> - The height the helicopter should hover above the drop position
        while units are fastroping. Max is 28, min is 5
    5: _ropeOrigins <ARRAY> - An array of: either relative (to the vehicle) attachment
        points for the ropes and/or memory points to attachTo

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
        ] call KISKA_fnc_ACE_fastRope;
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
        ] call KISKA_fnc_ACE_fastRope;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_fastRope";

#define MIN_HOVER_HEIGHT 5
#define MAX_HOVER_HEIGHT 28
#define HOVER_INTERVAL 0.05

if !(["ace_fastroping"] call KISKA_fnc_isPatchLoaded) exitWith {
    ["ace_fastroping is required for this function",true] call KISKA_fnc_log;
    nil
};

params [
    ["_vehicle",objNull,[objNull]],
    ["_dropPosition",[],[[],objNull]],
    ["_unitsToDeploy",[],[[],grpNull,objNull,{},""]],
    ["_afterDropCode",{},["",{},[]]],
    ["_hoverHeight",20,[123]],
    ["_ropeOrigins",[],[[]]]
];


/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if (isNull _vehicle) exitWith {
    ["_vehicle is null!",true] call KISKA_fnc_log;
    nil
};

if (_ropeOrigins isEqualTo []) then {
    private _config = configOf _vehicle;
    _ropeOrigins = getArray (_config >> "ace_fastroping_ropeOrigins");
};

[_vehicle] call ace_fastroping_fnc_equipFRIES;
// some vehicles may fail ace_fastroping_fnc_canPrepareFRIES if not called with ace_fastroping_fnc_equipFRIES first
private _canEquipFRIES = [_vehicle] call ace_fastroping_fnc_canPrepareFRIES;
if (
    !(_canEquipFRIES) AND
    (_ropeOrigins isEqualTo [])
) exitWith {
    [
        [typeOf _vehicle," is not configured for ACE FRIES system, can't fastrope, or no _ropeOrigins were passed"],
        true
    ] call KISKA_fnc_log;

    nil
};

if (_dropPosition isEqualType objNull) then {
    _dropPosition = getPosASL _dropPosition;
};

_hoverHeight = _hoverHeight max MIN_HOVER_HEIGHT;
_hoverHeight = _hoverHeight min MAX_HOVER_HEIGHT;


/* ----------------------------------------------------------------------------
    Verify _unitsToDeploy
---------------------------------------------------------------------------- */
if (_unitsToDeploy isEqualTo []) exitWith {
    ["_unitsToDeploy is empty",true] call KISKA_fnc_log;
    false
};

if (_unitsToDeploy isEqualTypeAny [objNull,grpNull] AND {isNull _unitsToDeploy}) exitWith {
    ["_unitsToDeploy isNull",true] call KISKA_fnc_log;
    false
};

if (_unitsToDeploy isEqualType grpNull) then {
    _unitsToDeploy = units _unitsToDeploy;
};

if (_unitsToDeploy isEqualType objNull) then {
    _unitsToDeploy = [_unitsToDeploy];
};

private _unitsToDeployFiltered = [];
private _unitsToDeployIsCode = 
    (_unitsToDeploy isEqualTypeParams [[],{}]) OR 
    (_unitsToDeploy isEqualTypeParams [[],""]) OR
    _unitsToDeploy isEqualType "" OR 
    _unitsToDeploy isEqualType {};

if (_unitsToDeploy isEqualType [] AND !_unitsToDeployIsCode) then {
    _unitsToDeploy apply {
        if (_x isEqualType grpNull) then {
            _unitsToDeployFiltered append (units _x);
        };

        if (_x isEqualType objNull) then {
            _unitsToDeployFiltered pushBackUnique _x;
        };
    };
};

if (_unitsToDeployFiltered isEqualTo []) then {
    _unitsToDeployFiltered = _unitsToDeploy;
};


/* ----------------------------------------------------------------------------
    Prepare FRIES
---------------------------------------------------------------------------- */
_vehicle setVariable ["ACE_Rappelling",true];
private _hoverPosition_ASL = _dropPosition vectorAdd [0,0,_hoverHeight];

[
    _vehicle,
    _hoverPosition_ASL,
    {
        params ["_vehice"];
        !isNil {_vehicle getVariable "ACE_Rappelling"}
    }
] call KISKA_fnc_hover;

/* ----------------------------------------------------------------------------
    Monitor drop for completion
---------------------------------------------------------------------------- */
[
    {
        params ["_vehicle","_hoverPosition_ASL"];

        if (!alive _vehicle) exitWith {true};
        if (!alive (currentPilot _vehicle)) exitWith {true};
        private _currentVehiclePosition_ASL = getPosASLVisual _vehicle;

        (speed _vehicle < (2.5 * 3.6))
        AND
        {
            (_hoverPosition_ASL distance2d _currentVehiclePosition_ASL) < 25
        }
        AND
        {
            (_hoverPosition_ASL vectorDiff _currentVehiclePosition_ASL) select 2 < 25
        }
    },
    {
        params [
            "_vehicle",
            "",
            "_unitsToDeploy",
            "_afterDropCode",
            "_ropeOrigins",
            "_unitsToDeployIsCode"
        ];

        if (!(alive _vehicle) OR !(alive (currentPilot _vehicle))) exitWith {};
            
        if (_unitsToDeployIsCode) then {
            _unitsToDeploy = [
                [_vehicle],
                _unitsToDeploy
            ] call KISKA_fnc_callBack;
        };

        [_vehicle, _unitsToDeploy, _ropeOrigins] call KISKA_fnc_ACE_deployFastRope;

        [_vehicle,_afterDropCode] spawn {
            params ["_vehicle","_afterDropCode"];

            waitUntil {
                sleep 1;
                ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isNotEqualTo [])
            };

            waitUntil {
                sleep 1;
                ((_vehicle getVariable ["ace_fastroping_deployedRopes", []]) isEqualTo [])
            };

            _vehicle setVariable ["ACE_Rappelling",nil];
            
            [
                [_vehicle],
                _afterDropCode
            ] call KISKA_fnc_callBack;
        };
    },
    0.5
    [_vehicle,_hoverPosition_ASL,_unitsToDeployFiltered,_afterDropCode,_ropeOrigins,_unitsToDeployIsCode]
] call KISKA_fnc_waitUntil;
