/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_deployRopes

Description:
    An edit of ace_fastroping_fnc_deployRopes to allow for custom drop of units.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from
    1: _ropeOrigins <ARRAY> - An array of either relative (to the vehicle) attachment
        points for the ropes or a memory point to attachTo

Returns:
	NOTHING

Examples:
    (begin example)
		[heli] call KISKA_fnc_ACE_deployRopes;
    (end)

Author(s):
    BaerMitUmlaut,
	Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_deployRopes";

#if __has_include("\z\ace\addons\fastroping\functions\script_component.hpp")
    #include "\z\ace\addons\fastroping\functions\script_component.hpp"

params [
    ["_vehicle",objNull,[objNull]],
    ["_ropeOrigins",[],[[]]]
];


private _config = configOf _vehicle;
private _deployedRopes = _vehicle getVariable [QGVAR(deployedRopes), []];
private _hookAttachment = _vehicle getVariable [QGVAR(FRIES), _vehicle];
private _ropeLength = DEFAULT_ROPE_LENGTH;

_ropeOrigins apply {
    private _ropeOrigin = _x;
    private _hook = QGVAR(helper) createVehicle [0, 0, 0];
    _hook allowDamage false;
    if (_ropeOrigin isEqualType []) then {
        _hook attachTo [_hookAttachment, _ropeOrigin];
    } else {
        _hook attachTo [_hookAttachment, [0, 0, 0], _ropeOrigin];
    };

    private _origin = getPosATL _hook;
    private _dummy = createVehicle [QGVAR(helper), _origin vectorAdd [0, 0, -1], [], 0, "CAN_COLLIDE"];
    _dummy allowDamage false;
    _dummy disableCollisionWith _vehicle;

    private _ropeTop = ropeCreate [_dummy, [0, 0, 0], _hook, [0, 0, 0], 0.5];
    private _ropeBottom = ropeCreate [_dummy, [0, 0, 0], 1];
    ropeUnwind [_ropeBottom, 30, _ropelength, false];

    _ropeTop addEventHandler ["RopeBreak", {[_this, "top"] call FUNC(onRopeBreak)}];
    _ropeBottom addEventHandler ["RopeBreak", {[_this, "bottom"] call FUNC(onRopeBreak)}];

    //deployedRopes format: attachment point, top part of the rope, bottom part of the rope, attachTo helper object, occupied, broken
    _deployedRopes pushBack [_ropeOrigin, _ropeTop, _ropeBottom, _dummy, _hook, false, false];

    false
};

_vehicle setVariable [QGVAR(deployedRopes), _deployedRopes, true];
_vehicle setVariable [QGVAR(deploymentStage), 3, true];
_vehicle setVariable [QGVAR(ropeLength), _ropeLength, true];

#else
["ACE #include for \z\ace\addons\fastroping\functions\script_component.hpp not found!",true] call KISKA_fnc_log;
nil

#endif
