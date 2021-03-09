/* ----------------------------------------------------------------------------
Function: KISKA_fnc_remoteReturn_send

Description:
	Gets a remote return from a scripting command on a target machine.
	Basically remoteExec but with a  return.

	Needs to be run in a scheduled environment as it takes time to receive
	 the return.
	
	This should not be abused to obtain large returns over the network.
	Be smart and use for simple types (not massive arrays).
	
Parameters:
	0: _code <STRING> - The command to execute on the target machine
	1: _defaultValue : <ANY> - If the variable does not exist for the target, what should be returned instead
	2: _target : <NUMBER, OBJECT, or STRING> - The target to execute the _code on

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
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_remoteReturn_send"
scriptName SCRIPT_NAME;

if (!canSuspend) exitWith {
	["Must be run in scheduled environment",true] call KISKA_fnc_log;
	nil
};

params [
	["_code","",[""]],
	["_args",[],[[]]],
	["_target",2,[123,objNull,""]],
	["_scheduled",false,[true]]
];

// keep from remoting onto multiple machines
if (_target <= 0) exitWith {
	[["_target: ",_target," is invalid as it will be sent to more then one machine!"],true] call KISKA_fnc_log;
	nil
};

// create a unique variable ID for network tranfer
private _messageNumber = missionNamespace getVariable ["KISKA_remoteReturnQueue_count",0];
_messageNumber = _messageNumber + 1;
missionNamespace setVariable ["KISKA_remoteReturnQueue_count",_messageNumber];
private _uniqueId = ["KISKA_RR",clientOwner,"_",_messageNumber] joinString "";

[_code,_args,_scheduled,_uniqueId] remoteExecCall ["KISKA_fnc_remoteReturn_receive",_target];

waitUntil {
	if (!isNil {missionNamespace getVariable _uniqueId}) exitWith {
		[["Got variable ",_uniqueId," from target ",_target],false] call KISKA_fnc_log;
		true
	};
	sleep 0.25;
	[["Waiting for ",_uniqueId," from target: ",_target],false] call KISKA_fnc_log;
	false
};

private _return = missionNamespace getVariable _uniqueId;
// set to nil so that any other requesters don't get a duplicate
missionNamespace setVariable [_uniqueId,nil];


_return