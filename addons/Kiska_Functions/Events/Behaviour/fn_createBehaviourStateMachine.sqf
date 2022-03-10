/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addEventhandler_behaviour

Description:
	Makes a helicopter land at a given position.

Parameters:
	0: _entity <OBJECT or GROUP> - The unit or group to add the event to
	1: _code <CODE or STRING> - Exectute on change

Returns:
	<NUMBER> - Index of eventhandler

Examples:
    (begin example)
		[

        ] call KISKA_fnc_addEventhandler_behaviour;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addEventhandler_behaviour";

#define BEHAVIOURS ["careless","safe","aware","combat","stealth","error"]

_stateMachine = [[_group],true] call cba_statemachine_fnc_create;

BEHAVIOURS apply {
	private _topState = _x;
	[
		stateMachine,
		{}, // onState
		{}, // onStateEntered
		{}, // onStateLeaving
		"KISKA_groupBehaviourState_" + _topState // name
	] call CBA_statemachine_fnc_addState;
};

BEHAVIOURS apply {
	private _topState = _x;
	BEHAVIOURS apply {
		if (_x == _topState) then {continue};

		[
			stateMachine,
			"KISKA_groupBehaviourState_" + _topState,
			"KISKA_groupBehaviourState_" + _x,
			compile ("combatBehaviour _this == " + ([_x] call KISKA_fnc_str))
		] call CBA_stateMachine_fnc_addTransition;
	};
};
