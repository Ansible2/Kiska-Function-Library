/* ----------------------------------------------------------------------------
Function: KISKA_fnc_netId

Description:
    Gets a "netId" for singleplayer and a netId when in multiplayer.

Parameters:
    0: _entity <OBJECT or GROUP> - The group or object to get the id of

Returns:
    <STRING> - The Id of the entity

Examples:
    (begin example)
        _id = [player] call KISKA_fnc_netId;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_netId";

if (canSuspend) exitWith {
    [
        {_this call KISKA_fnc_netId},
        _this
    ] call CBA_fnc_directCall;
};

params [
    ["_entity",objNull,[grpNull,objNull]]
];

if (isNull _entity) exitWith {
    ["_entity is null!",true] call KISKA_fnc_log
    -1
};



if (isMultiplayer) exitWith {netId _entity};
private _id = _entity getVariable ["KISKA_netId",""];
if (_id isNotEqualTo "") exitWith {_id};


// if object is not saved
private _counter = localNamespace getVariable ["KISKA_netId_counter",0];
localNamespace setVariable ["KISKA_netId_counter",_counter + 1];
_id = ["0:",_counter] joinString "";
_entity setVariable ["KISKA_netId",_id];

// create map if needed
private _map = localNamespace getVariable "KISKA_objectNetId_map";
if (isNil "_map") then {
    _map = createHashMap;
    localNamespace setVariable ["KISKA_objectNetId_map",_map];
};


if !(_id in _map) then {
    _map set [_id,_entity];
};


_id
