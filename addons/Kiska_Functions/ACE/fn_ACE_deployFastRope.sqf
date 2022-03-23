#define KISKA_SCRIPT_COMPONENT "\z\ace\addons\fastroping\functions\script_component.hpp"
#if __has_include(KISKA_SCRIPT_COMPONENT)
    #include KISKA_SCRIPT_COMPONENT
#endif
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_deployFastRope

Description:
    An edit of ace_fastroping_fnc_deployAI to allow for custom drop of units.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _unitsToDeploy <ARRAY> - An array of units to drop from the _vehicle.
        This function has a destructive effect on this array (deletes entries)

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

params [
    ["_vehicle", objNull, [objNull]],
    ["_unitsToDeploy",[],[[]]]
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
if (_configEnabled isEqualTo 0) exitWith {
    [["Fastrope not configured for vehicle: ", getText(_config >> "DisplayName")],true] call KISKA_fnc_log;
    nil
};

if (_configEnabled isEqualTo 2 AND (isNull (_vehicle getVariable [QGVAR(FRIES), objNull]))) exitWith {
    [[getText(_config >> "DisplayName")," requires a FRIES for fastroping but has not been equipped with one"],true] call KISKA_fnc_log;
    nil
};


/* ----------------------------------------------------------------------------
    Deploy Ropes
---------------------------------------------------------------------------- */
private  _deployTime = 0;
if (getText (_config >> QGVAR(onPrepare)) isNotEqualTo "") then {
    _deployTime = [_vehicle] call (missionNamespace getVariable (getText (_config >> QGVAR(onPrepare))));
};

[FUNC(deployRopes), _vehicle, _deployTime] call CBA_fnc_waitAndExecute;

(driver _vehicle) disableAI "MOVE";


/* ----------------------------------------------------------------------------
    Drop function
---------------------------------------------------------------------------- */
DFUNC(deployAIRecursive) = {
    params ["_vehicle", "_unitsToDeploy"];

    private _unit = _unitsToDeploy deleteAt 0;
    if (_unit)
    unassignVehicle _unit;
    [_unit, _vehicle] call FUNC(fastRope);

    if (_unitsToDeploy isNotEqualTo []) then {
        [
            {
                [
                    {
                        params ["_vehicle"];
                        private _deployedRopes = _vehicle getVariable [QGVAR(deployedRopes), []];
                        ({!(_x select 5)} count (_deployedRopes)) > 0
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
                [_this, "KISKA_ACE_fastRopeFinished", [_this], false] call BIS_fnc_callScriptedEventHandler;
                (driver _this) enableAI "MOVE";
            },
            _vehicle
        ] call CBA_fnc_waitUntilAndExecute;

    };
};

[FUNC(deployAIRecursive), [_vehicle, _unitsToDeploy], _deployTime + 4] call CBA_fnc_waitAndExecute;
