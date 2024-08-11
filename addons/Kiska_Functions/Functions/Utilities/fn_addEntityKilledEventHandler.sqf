/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addEntityKilledEventHandler

Description:
    Adds a killed event handler to a given entity that will persist even if the
     unit becomes remote. The order of execution is not guaranteed to be in the
     order added.

Parameters:
    0: _entity <OBJECT> - The entity to add the object to
    1: _event <CODE, STRING, or ARRAY> - The code to execute (SEE KISKA_fnc_callBack for array syntax).
        
        Parmeters:
        - 0. <OBJECT> - The killed entity
        - 1. <OBJECT> - The killer entity (vehicle or person)
        - 2. <OBJECT> - The instigator entity
        - 3. <BOOL> - same as useEffects in `setDamage` alt syntax

Returns:
    <NUMBER> - The entity killed event handler ID for the unit

Examples:
    (begin example)
        private _id = [aUnit,{hint _this}] call KISKA_fnc_addEntityKilledEventHandler;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addEntityKilledEventHandler";

params [
    ["_entity",objNull,[objNull]],
    ["_event",{},["",{},[]]]
];


if (isNull _entity) exitWith {
    ["null _entity was passed",true] call KISKA_fnc_log;
    -1
};


if (localNamespace getVariable ["KISKA_entityKilledHandlerInitialized",false]) then {
    localNamespace setVariable ["KISKA_entityKilledHandlerInitialized",true];
    addMissionEventHandler ["EntityKilled",{
        params ["_unit"];
        
        private _entityKilledEventHashMap = _unit getVariable "KISKA_entityKilledEventHashMap";
        if !(isNil "_entityKilledEventHashMap") then {
            private _codeForEvents = values _entityKilledEventHashMap;
            _codeForEvents apply {
                [_this, _x] call KISKA_fnc_callBack;
            };
        };
    }];
};


private _eventHashMap = _entity getVariable "KISKA_entityKilledEventHashMap";
if (isNil "_eventHashMap") then {
    _eventHashMap = createHashMap;
    _entity setVariable ["KISKA_entityKilledEventHashMap",_eventHashMap];
};

private _id = ["KISKA_entityKilledIdCount",_entity] call KISKA_fnc_idCounter;
_eventHashMap set [_id,_event];


_id
