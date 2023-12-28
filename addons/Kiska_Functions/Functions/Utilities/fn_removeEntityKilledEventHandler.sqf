/* ----------------------------------------------------------------------------
Function: KISKA_fnc_removeEntityKilledEventHandler

Description:
    Removes a killed KISKA entity event handler.

Parameters:
    0: _entity <OBJECT> - The entity to remove event from
    1: _eventId <NUMBER> - The Id of the event to remove

Returns:
    NOTHING

Examples:
    (begin example)
        [aUnit,{hint _this}] call KISKA_fnc_removeEntityKilledEventHandler;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_removeEntityKilledEventHandler";

params [
    ["_entity",objNull,[objNull]],
    ["_eventId",-1,[123]]
];


if (isNull _entity) exitWith {
    ["null _entity was passed",true] call KISKA_fnc_log;
    -1
};


private _eventHashMap = _entity getVariable "KISKA_entityKilledEventHashMap";
if (isNil "_eventHashMap") exitWith {};

_eventHashMap deleteAt _eventId;

nil
