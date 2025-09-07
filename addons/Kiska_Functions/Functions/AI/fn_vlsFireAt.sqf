/* ----------------------------------------------------------------------------
Function: KISKA_fnc_vlsFireAt

Description:
    Orders VLS to fire at a target. Projectile will follow terrain.

Parameters:
    0: _launcher <OBJECT> - The VLS launcher to have the missile originate from
    1: _target <OBJECT or ARRAY> - Target to hit missile with, can also be a position (AGL)

Returns:
    NOTHING

Examples:
    (begin example)
        [VLS_1,target_1] call KISKA_fnc_vlsFireAt;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_vlsFireAt";

#define VLS_WEAPON "weapon_vls_01"
#define VLS_CLASS "B_Ship_MRLS_01_F"
#define DUMMY_TARGET_CLASS "Sign_Arrow_Large_Blue_F"

params [
    ["_launcher",objNull,[objNull]],
    ["_target",objNull,[objNull,[]]]
];

// verify Params
if (isNull _launcher) exitWith {
    [["Found that _launcher ",_launcher," is a null object. Exiting..."],true] call KISKA_fnc_log;
    nil
};
if !(_launcher isKindOf VLS_CLASS) exitWith {
    [[typeOf _launcher," is not a kind of of B_Ship_MRLS_01_F. Exiting..."],true] call KISKA_fnc_log;
    nil
};
if !(local _launcher) exitWith {
    [["Launcher: ",_launcher," is not local to the this machine!"],true] call KISKA_fnc_log;
    nil
};
if ((_target isEqualType objNull) AND {isNull _target}) exitWith {
    [["Found that _target ",_target," is a null object. Exiting..."],true] call KISKA_fnc_log;
    nil
};


// _target is position, create a logic to fire at
if (_target isEqualType []) then {
    private _targetPosition = _target;
    _target = DUMMY_TARGET_CLASS createVehicle [0,0,0];

    [_target] remoteExecCall ["hideObjectGlobal",2];
    _target setPosASL (AGLToASL _targetPosition);

    [
        _launcher,
        "fired",
        {
            params ["_launcher", "", "", "", "", "", "_projectile"];
            _thisArgs params ["_target"];

            [
                [[_projectile],{
                    _thisArgs params ["_projectile"];
                    !(alive _projectile)
                }],
                [[_target],{
                    _thisArgs params ["_target"];
                    deleteVehicle _target;
                }],
                5
            ] call KISKA_fnc_waitUntil;

            _launcher removeEventHandler ["fired", _thisID];
        },
        [_target]
    ] call KISKA_fnc_CBA_addBISEventHandler;
};

// check if vehicle can recieve remote targets
if !(vehicleReceiveRemoteTargets _launcher) then {
    _launcher setVehicleReceiveRemoteTargets true;
    // return to state
    [
        {(_this select 0) setVehicleReceiveRemoteTargets false},
        [_launcher],
        3
    ] call KISKA_fnc_CBA_waitAndExecute;
};

private _side = side _launcher;
_side reportRemoteTarget [_target, 2];
_target confirmSensorTarget [_side, true];
_launcher fireAtTarget [_target, VLS_WEAPON];
