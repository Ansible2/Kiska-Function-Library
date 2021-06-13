/* ----------------------------------------------------------------------------
Function: KISKA_fnc_AAAZone

Description:
	Sets up a zone that when entered by an enemy aircraft, the provided vehicle will engage.

	Otherwise, vehicle will stay the same.

Parameters:
	0: _vehicle : <OBJECT> - The AAA piece
	1: _radius : <NUMBER> - How far out the turret is alerted to
	2: _checkTime : <NUMBER> - How often does the AAA scan the area for targets

Returns:
	NOTHING

Examples:
    (begin example)
		[myVehicle] spawn KISKA_fnc_AAAZone;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_AAAZone";

#define RETURN_NIL nil

if (!canSuspend) exitWith {
	["ReExecuting in scheduled environment",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_AAAZone;
};

params [
	["_vehicle",objNull,[objNull]],
	["_radius",1000,[123]],
	["_checkTime",5,[123]]
];

if (isNull _vehicle) exitWith {
	["_vehicle is null object",true] call KISKA_fnc_log;
	RETURN_NIL
};

if (!local _vehicle) exitWith {
	[[_vehicle," is not local to machine, executing on owner"],false] call KISKA_fnc_log;
	_this remoteExec ["KISKA_fnc_AAAZone",_vehicle];
	RETURN_NIL
};

private _gunner = gunner _vehicle;
if (isNull _gunner) exitWith {
	[[_vehicle," does not have a gunner"],true] call KISKA_fnc_log;
	RETURN_NIL
};

private _gunnerGroup = group _gunner;
if (isNull _gunnerGroup) exitWith {
	["_gunnerGroup is null",true] call KISKA_fnc_log;
	RETURN_NIL
};

// disable HC transfer
[_gunnerGroup,false] call KISKA_fnc_ACEX_setHCTransfer;

private _fn_controlShots = {
	params ["_doShoot"];

	if (_doShoot) then {
		[_gunner,"WEAPONAIM"] remoteExecCall ["enableAI",_gunner];
		[_gunnerGroup,"RED"] remoteExecCall ["setCombatMode",_gunnerGroup];
	} else {
		[_gunner,"WEAPONAIM"] remoteExecCall ["disableAI",_gunner];
		[_gunnerGroup,"BLUE"] remoteExecCall ["setCombatMode",_gunnerGroup];
		//[_gunner,"AUTOTARGET"] remoteExecCall ["disableAI"_gunner];
		//[_gunner,"TARGET"] remoteExecCall ["disableAI"_gunner];
	};
};

// disable unit
[false] call _fn_controlShots;


private _AAAside = side _vehicle;
private _doFire = false;
private "_entitiesInRadius";

_vehicle setVariable ["KISKA_doAAA",true];
while {sleep _checkTime; _vehicle getVariable ["KISKA_doAAA",true]} do {
	_entitiesInRadius = _vehicle nearEntities ["air",_radius];

	// if any air units are found
	if (_entitiesInRadius isNotEqualTo []) then {
		["Found entities in radius",false] call KISKA_fnc_log;

		// find an enemy unit to fire at
		private _index = _entitiesInRadius findIf {
			//[["Side of",_x,"is",side _x,": side of AAA is",_AAASide]] call KISKA_fnc_log;
			[side _x,_AAAside] call BIS_fnc_sideIsEnemy;
		};

		// if an enemy aircraft is found AND _vehicle is not already engaging
		if (_index isNotEqualTo -1 AND {!_doFire}) then {
			[["Found a unit to engage and not already doing so, weapon aim on for",_gunner],false] call KISKA_fnc_log;

			_doFire = true;
			[true] call _fn_controlShots;
		} else {
			// only disable if no targets are found and already engaging
			[["Did not meet fire standards. Do fire? ",_doFire," Index? ",_index],false] call KISKA_fnc_log;

			if (_index isEqualTo -1 AND {_doFire}) then {
				["No enemy targets to engage anymore. Disabling weapon aim and _doFire to false",false] call KISKA_fnc_log;

				_doFire = false;
				[false] call _fn_controlShots;
			};
		};
	} else {
		["No entities in area found",false] call KISKA_fnc_log;

		if (_doFire) then {
			["Setting _doFire to false",false] call KISKA_fnc_log;

			_doFire = false;
		};
	};

	// if vehicle is dead or gunner is absent
	if !(alive _gunner) exitWith {
		[["_gunner ",_gunner," is no longer alive, exiting"]] call KISKA_fnc_log;

		if (alive _vehicle) then {
			[["_vehicle ",_vehicle," is still alive, setting KISKA_doAAA to nil"]] call KISKA_fnc_log;

			_vehicle setVariable ["KISKA_doAAA",nil];
		};
	};
	if !(alive _vehicle) exitWith {
		[["_vehicle ",_vehicle," is no longer alive, exiting"]] call KISKA_fnc_log;
	};
};

if (alive _gunner) then {
	[true] call _fn_controlShots;
	// allow HC transfer
	[_gunnerGroup,true] call KISKA_fnc_ACEX_setHCTransfer;
};


RETURN_NIL
