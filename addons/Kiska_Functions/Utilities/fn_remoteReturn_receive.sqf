/* ----------------------------------------------------------------------------
Function: KISKA_fnc_remoteReturn_receive

Description:
	The send back component of KISKAs remote returns.
	This catches what was sent in KISKA_fnc_remoteReturn_send and will send the
	 variable back to the remoteExecutedOwner.

Parameters:
	0: _code <STRING> - The code to execute to get a return
	1: _args : <ARRAY> - An array of arguements for the _code
	2: _scheduled : <BOOL> - Should _code be run in a scheduled environment
	3: _uniqueId <STRING> - The unique variable id used to send the return back to the requester

Returns:
	NOTHING

Examples:
	// called specifically from KISKA_fnc_remoteReturn_send
    (begin example)
        [_code,_args,_scheduled,_uniqueId,clientOwner] remoteExecCall ["KISKA_fnc_remoteReturn_receive",_target];
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_remoteReturn_receive";

params [
	["_code","",[""]],
	["_args",[],[[]]],
	["_scheduled",false,[true]],
	"_uniqueId"
];

private _sendBackTarget = remoteExecutedOwner;
// setVariable handling
if (_sendBackTarget isEqualTo 0) then {

	[["Found _sendBackTarget isEqualTo 0 for ",_uniqueId],false] call KISKA_fnc_log;

	// if it's multiplayer, do not send all connected the value, just put it on server
	if (isMultiplayer) then {
		["Found to be multiplayer, setting target to 2 ",false] call KISKA_fnc_log;
		_sendBackTarget = 2;
	};
} else {

	[["Found _sendBackTarget ise ",_sendBackTarget," for ",_uniqueId],false] call KISKA_fnc_log;

	// setVariable in single player does not work with 2 to set on the local machine
	if (!isMultiplayer AND {_sendBackTarget isEqualTo 2}) then {
		[["Not multiplayer and _sendBackTarget is 2, setting ",_uniqueId," to 0 target"],false] call KISKA_fnc_log;
		_sendBackTarget = 0;
	};
};



private _compiledCode = compileFinal _code;
if (_scheduled) then {

	[_compiledCode,_args,_uniqueId,_sendBackTarget] spawn {
		params ["_code","_args","_uniqueId","_sendBackTarget"];

		private "_return";
		if (_args isEqualTo []) then {
			_return = call _code;
		} else {
			_return = _args call _code;
		};

		missionNamespace setVariable [_uniqueId,_return,_sendBackTarget];
	};
} else {

	private "_return";
	if (_args isEqualTo []) then {
		_return = call _compiledCode;
	} else {
		_return = _args call _compiledCode;
	};

	missionNamespace setVariable [_uniqueId,_return,_sendBackTarget];
};
