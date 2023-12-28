/* ----------------------------------------------------------------------------
Function: KISKA_fnc_remoteReturn_send

Description:
    Gets a remote return from a scripting command on a target machine.
    
    Basically remoteExec but with a return.

    Needs to be run in a scheduled environment as it takes time to receive
     the return.

    This should not be abused to obtain large returns over the network.
    
    Be smart and use for simple types (not massive arrays).

Parameters:
    0: _code <STRING> - The command to execute on the target machine
    1: _defaultValue : <ANY> - If the variable does not exist for the target, what should be returned instead
    2: _target : <NUMBER, OBJECT, or STRING> - The target to execute the _code on
    3: _scheduled : <BOOL> - Should _code be run in a scheduled environment (on target machine)
    4: _awaitParams : <[NUMBER,NUMBER,BOOL]> - How the get from the target should be awaited

        Parameters:
        - 0: <NUMBER> - The sleep time between each check for the variable being received
        - 1: <NUMBER> - The max time to wait for (this is not total game time but time slept)
        - 2: <BOOL> - Whether or not the sleep time should be exponential (double every iteration)


Returns:
    <ANY> - Whatever the code returns

Examples:
    (begin example)
        [] spawn {
            // need to call for direct return but in scheduled environment
            _clientIdFromServer = ["owner (_this select 0)",[player],2] call KISKA_fnc_remoteReturn_send;
        };
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_remoteReturn_send";

if (!canSuspend) exitWith {
    ["Must be run in scheduled environment",true] call KISKA_fnc_log;
    nil
};

params [
    ["_code","",[""]],
    ["_args",[],[[]]],
    ["_target",2,[123,objNull,""]],
    ["_scheduled",false,[true]],
    ["_awaitParams",[],[[]]]
];

if ((_target isEqualType objNull) AND {isNull _target}) exitWith {
    ["_target is null object!"] call KISKA_fnc_log;
    nil
};

private _targetIsNetId = false;
private _targetsMultipleUsers = false;
private _exitForMultiUserTarget = false;
private _regularMultiplayer = isMultiplayer AND (!isMultiplayerSolo);
if (_regularMultiplayer) then {
    private _targetsMultipleUsers = (_target isEqualType 123) AND {_target <= 0};
    if (_targetsMultipleUsers) exitWith {
        _exitForMultiUserTarget = true;
    };

    private _targetIsString = _target isEqualType "";
    if (!_targetIsString) exitWith {};

    private _targetIsNetId = _targetIsString AND {
            private _split = _target splitString ":";
            private _splitCount = count _split;
            (_splitCount isEqualTo 2) AND {
                private _splitParsed = _split apply {parseNumber _x};
                private _splitCompare = _splitParsed apply {str _x};
                _splitCompare isEqualTo _split
            }
        };

    if (!_targetIsNetId) exitWith {
        _exitForMultiUserTarget = true;
    };
};


if (_exitForMultiUserTarget) exitWith {
    [["_target: ",_target," is invalid as it will be sent to more then one machine!"],true] call KISKA_fnc_log;
    nil
};

_awaitParams params [
    ["_awaitTime",0.05,[123]],
    ["_maxWaitTime",2,[123]],
    ["_exponentialBackOff",false,[true]]
];

private _uniqueId = ["KISKA_RR_" + (str clientOwner)] call KISKA_fnc_generateUniqueId;
[_code,_args,_scheduled,_uniqueId] remoteExecCall ["KISKA_fnc_remoteReturn_receive",_target];


private _timeWaited = 0;
waitUntil {
    if (_timeWaited >= _maxWaitTime) then {
        [
            [
                "Max wait time of: ",
                _maxWaitTime,
                " for variable ",
                _uniqueId,
                " from target ",
                _target,
                " was exceeded. Exiting with nil..."
            ],
            false
        ] call KISKA_fnc_log;
        breakWith true;
    };

    if (!isNil _uniqueId) exitWith {
        [["Got variable ",_uniqueId," from target ",_target],false] call KISKA_fnc_log;
        true
    };

    sleep _awaitTime;
    _timeWaited = _timeWaited + _awaitTime;
    
    if (_exponentialBackOff) then {
        _awaitTime = _awaitTime * 2;
    };
    
    [["Waiting for ",_uniqueId," from target: ",_target],false] call KISKA_fnc_log;
    false
};

private _return = missionNamespace getVariable _uniqueId;
// set to nil so that any other requesters don't get a duplicate
missionNamespace setVariable [_uniqueId,nil];


_return
