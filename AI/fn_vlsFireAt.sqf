/* ----------------------------------------------------------------------------
Function: KISKA_fnc_vlsFireAt

Description:
	Orders VLS to fire at a target

Parameters:
	0: _launcher <OBJECT> - The VLS launcher to have the missile originate from
	1: _target <OBJECT or ARRAY> - Target to hit missile with, can also be a position (AGL)

Returns:
	BOOL

Examples:
    (begin example)

		[VLS_1,target_1] call KISKA_fnc_vlsFireAt;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_vlsFireAt"
scriptName SCRIPT_NAME;


params [
	["_launcher",objNull,[objNull]],
	["_target",objNull,[objNull,[]]]
];

// verify Params
if (isNull _launcher) exitWith {
	[SCRIPT_NAME,["Found that _launcher",_launcher,"is a null object. Exiting..."]] call KISKA_fnc_log;
	false
};
if !((typeOf _launcher) == "B_Ship_MRLS_01_F") exitWith {
	[SCRIPT_NAME,[typeOf _launcher,"is not correct type of B_Ship_MRLS_01_F. Exiting..."]] call KISKA_fnc_log;
	false
};
if (_target isEqualType objNull AND {isNull _target}) exitWith {
	[SCRIPT_NAME,["Found that _target",_target,"is a null object. Exiting..."]] call KISKA_fnc_log;
	false
};

// _target is position, create a logic to fire at
if (_target isEqualType []) then {
	private _targetPosition = _target;
	private _grp = createGroup sideLogic;

	_target = _grp createUnit ["logic",_targetPosition,[],0,"CAN_COLLIDE"];
};

// check if vehicle can recieve remote targets
if !(vehicleReceiveRemoteTargets _launcher) then {
	_launcher setVehicleReceiveRemoteTargets true;
	// return to state
	[
		{(_this select 0) setVehicleReceiveRemoteTargets false},
		[_launcher],
		3
	] call CBA_fnc_waitAndExecute;
};

private _side = side _launcher;
_side reportRemoteTarget [_target, 2]; 
_target confirmSensorTarget [_side, true]; 
_launcher fireAtTarget [_target, "weapon_vls_01"];