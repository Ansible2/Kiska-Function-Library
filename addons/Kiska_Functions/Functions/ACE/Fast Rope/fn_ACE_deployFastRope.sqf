/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_deployFastRope

Description:
    An edit of the ACE function to allow for custom drop of units.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _unitsToDeploy <ARRAY> - An array of units to drop from the _vehicle.
        This function has a destructive effect on this array (deletes entries)
    2: _ropeOrigins <ARRAY> - An array of either relative (to the vehicle) attachment
        points for the ropes or a memory point to attachTo

Returns:
    NOTHING

Examples:
    (begin example)
        [
            _vehicle,
            (fullCrew [_vehicle,"cargo"]) apply {
                _x select 0
            }
        ] call KISKA_fnc_ACE_deployFastRope;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_deployFastRope";

#if __has_include("\z\ace\addons\fastroping\script_component.hpp")
    #include "\z\ace\addons\fastroping\script_component.hpp"
    #define DEFAULT_ROPE_DEPLOY_TIME 4


if !(["ace_fastroping"] call KISKA_fnc_isPatchLoaded) exitWith {
    ["ace_fastroping is required for this function",true] call KISKA_fnc_log;
    nil
};

params [
    ["_vehicle", objNull, [objNull]],
    ["_unitsToDeploy",[],[[]]],
    ["_ropeOrigins",[],[[]]]
];

/* ----------------------------------------------------------------------------
    Verify Params
---------------------------------------------------------------------------- */
if (isNull _vehicle || {!(_vehicle isKindOf "Helicopter")}) exitWith {
    ["_vehicle is invalid or null",true] call KISKA_fnc_log;
    nil
};

if (_unitsToDeploy isEqualTo []) exitWith {
    ["_unitsToDeploy is empty!", true] call KISKA_fnc_log;
    nil
};

private _config = configOf _vehicle;
private _configEnabled = getNumber (_config >> QGVAR(enabled));
if (_configEnabled isEqualTo 0 AND (_ropeOrigins isEqualTo [])) exitWith {
    [
        [
            "Fastrope not configured for vehicle: ",
            getText(_config >> "DisplayName"),
            " or no rope origins were passed"
        ],
        true
    ] call KISKA_fnc_log;

    nil
};

if (
    (_configEnabled isEqualTo 2) AND
    (isNull (_vehicle getVariable [QGVAR(FRIES), objNull]))
) exitWith {
    [[getText(_config >> "DisplayName")," requires a FRIES for fastroping but has not been equipped with one"],true] call KISKA_fnc_log;
    nil
};

/* ----------------------------------------------------------------------------
    Deploy Ropes
---------------------------------------------------------------------------- */
private _onPrepareFunctionName = getText (_config >> QGVAR(onPrepare));
if (_onPrepareFunctionName isEqualTo "") then {
    _onPrepareFunctionName = "ace_fastroping_onPrepare";
};
private _onPrepareFunction = missionNamespace getVariable _onPrepareFunctionName;
// overwrite if needed
_onPrepareFunction = _vehicle getVariable ["KISKA_ACE_onPrepareFastrope", _onPrepareFunction];
private _deployTime = [[_vehicle],_onPrepareFunction] call KISKA_fnc_callBack;
if (isNil "_deployTime" OR {!(_deployTime isEqualType 123)}) then {
    _deployTime = DEFAULT_ROPE_DEPLOY_TIME;
};

[_vehicle,_ropeOrigins] call KISKA_fnc_ACE_deployRopes;

(driver _vehicle) disableAI "MOVE";


/* ----------------------------------------------------------------------------
    Drop function
---------------------------------------------------------------------------- */
DFUNC(deployAIRecursive) = {
    params ["_vehicle", "_unitsToDeploy"];

    private _unit = _unitsToDeploy deleteAt 0;
    if (alive _unit AND (_unit in _vehicle)) then {
        unassignVehicle _unit;
        [_unit] allowGetIn false;
        [_unit, _vehicle] call FUNC(fastRope);

    } else {
        [["Found unit that was either not alive or not in vehicle: ", _vehicle],false] call KISKA_fnc_log;

    };

    if (_unitsToDeploy isNotEqualTo []) then {
        [
            {
                [
                    {
                        params ["_vehicle"];
                        private _deployedRopes = _vehicle getVariable [QGVAR(deployedRopes), []];
                        ({!(_x select 5)} count _deployedRopes) > 0
                    },
                    FUNC(deployAIRecursive),
                    _this
                ] call CBA_fnc_waitUntilAndExecute;
            },
            [_vehicle, _unitsToDeploy],
            1
        ] call CBA_fnc_waitAndExecute;

    } else {
        [
            {
                private _deployedRopes = _this getVariable [QGVAR(deployedRopes), []];
                ({_x select 5} count (_deployedRopes)) isEqualTo 0
            },
            {
                [_this] call FUNC(cutRopes);
                (driver _this) enableAI "MOVE";
            },
            _vehicle
        ] call CBA_fnc_waitUntilAndExecute;

    };
};

[
    FUNC(deployAIRecursive),
    [_vehicle, _unitsToDeploy],
    _deployTime
] call CBA_fnc_waitAndExecute;


#else
["ACE #include for \z\ace\addons\fastroping\functions\script_component.hpp not found!",true] call KISKA_fnc_log;
nil

#endif
