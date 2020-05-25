params [
	["_vehicle",objNull,[objNull]]
];

if (isNil {_vehicle getVariable "DSO_unloadActionID"}) exitWith {false};

_vehicle removeAction (_vehicle getVariable "DSO_unloadActionID");

true