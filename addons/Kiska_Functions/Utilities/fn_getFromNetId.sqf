/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getFromNetId

Description:
    Gets an object or group from a netId.

Parameters:
	0: _id <STRING> - The id of the object
	1: _fromObject <BOOL> - false for getting object, true for group

Returns:
	<OBJECT or GROUP> - The Id of the entity

Examples:
    (begin example)
		_entity = ["0:0"] call KISKA_fnc_netId;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getFromNetId";

params [
    ["_id","",[""]],
    ["_fromObject",false,[false]]
];

if (!isMultiplayer) exitWith {
    // create map if needed
    private _map = localNamespace getVariable "KISKA_objectNetId_map";
    if (isNil "_map") then {
        _map = createHashMap;
        localNamespace setVariable ["KISKA_objectNetId_map",_map];
    };

    _map getOrDefault [_id, [grpNull,objNull] select _fromObject];
};

if (_fromObject) then {
    objectFromNetId _id;

} else {
    groupFromNetId _id;

};
