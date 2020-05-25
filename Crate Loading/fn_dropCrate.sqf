params [
	["_crate",objNull,[objNull]],
	["_player",player,[objNull]],
	["_dropCrate_actionID",0,[123]]
];

_player setVariable ["DSO_dropCrateActionID",nil];

detach _crate;

_crate enableSimulationGlobal true;

_player removeAction _dropCrate_actionID;
_player forceWalk false;

_crate setVariable ["DSO_cratePickedUp",false,true];

true