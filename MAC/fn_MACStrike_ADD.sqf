params [
	["_object",player,[objNull]],
	["_cooldown",30,[1]],
	["_MACOnline",true,[true]]
];

if !(alive _object) exitWith {};

//if action already exists on object
if !(isNil (_object getVariable "kiska_MacStrikeActionID")) exitWith {};

if (_MACOnline) then {missionNamespace setVariable ["KISKA_MAC_Online", true, true];};

private _macStrikeActionID = _object addAction ["MAC Strike",{[_this select 1,_this select 3] remoteExecCall ["Kiska_fnc_MACStrike",2,false]},_coolDown]; 

_object setVariable ["kiska_MacStrikeActionID",_macStrikeActionID];

_object addEventHandler ["Killed",{
		params [
			["_object",objNull,[objNull]]
		];

		[_object] remoteExecCall ["KISKA_fnc_MACStrike_REM",_object,true];
	}
];

private _objectsAssignedMAC = missionNamespace getVariable ["KISKA_assigned_MACAction",[]];

private _macActionRemoveIndex = _objectsAssignedMAC pushBackUnique _object;

missionNamespace setVariable ["KISKA_assigned_MACAction",_objectsAssignedMAC,true];




/*
params [["_triggerArr",[]]];

// Check if MAC is online
if (!(missionNamespace getVariable ["kiska_MAC_online",true])) exitWith {};

{ 
	if (local _x && {_x in _triggerArr}) then {  
		MacStrikeAction = _x addAction ["MAC Strike",{[_this select 1] remoteExecCall ["Kiska_fnc_MACStrike",2,false]}]; 
	};
} forEach allPlayers;
*/