/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_canDeployRopes

Description:
    Sets or gets whether or not the given vehicle can deploy its ropes.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to that may deploy ropes.
    1: _setCanDeploy <NIL or BOOL> - Default: `nil` - The value to set on whether
        or not the vehicle can deploy ropes. If no value is passed (`nil`),
        the value is unchanged.

Returns:
    <BOOL> - Whether or not the vehicle can deploy it's fastropes (defaults to false)

Examples:
    (begin example)
        // allow ropes to deploy
        [VEHICLE, true] call KISKA_fnc_fastRope_canDeployRopes;
    (end)

    (begin example)
        // get current value
        private _canDeployRopes = [VEHICLE] call KISKA_fnc_fastRope_canDeployRopes;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_canDeployRopes";

#define CAN_DEPLOY_PROPERTY "KISKA_fastRope_canDeployRopes"

params [
    ["_vehicle",objNull,[objNull]],
    ["_setCanDeploy",nil,[true]]
];

if !(alive _vehicle) exitWith { false };

if (isNil "_setCanDeploy") exitWith {
    _vehicle getVariable [CAN_DEPLOY_PROPERTY,false]
};


_vehicle setVariable [CAN_DEPLOY_PROPERTY,_setCanDeploy];
_setCanDeploy
