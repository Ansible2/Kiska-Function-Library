/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setWaypointExecStatement

Description:
    Sets the (execution) statement of a given waypoint using an interface that 
     allows for the passing of arguments.

    This statement will only be executed on the machine where it was added.

    Be aware that this will create variables on the provided waypoint's group. 
     If a waypoint is deleted, the variable on the group will still remain.

Parameters:
    0: _waypoint <WAYPOINT> - Default: `[]` - The waypoint you would like to the execution
        statement of.
    1: _statement <CODE, STRING, or ARRAY> - Default: `{}` - Code that executes once the given waypoint
        is complete (see `KISKA_fnc_callBack` for examples).

        Parameters:
        - 0: <GROUP> - The group the waypoint belongs to
        - 1: <OBJECT> - The group leader for the group the waypoint belongs to
        - 2: <OBJECT[]> - The units of the group that own the waypoint

    3: _existingId <STRING> - Default: `""` - If updating an existing waypoint statement, provide the
        id that was previously returned.

Returns:
    <STRING> - The id of the waypoint statment that can be used to update an existing statement

Examples:
    (begin example)
        private _waypoint = myGroup addWaypoint [position player, 0];
        private _id = [
            _waypoint,
            { hint str _this; }
        ] call KISKA_fnc_setWaypointExecStatement
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_setWaypointExecStatement";

params [
    ["_waypoint",[],[[]]],
    ["_statement",{},[{},[],""]],
    ["_existingId","",[""]]
];

private _group = _waypoint param [0,grpNull];
if (isNull _group) exitWith {
    ["Provided waypoint had null or missing group",true] call KISKA_fnc_log;
    nil
};

private _id = _existingId;
if (_id isEqualTo "") then {
    _id = ["KISKA_waypointStatement"] call KISKA_fnc_generateUniqueId;
};

_group setVariable [_id,_statement];

private _idStringified = [_id] call KISKA_fnc_str;
private _waypointStatementString = format [
    "
        private _group = group this; 
        private _callBack = _group getVariable [%1,{}];
        if (_callBack isNotEqualTo {}) then {
            [[_group,this,thisList],_callBack] call KISKA_fnc_callBack;
            _group setVariable [%1,nil];
        };
    ",
    _idStringified
];
_waypoint setWaypointStatements ["true",_waypointStatementString];


_id
