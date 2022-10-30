/* ----------------------------------------------------------------------------
Function: KISKA_fnc_endTask

Description:
	Either completes, cancels, or ends a task and calls the task's onComplete
     event if it is defined in KISKA_cfgTasks.

    Meant to be paired with KISKA_fnc_createTaskFromConfig.

Parameters:
	0: _taskId <STRING> - The task id/KISKA_cfgTasks class name
    1: _state <NUMBER> - 0 for SUCCEEDED, 1 for FAILED, 2 for CANCELED
    2: _notify <BOOL> - Should a nortification be shown
    4: _owner <BOOL, OBJECT, GROUP, SIDE, or ARRAY> - Whom the task is assigned to
        (this is only needed in the event that the task is ended without it having been created)

Returns:
	<BOOL> - Whether or not the state of the task was set to the desired one

Examples:
    (begin example)
		private _taskIsSucceeded = ["mytaskID",0] call KISKA_fnc_endTask;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_endTask";

#define STATE_SUCCEEDED 0
#define STATE_FAILED 1
#define STATE_CANCELED 2

params [
    ["_taskId","",["",configNull]],
    ["_state",0,[123]],
    ["_notify",configNull],
    ["_owner",true,[true,objNull,grpNull,sideUnknown,[]]]
];


if (isMultiplayer AND {!isServer}) exitWith {
    ["Not Server, remoteExecuting on server..."] call KISKA_fnc_log;
    _this remoteExecCall ["KISKA_fnc_endTask",2];
    ""
};


private _config = _taskId;
if (_taskId isEqualType "") then {
    _config = missionConfigFile >> "KISKA_cfgTasks" >> _taskId;
} else {
    _taskId = configName _config;
};

private _taskHasClass = isClass _config;
// if you want config default value
if (_notify isEqualTo configNull) then {
    if (_taskHasClass) then {
        // if config entry for notifyOnComplete is present
        if !(isNull (_config >> "notifyOnComplete")) then {
            _notify = true;

        } else {
            _notify = [_config >> "notifyOnComplete"] call BIS_fnc_getCfgDataBool;

        };

    } else {
        _notify = true;

    };
};

switch _state do {
    case STATE_SUCCEEDED:{
        _state = "SUCCEEDED";
    };

    case STATE_FAILED:{
        _state = "FAILED";
    };

    case STATE_CANCELED:{
        _state = "CANCELED";
    };
    default {};
};


private _taskSet = false;
if ([_taskId] call BIS_fnc_taskExists) then {
    _taskSet = [_taskId,_state,_notify] call BIS_fnc_taskSetState;

    if (_taskHasClass) then {
        private _completeEvent = getText(_config >> "onComplete");

        if (_completeEvent isNotEqualTo "") then {
            [_taskId,_config,_state] call (compile _completeEvent);
        };
    };

} else {
    [
        _config,
        _owner,
        _state,
        configNull,
        configNull,
        _notify
    ] call KISKA_fnc_createTaskFromConfig;

    _taskSet = true;
};


_taskSet
