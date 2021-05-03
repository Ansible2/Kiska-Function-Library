/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setTaskComplete

Description:
	Used to quickly set task to complete even if it is nonexistent when completed.

Parameters:
	0: _taskID <STRING or ARRAY> - The ID to attach to the task, can also be formated as an array [task name, parent task name]
    1: _description <STRING or ARRAY> - Task texts in the format ["description", "title", "marker"] or CfgTaskDescriptions class
    2: _type <STRING> - Task type as defined in the CfgTaskTypes
    3: _priority <NUMBER> - Task priority (when automatically selecting a new current task, higher priority is selected first)
    4: _showNotification <BOOL> - Show pop up of completion
    5: _destination <OBJECT, ARRAY, or STRING> - Task destination (use [object,true] to always show marker on the object, even if player doesn't 'knowsAbout' it)
    6: _owner <BOOL, SIDE, GROUP, OBJECT, ARRAY, or STRING> - Task owner(s)
    7: _visibleIn3D <BOOL> - Task always visible in 3D

Returns:
	BOOL

Examples:
    (begin example)
		["mytaskID",["this is a task","My Task",""]] call KISKA_fnc_setTaskComplete;
    (end)

Author(s):
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_setTaskComplete";

params [
    ["_taskID","",["",[]]],
    ["_description","",["",[]]],
    ["_type","default",[""]],
    ["_priority",1,[1]],
    ["_showNotification",true,[false]],
    ["_destination",objNull,[objNull,[],""]],
    ["_owner",true,[true,sideunknown,grpnull,objnull,[],""]],
    ["_visibleIn3D",false,[true]]
];

private _taskID_parent = "";

if (_taskID isEqualType []) then {
    _taskID_parent = _taskID select 1;
    _taskID = _taskID select 0;
};

if ([_taskID] call BIS_fnc_taskExists) then {
    [_taskID,"SUCCEEDED",_showNotification] call BIS_fnc_taskSetState;
} else {
    [_owner,[[_taskID,_taskID_parent],_taskID] select (_taskID_parent isEqualTo ""), _description, _destination, "SUCCEEDED", _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
};
