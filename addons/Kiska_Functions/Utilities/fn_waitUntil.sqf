/* ----------------------------------------------------------------------------
Function: KISKA_fnc_waitUntil

Description:
	Waitunil that allows variable evaluation time instead of frame by frame.

Parameters:
	0: _condition <CODE, STRING, or ARRAY> - Code that must evaluate as a BOOL.
		IF _interval is <= 0 AND _unscheduled isEqualTo true, this will only accept CODE
		as an arguement for performance reasons and _parameters will be available in _this.
		(See KISKA_fnc_callBack)
	1: _function <CODE, STRING, or ARRAY> - The code to execute upon condition being reached.
		(See KISKA_fnc_callBack)
	2: _interval <NUMBER> - How often to check the condition
	3. _parameters <ARRAY> - An array of local parameters that can be accessed with _this
	4. _unscheduled <BOOL> - Run in unscheduled environment

Returns:
	NOTHING

Examples:
    (begin example)
		[
			{
				true
			},
			{
				hint "wait";
			},
			0.5,
			[],
			true
		] call KISKA_fnc_waitUntil;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_waitUntil";

params [
	["_condition",{},[{},"",[]]],
	["_function",{},[{},"",[]]],
	["_interval",0.5,[123]],
	["_parameters",[],[[]]],
	["_unscheduled",true,[true]]
];

if (
	_unscheduled AND
	(_interval <= 0) AND
	!(_condition isEqualType {})
) exitWith {
	["Unscheduled, perframe waituntil will only support CODE as an arguement",true] call KISKA_fnc_log;
	nil
};

if (_condition isEqualType "") then {
	_condition = compileFinal _condition;
};
if (_function isEqualType "") then {
	_function = compileFinal _function;
};

if (_unscheduled) then {

	if (_interval <= 0) then {
		[
			{
				params ["_parameters","","_condition"];
				_parameters call _condition
			},
			{
				params ["_parameters","_function",""];
				[_parameters,_function] call KISKA_fnc_callBack;
			},
			[_parameters,_function,_condition]
		] call CBA_fnc_waitUntilAndExecute;

	} else {

		[
			{
				params [
					"_condition",
					"_function",
					"_interval",
					"_parameters",
					""
				];

				private _conditionMet = [_parameters,_condition] call KISKA_fnc_callBack;
				if (_conditionMet) exitWith {
					[_parameters,_function] call KISKA_fnc_callBack;
				};

				_this call KISKA_fnc_waitUntil;
			},
			_this,
			_interval
		] call CBA_fnc_waitAndExecute;

	};

} else {

	[_interval,_function,_condition,_parameters] spawn {
		params ["_interval","_function","_condition","_parameters"];

		waitUntil {
			sleep _interval;
			private _conditionMet = [_parameters,_condition] call KISKA_fnc_callBack;
			if (_conditionMet) exitWith {
				[_parameters,_function] call KISKA_fnc_callBack;
				true
			};

			false
		};

	};

};
