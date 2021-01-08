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
	0: _code <STRING> - The command to execute on the target machine.
	1: _defaultValue : <ANY> - If the variable does not exist for the target, what should be returned instead
	2: _target : <NUMBER, OBJECT, GROUP, or STRING> - Where the _target is local will be where the command is executed

Returns:
	<ANY> - Whatever the code returns

Examples:
    (begin example)
        null = [] spawn {
			// need to call for direct return
			_someServerValue = ["someVariable",missionNamespace,"",2] call KISKA_fnc_getVariableTarget;
		};
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_remoteReturn_send"
scriptName SCRIPT_NAME;

if (!canSuspend) exitWith {
	[SCRIPT_NAME,"Must be run in scheduled environment",false,true,true] call KISKA_fnc_log;
	-1
};

params [
	["_code","",[""]]
];

