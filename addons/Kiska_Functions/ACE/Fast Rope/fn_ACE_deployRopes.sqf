/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_deployRopes

Description:
    An edit of ace_fastroping_fnc_deployRopes to allow for custom drop of units.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from

Returns:
	NOTHING

Examples:
    (begin example)
		[

		] call KISKA_fnc_ACE_deployRopes;
    (end)

Author(s):
    BaerMitUmlaut,
	Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_deployRopes";


#if __has_include("\z\ace\addons\fastroping\functions\script_component.hpp")
    #include "\z\ace\addons\fastroping\functions\script_component.hpp"

params ["_vehicle", ["_player", objNull], ["_ropeClass", ""]];

TRACE_3("deployRopes",_vehicle,_player,_ropeClass);

private _config = configOf _vehicle;

private _ropeOrigins = getArray (_config >> QGVAR(ropeOrigins));
private _deployedRopes = _vehicle getVariable [QGVAR(deployedRopes), []];
private _hookAttachment = _vehicle getVariable [QGVAR(FRIES), _vehicle];

private _ropeLength = getNumber (configfile >> "CfgWeapons" >> _ropeClass >> QEGVAR(logistics_rope,length));

if (_ropeLength <= 0) then {
    _ropeLength = DEFAULT_ROPE_LENGTH;
};

TRACE_3("",_ropeClass,_ropeLength,GVAR(requireRopeItems));

if (GVAR(requireRopeItems) && {_ropeClass != ""}) then {
    if (_ropeClass in (_player call EFUNC(common,uniqueItems))) then {
        _player removeItem _ropeClass;
    } else {
        _vehicle removeItem _ropeClass;
    };
};


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


    /*
        NOTICE:
        Strange thing, when the helicopter is completely filled, and
        a player is in the vehicle and NOT all units are part of the same group.

        When the helicopter reaches the drop position and the _dummy is created,
        it seems to push out the top most unit before the ropes are fully deployed.

        Other strange behaviour occurs with the heli too, but you can also change
        the _dummy spawn position (_origin vectorAdd [0, 0, -1]) to say [0,0,0]
        to also mitigate this.

        No idea what this means though...
    */
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
false

#endif
