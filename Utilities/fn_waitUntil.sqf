/* ----------------------------------------------------------------------------
Function: KISKA_fnc_waitUntil

Description:
	Waitunil that allows variable evaluation time instead of frame by frame.

Parameters:

	0: _interval <NUMBER> - How often to check the condition
	1: _function <CODE> - The code to execute upon condition being reached
	2: _condition <CODE> - Code that must evaluate as a BOOL
	3. _parameters <ARRAY> - An array of local parameters that can be accessed with _this
	4. _unscheduled <BOOL> - Run in unscheduled environment
	5. _trigger <BOOL> - Make a trigger instead of other waitUntil methods. Requires _unscheduled to be TRUE. _parameters are acsesssed with: thisTrigger getVariable "KISKA_args"

Returns:
	BOOL

Examples:
    (begin example)

		[
			1,
			{
				hint "wait";
			},
			{
				true
			},
			false
		] call KISKA_fnc_waitUntil;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
params [
	["_interval",0.5,[0]],
	["_function",{},[{}]],
	["_condition",true,[{},true]],
	["_parameters",[],[[]]],
	["_unscheduled",false,[true]],
	["_trigger",false,[true]]
];

if (_unscheduled) then {

	if (_trigger) then {
		[_function,_condition,_parameters,_interval] call KISKA_fnc_triggerWait;
	} else {
		if (_interval <= 0) then {
			
			[
				_condition,
				_function,
				_parameters
			] call CBA_fnc_waitUntilAndExecute;	

		} else {

			[
				{
					params ["_interval","_function","_condition","_parameters","_unscheduled"];

					if (_parameters call _condition) then {_parameters call _function} else {_this call KISKA_fnc_waitUntil};
				},
				[_interval,_function,_condition,_parameters,_unscheduled],
				_interval
			] call CBA_fnc_waitAndExecute;

		};
	};

} else {

	[_interval,_function,_condition,_parameters] spawn {
		params ["_interval","_function","_condition","_parameters"];
		
		waitUntil {
			sleep _interval;
			
			if (_parameters call _condition) exitWith {_parameters call _function; true};

			false
		};
		
	};

};