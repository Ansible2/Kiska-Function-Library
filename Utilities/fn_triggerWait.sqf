/* ----------------------------------------------------------------------------
Function: KISKA_fnc_triggerWait

Description:
	Creates a trigger and sets statements. Used to have variable condition check intervals

Parameters:
	0: _activation <STRING or CODE> - Code to run upon trigger activation
	1: _condition <STRING or CODE> - The condition to check
	2: _args <ARRAY> - arguements to pass to the condition,activation and deactivation; can be obtained by '_thisArgs' in those fields
	3. _interval <BOOL> - How often to check the condition
	4. _deactivation <STRING or CODE> - Code to run on trigger deactivation, default is ""
	5. _delete <BOOL> - Delete the trigger after completion, default is true

Returns:
	_trigger <OBJECT> - Trigger created for the function

Examples:
    (begin example)

		stuff = false;
		_stuff = "hello";

		[
			"
				_thisArgs params ['_stuff'];
				hint _stuff;
			",
			"
				stuff
			",
			[_stuff],
			5
		] call KISKA_fnc_triggerWait;

		[
			{stuff = true},
			[],
			2
		] call CBA_fnc_waitAndExecute;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_triggerWait";

params [
	["_activation","",["",{}]],
	["_condition","",["",{}]],
	["_args",[],[[]]],
	["_interval",0.5,[0]],
	["_deactivation","",["",{}]],
	["_delete",true,[true]]
];


if (_activation isEqualTo "" OR {_condition isEqualTo ""}) exitWith {
	["_activation of _condition is empty string",true] call KISKA_fnc_log;
};

if (_activation isEqualType {}) then {
	private _stringActivation = str _activation;

	_activation = _stringActivation trim ["{}",0];
	//_activation = [_stringActivation,"{}"] call CBA_fnc_trim;
};
if (_condition isEqualType {}) then {
	private _stringCondition = str _condition;

	_condition = _stringCondition trim ["{}",0];
	//_condition = [_stringCondition,"{}"] call CBA_fnc_trim;
};
if (_deactivation isEqualType {}) then {
	private _stringDeactivation = str _deactivation;

	_deactivation = _stringDeactivation trim ["{}",0];
	//_deactivation = [_stringDeactivation,"{}"] call CBA_fnc_trim;
};


if (_delete) then {
	if (_deactivation isEqualTo "") then {
		private _length = count _activation;
		private _lastCharacter = _activation select [_length - 1];

		_activation = ["private _thisArgs = (thisTrgger getVariable 'KISKA_args');", _activation,[";",""] select (_lastCharacter isEqualTo ";"),"deleteVehicle thisTrigger"] joinString " ";
	} else {
		private _length = count _deactivation;
		private _lastCharacter = _deactivation select [_length - 1];

		_deactivation = ["private _thisArgs = (thisTrgger getVariable 'KISKA_args');", _deactivation,[";",""] select (_lastCharacter isEqualTo ";"),"deleteVehicle thisTrigger"] joinString " ";
	};

	_condition = "private _thisArgs = (thisTrgger getVariable 'KISKA_args'); " + _condition;
};

private _trigger = createTrigger ["EmptyDetector",[0,0,0],false];

_trigger setVariable ["KISKA_args",_args];

_trigger setTriggerStatements [_condition, _activation, _deactivation];

_trigger setTriggerInterval _interval;


_trigger
