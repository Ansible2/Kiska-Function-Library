/* ----------------------------------------------------------------------------
Function: KISKA_fnc_balanceHeadless

Description:
	Balances AI among all logged Headless Clients in a very simple fashion.
	Designed to be run once and also should only be done when all HC are logged onto the server.

	Excluded groups and objects can be added to the array KISKA_hcExcluded.

Parameters:
	 
	0: _checkInterval <NUMBER> - How often to check for HCs

Returns:
	BOOL

Examples:
    (begin example)

		[60] spawn KISKA_fnc_balanceHeadless;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer OR {!isMultiplayer}) exitWith {false};

if (!canSuspend) exitWith {
	"Must be run in a scheduled environement" call BIS_fnc_error;
	false
};

params [
	["_checkInterval",60,[123]]
];

private _headlessClients = entities "HeadlessClient_F";

if (_headlessClients isEqualTo []) exitWith {
	[
		{
			_this spawn KISKA_fnc_balanceHeadless;
		},
		[_checkInterval],
		_checkInterval
	] call CBA_fnc_waitAndExecute;
};

if !((missionNamespace getVariable ["KISKA_hcExcluded",[]]) isEqualTo []) then {
	private _excluded = missionNamespace getVariable ["KISKA_hcExcluded",[]];

	{
		if !(_x isEqualTypeAny [grpNull,objNull]) then {
			[(str _x) + " is not object or group"] call BIS_fnc_error
		};

		if (_x isEqualType objNull) then {
			_excluded set [_forEachIndex,group _x];
		};
	} forEach _excluded;

	KISKA_hcExcluded = _excluded;
};

allGroups apply {
	private _group = _x;

	if !(_group in (missionNamespace getVariable ["KISKA_hcExcluded",[]])) then {
		private _localUnitCountArray = [];
		private _headlessArray = [];

		_headlessClients apply {
			_localUnitCountArray pushBack (_x getVariable ["KISKA_hcLocalUnits",0]);
			_headlessArray pushBackUnique _x;
		};

		private _leastUnits = selectMin _localUnitCountArray;
		private _index = _localUnitCountArray findIf {_leastUnits isEqualTo _x};
		private _bestHeadless = _headlessArray select _index;
		private _bestHeadlessID = owner _bestHeadless;

		private _migrated = _group setGroupOwner _bestHeadlessID;
		
		// verify units are migrated before proceeding
		waitUntil {
			if ((owner _group) isEqualTo _bestHeadlessID) exitWith {true};
			_group setGroupOwner _bestHeadlessID;

			uiSleep 0.1;
			false
		};

		private _newTotal = _leastUnits + (count (units _group));
		
		_bestHeadless setVariable ["KISKA_hcLocalUnits",_newTotal];
	};

	uiSleep 0.5;
};

true

// not until you can have this properly rebalance how many units each HC has and tell the server about it (like if someone dies)
/*

	if (!isServer OR {!isMultiplayer}) exitWith {false};

	params [
		["_checkInterval",60,[123]]
	];

	private _headlessClients = entities "HeadlessClient_F";

	if (_headlessClients isEqualTo []) exitWith {
		[
			{
				_this spawn KISKA_fnc_balanceHeadless;
			},
			[_checkInterval],
			_checkInterval
		] call CBA_fnc_waitAndExecute;
	};

	if !((missionNamespace getVariable ["KISKA_hcExcluded",[]]) isEqualTo []) then {
		private _excluded = missionNamespace getVariable ["KISKA_hcExcluded",[]];

		{
			if !(_x isEqualTypeAny [grpNull,objNull]) then {
				[(str _x) + " is not object or group"] call BIS_fnc_error
			};

			if (_x isEqualType objNull) then {
				_excluded set [_forEachIndex,group _x];
			};
		} forEach _excluded;

		KISKA_hcExcluded = _excluded;
	};


	allGroups apply {
		private _group = _x;

		if !(_group in (missionNamespace getVariable ["KISKA_hcExcluded",[]])) then {
			private _localUnitCountArray = [];
			private _headlessArray = [];

			_headlessClients apply {
				_localUnitCountArray pushBack (_x getVariable ["KISKA_hcLocalUnits",0]);
				_headlessArray pushBackUnique _x;
			};

			private _leastUnits = selectMin _localUnitCountArray;
			private _index = _localUnitCountArray findIf {_leastUnits isEqualTo _x};
			private _bestHeadless = _headlessArray select _index;
			private _bestHeadlessID = owner _bestHeadless;

			_group setGroupOwner _bestHeadlessID;
			private _unitsInGroup = units _group;
			private _numberOfUnits = count _unitsInGroup;
			private _newTotal = _leastUnits + _numberOfUnits;

			_bestHeadless setVariable ["KISKA_hcLocalUnits",_newTotal];

			_unitsInGroup apply {
				if !((owner _x) isEqualTo _bestHeadlessID) then {
					private _id = [
						_x, 
						"KILLED",
						{
							params ["_deadGuy"];

							private _numberOfLocalUnits = _thisArgs getVariable ["KISKA_hcLocalUnits",1];
							_thisArgs setVariable ["KISKA_hcLocalUnits",_numberOfLocalUnits - 1];

							_deadGuy removeEventHandler ["KILLED",_thisID];
						},
						_bestHeadless
					] call CBA_fnc_addBISEventHandler;
					
					if !(isNil {_x getVariable "KISKA_hcKilledEH_ID"}) then {
						_x removeEventHandler ["KILLED",(_x getVariable "KISKA_hcKilledEH_ID")];
					};
					
					_x setVariable ["KISKA_hcKilledEH_ID",_id];
				};
			};
		};

		uiSleep 0.1;
	};


	[
		{
			_this call KISKA_fnc_balanceHeadless;
		},
		[_checkInterval],
		_checkInterval
	] call CBA_fnc_waitAndExecute;

	true
*/