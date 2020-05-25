params [
	["_crate",objNull,[objNull]],
	["_caller",player,[objNull]]
];

// make player lower weapon if not done already
if !(weaponLowered _caller) then {
	_caller action ["WeaponOnBack",_caller];
};

// make them only walk
_caller forceWalk true;

// attach box to player
_crate attachTo [_caller,[0,1.5,1.2]];

// publicly set the crate as picked up
_crate setVariable ["DSO_cratePickedUp",true,true];

// add a drop action to players
private _dropCrate_actionID = _caller addAction [
	"--Drop Crate",
	{
		private _player = param [0,player,[objNull]];
		private _dropCrate_actionID = param [2,0,[123]];
		private _crate = (param [3]) select 0;

		[_crate,_player,_dropCrate_actionID] call KISKA_fnc_pickUpCrate;
	},
	[_crate],
	15,
	true,
	true,
	"",
	"",
	2
];

// this is to remove the action from the crate if it is loaded while picked up
_caller setVariable ["DSO_dropCrateActionID",_dropCrate_actionID];