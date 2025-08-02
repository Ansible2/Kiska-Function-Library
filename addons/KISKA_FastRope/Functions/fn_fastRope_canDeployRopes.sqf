// TODO: header comment
scriptName "KISKA_fnc_fastRope_canDeployRopes";

#define CAN_DEPLOY_PROPERTY "KISKA_fastRope_canDeployRopes"

params [
    ["_vehicle",objNull,[objNull]],
    ["_setCanDeploy",nil,[true]]
];

if !(alive _vehicle) exitWith { false };

if (isNil "_setCanDeploy") exitWith {
    _vehicle getVariable [CAN_DEPLOY_PROPERTY,true]
};


_vehicle setVariable [CAN_DEPLOY_PROPERTY,_setCanDeploy];
_setCanDeploy
