/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addTeleportAction

Description:
    Adds a hold action to an object to teleport to a desired location.

Parameters:
    0: _objectToAddTo <OBJECT> - The object the action will be attached to
    1: _teleportPosition <ARRAY OR OBJECT> - The position to be teleported to upon completion
    2: _text <STRING> - The action text, can be structured text
    3: _conditionShow <STRING> - A string that will compile into an expression that
        evals to a boolean. True means that the action will be shown.

Returns:
    <NUMBER> - action id, -1 if not added

Examples:
    (begin example)
        [player,[0,0,0],"go to the Zero"] call KISKA_fnc_addTeleportAction;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addTeleportAction";

params [
    ["_objectToAddTo",objNull,[objNull]],
    ["_teleportPosition",[0,0,0],[objNull,[]]],
    ["_text","<t color='#FFAA00'>Teleport</t>",[""]],
    ["_conditionShow","true",[""]]
];

if (isNull _objectToAddTo) exitWith {
    ["_objectToAddTo is null"] call KISKA_fnc_log;
    -1
};

if (_teleportPosition isEqualType objNull) then {
    _teleportPosition = getPosWorld _teleportPosition;
};

[
    _objectToAddTo,
    _text,
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff1_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
    _conditionShow,
    "true",
    {},
    {},
    {
        (_this select 1) setPosWorld ((_this select 3) select 0);
    },
    {},
    [_teleportPosition],
    0.5,
    991,
    false,
    false,
    true
] call BIS_fnc_holdActionAdd;
