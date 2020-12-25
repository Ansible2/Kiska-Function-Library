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
		null = [myVehicle] spawn KISKA_fnc_AAAZone;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "KISKA_fnc_AAAZone"
scriptName SCRIPT_NAME;

if (!canSuspend) exitWith {
	null = _this spawn KISKA_fnc_AAAZone;
	"KISKA_fnc_AAAZone: Needs to be run in scheduled environment" call BIS_fnc_error;
};

params [
	["_vehicle",objNull,[objNull]],
	["_radius",1000,[123]],
	["_checkTime",5,[123]]
];

if (isNull _vehicle) exitWith {
	[SCRIPT_NAME,[_vehicle,"isNull"],true,true] call KISKA_fnc_log;
};

if (!local _vehicle) exitWith {
	[SCRIPT_NAME,[_vehicle,"is not local to machine, executing on owner"],true] call KISKA_fnc_log;
	_this remoteExec ["KISKA_fnc_AAAZone",_vehicle];
};

private _gunner = gunner _vehicle;
if (isNull _gunner) exitWith {
	[SCRIPT_NAME,[_vehicle,"does not have a gunner"],true,true] call KISKA_fnc_log;
};

private _gunnerGroup = group _gunner;
if (isNull _gunnerGroup) exitWith {
	[SCRIPT_NAME,[_gunnerGroup,"is a null group"],true,true] call KISKA_fnc_log;
};

private _fn_controlShots = {
	params ["_doShoot"];

	if (_doShoot) then {
		[_gunner,"WEAPONAIM"] remoteExecCall ["enableAI"_gunner];
		[_gunnerGroup,"RED"] remoteExecCall ["setCombatMode",_gunnerGroup];
	} else {
		[_gunner,"WEAPONAIM"] remoteExecCall ["disableAI"_gunner];
		[_gunnerGroup,"BLUE"] remoteExecCall ["setCombatMode",_gunnerGroup];
		//[_gunner,"AUTOTARGET"] remoteExecCall ["disableAI"_gunner];
		//[_gunner,"TARGET"] remoteExecCall ["disableAI"_gunner];
	};
};

// disable unit
[false] call _fn_controlShots


private _AAAside = side _vehicle;
[SCRIPT_NAME,["_AAAside is",_AAASide]] call KISKA_fnc_log;
private _doFire = false;
private "_entitiesInRadius";

_vehicle setVariable ["KISKA_doAAA",true];
while {sleep _checkTime; _vehicle getVariable ["KISKA_doAAA",true]} do {
	_entitiesInRadius = _vehicle nearEntities ["air",_radius];

	// if any air units are found
	if !(_entitiesInRadius isEqualTo []) then {
		[SCRIPT_NAME,"Found entities in radius"] call KISKA_fnc_log;
		private _index = _entitiesInRadius findIf {
			[SCRIPT_NAME,["Side of",_x,"is",side _x,": side of AAA is",_AAASide]] call KISKA_fnc_log;
			[side _x,_AAAside] call BIS_fnc_sideIsEnemy;
		};

		// if an enemy aircraft is found AND _vehicle is not already engaging
		if (_index != -1 AND {!_doFire}) then {
			[SCRIPT_NAME,["Found a unit to engage and not already doing so, weapon aim on for",_gunner]] call KISKA_fnc_log;
			_doFire = true;
			[true] call _fn_controlShots
		} else {
			// only disable if no targets are found and already engaging
			[SCRIPT_NAME,["Did not meet fire standards. Do fire?",_doFire,"Index?",_index]] call KISKA_fnc_log;
			if (_index isEqualTo -1 AND {_doFire}) then {
				[SCRIPT_NAME,"No enemy targets to engage anymore. Disabling weapon aim and _doFire to false"] call KISKA_fnc_log;
				_doFire = false;
				[false] call _fn_controlShots
			};
		};
	} else {
		[SCRIPT_NAME,"No entities in area found"] call KISKA_fnc_log;
		if (_doFire) then {
			[SCRIPT_NAME,"Setting _doFire to false"] call KISKA_fnc_log;
			_doFire = false;
		};
	};

	// if vehicle is dead or gunner is absent
	if !(alive _gunner) exitWith {
		[SCRIPT_NAME,["_gunner",_gunner,"is no longer alive, exiting"]] call KISKA_fnc_log;
		if (alive _vehicle) then {
			[SCRIPT_NAME,["_vehicle",_vehicle,"is still alive, setting KISKA_doAAA to nil"]] call KISKA_fnc_log;
			_vehicle setVariable ["KISKA_doAAA",nil];
		};
	};
	if !(alive _vehicle) exitWith {
		[SCRIPT_NAME,["_vehicle",_vehicle,"is no longer alive, exiting"]] call KISKA_fnc_log;
	};
};

if (alive _gunner) then {
	[true] call _fn_controlShots
};