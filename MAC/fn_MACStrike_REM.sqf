params [
	["_object",player,[objNull]]
];

private _macStrikeActionID = _object getVariable ["kiska_MacStrikeActionID",0];

if (isNil {_object getVariable "kiska_MacStrikeActionID"}) exitWith {};

_object removeAction _macStrikeActionID;

_object setVariable ["kiska_MacStrikeActionID",nil];