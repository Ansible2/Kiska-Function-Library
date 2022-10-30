/* ----------------------------------------------------------------------------
Function: KISKA_fnc_createTaskFromConfig

Description:
	Creates a task from a config entry. Config should be placed inside KISKA_cfgTasks,
     just the string is needed to reference the config entry.

    Parameters from index 2 onwards will accept configNull as an alias for retrieving
     the configed value of the param if it is not changed (see example 2)

Parameters:
	0: _config <STRING or CONFIG> - The config entry to convert to a task
    1: _owner <BOOL, OBJECT, GROUP, SIDE, or ARRAY> - Whom the task is assigned to

    (OPTIONAL)
    2: _taskState <STRING, BOOL, or configNull> - The state of the task, will overwrite config entry
    3: _destination <OBJECT, ARRAY, or configNull> The position of the task. Array can be either
        [x,y,z] or [OBJECT,precision] (see setSimpleTaskTarget). The destination can be a configed array, however, this will
        overwrite it if provided here.
    4: _type <STRING or configNull> - The task type (defined in CfgTaskTypes)
    5: _notifyOnCreate <BOOL or configNull> - Should a notification pop up when the task is created?
    6: _visibleIn3D <BOOL or configNull> - Show a 3D task icon

Returns:
	<STRING> - Created Task Id

Examples:
    (begin example)
        // simple task from config
        [missionConfigFile >> MyTasks >> "someTaskClass",true] call KISKA_fnc_createTaskFromConfig;
    (end)

    (begin example)
		[
            "someTaskClass", // will search in missionConfigFile >> "KISKA_cfgTasks"
            true,
            "ASSIGNED",
            configNull, // get configed destination value
            "ATTACK"
        ] call KISKA_fnc_createTaskFromConfig;
    (end)

Authors:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_createTaskFromConfig";

#define GET_CFG_TEXT(entry) getText(_config >> entry)
#define GET_CFG_NUMBER(entry) getNumber(_config >> entry)
#define GET_CFG_BOOL(entry) [_config >> entry] call BIS_fnc_getCfgDataBool
#define GET_CFG_ARRAY(entry) getArray(_config >> entry)
#define CHECK_VAR(gvar,taskState) if (missionNamespace getVariable [gvar,false]) exitWith {_setTaskState = taskState; true};

params [
    ["_config","",[configNull,""]],
    ["_owner",true,[true,objNull,grpNull,sideUnknown,[]]],
    ["_taskState",configNull,["",true,configNull]],
    ["_destination",configNull,[objNull,[],configNull]],
    ["_type",configNull,["",configNull]],
    ["_notifyOnCreate",configNull,[configNull,true]],
    ["_visibleIn3D",configNull,[configNull,true]]
];


/* ----------------------------------------------------------------------------
    Get Config Values
---------------------------------------------------------------------------- */
if (_config isEqualType "") then {
    _config = (missionConfigFile >> "KISKA_cfgTasks" >> _config);
};

if (_config isEqualTo configNull) exitWith {
    ["_config is null!",true] call KISKA_fnc_log;
    ""
};

private _taskId = configName _config;
if ([_taskId] call BIS_fnc_taskExists) exitWith {
    [["The task with ID: ",_taskId," already exists"],false] call KISKA_fnc_log;
    ""
};

if (_taskState isEqualTo configNull) then {
    _taskState = GET_CFG_TEXT("defaultState");

    if (_taskState isEqualTo "") then {
        _taskState = "CREATED";
    };
};

if (_destination isEqualTo configNull) then {

    private _compiledDestination = GET_CFG_TEXT("compiledDestination");
    if (_compiledDestination isNotEqualTo "") then {
        _destination = call (compileFinal _compiledDestination);
    };

    if (isNull _destination) then {
        _destination = GET_CFG_ARRAY("destination");

        if (_destination isEqualTo []) then {
            _destination = objNull;
        };
    };
};

if (_type isEqualTo configNull) then {
    _type = GET_CFG_TEXT("type");

    if (_type isEqualTo "") then {
        _type = "DEFAULT";
    };
};

if (_notifyOnCreate isEqualTo configNull) then {
    if !(isNull (_config >> "notifyOnCreate")) then {
        _notifyOnCreate = true;
    } else {
        _notifyOnCreate = GET_CFG_BOOL("notifyOnCreate");
    };
};

if (_visibleIn3D isEqualTo configNull) then {
    _visibleIn3D = GET_CFG_BOOL("visibleIn3D");
};


private _taskTitle = GET_CFG_TEXT("title");
private _taskDescription = GET_CFG_TEXT("description");
private _priority = GET_CFG_NUMBER("priority");

private _parentTaskId = GET_CFG_TEXT("parentTask");
if (_parentTaskId isNotEqualTo "") then {
    _taskId = [_taskId,_parentTaskId];
};


/* ----------------------------------------------------------------------------
    Create Task
---------------------------------------------------------------------------- */
private _createdTask = [
    _owner,
    _taskId,
    [_taskDescription,_taskTitle],
    _destination,
    _taskState,
    _priority,
    _notifyOnCreate,
    _type,
    _visibleIn3D
] call BIS_fnc_taskCreate;


if (_createdTask isNotEqualTo "") then {
    private _onCreateCode = GET_CFG_TEXT("onCreate");

    if (_onCreateCode isNotEqualTo "") then {
        [_taskId,_config,_taskState] call (compile _onCreateCode);
    };

    // do onComplete code if already ended
    if (
        _taskState == "SUCCEEDED" OR
        (_taskState == "FAILED") OR
        (_taskState == "CANCELED")
    ) then {
        private _onCompleteCode = GET_CFG_TEXT("onComplete");
        [_taskId,_config,_taskState] call (compile _onCompleteCode);
    };
};


_createdTask
