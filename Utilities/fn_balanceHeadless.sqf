/* ----------------------------------------------------------------------------
Function: KISKA_fnc_balanceHeadless

Description:
	Balances AI among all logged Headless Clients in a very simple fashion.
	Designed to be run once and also should only be done when all HC are logged onto the server.

	Excluded groups and objects can be added to the array KISKA_hcExcluded.

Parameters:
	 
	0: _checkInterval <NUMBER> - How often to redistribute, if -1, will not loop

Returns:
	BOOL

Examples:
    (begin example)

		[] spawn KISKA_fnc_balanceHeadless;

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
	["_checkInterval",-1,[123]]
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

// everyone goes basck to 0 for even redistribution
_headlessClients apply {
	_x setVariable ["KISKA_hcLocalUnitsCount",0];
};

["Headless ReBalance Is Beginning"] remoteExec ["hint",call CBA_fnc_players];

allGroups apply {
	private _group = _x;

	if !(_group in (missionNamespace getVariable ["KISKA_hcExcluded",[]])) then {
		// each headless client has a count of how many local units it has
		private _localUnitsCountArray = [];
		// an array of each of the headless client entities 
		private _headlessArray = [];

		_headlessClients apply {
			_localUnitsCountArray pushBack (_x getVariable ["KISKA_hcLocalUnitsCount",0]);
			_headlessArray pushBackUnique _x;
		};

		// see who has the least units
		private _leastUnits = selectMin _localUnitsCountArray;
		// get the index of them in _headlessArray so that we can see how many local units they have in _localUnitsCountArray
		private _index = _localUnitsCountArray findIf {_leastUnits isEqualTo _x};
		// select that headless client
		private _bestHeadless = _headlessArray select _index;
		// And lastly get their actual ID
		private _bestHeadlessID = owner _bestHeadless;
		
		// verify units are migrated before proceeding
		waitUntil {
			if ((owner _group) isEqualTo _bestHeadlessID) exitWith {true};
			_group setGroupOwner _bestHeadlessID;

			uiSleep 0.1;
			false
		};

		// get the units migrated and how many
		private _unitsInGroup = units _group;
		private _newTotal = _leastUnits + (count _unitsInGroup);
		
		// update HC global count of its local units
		_bestHeadless setVariable ["KISKA_hcLocalUnitsCount",_newTotal];

		// add the units to a global attached to the HC so they can be referenced and subtracted at death
		private _localUnitsArray = _bestHeadless getVariable ["KISKA_hcLocalUnits",[]];
		_unitsInGroup apply {
			_localUnitsArray pushBack _x;

			// add a MP eventhandler that runs on the server for when the AI is killed so that they can be subtracted from the count and array of local units
			_x addMPEventHandler ["MPKilled",{
				
				params ["_unit"];

				if (isServer) then {
					private _headlessClients = entities "HeadlessClient_F";

					_headlessClients apply {
						private _headlessClient = _x;
						private _localUnitsArray = _headlessClient getVariable ["KISKA_hcLocalUnits",[]];

						if (_unit in _localUnitsArray) exitWith {

							/* For eventual smarter redistribution of totals...

								// get current total local units
								private _localUnitsCount = _headlessClient getVariable "KISKA_hcLocalUnitsCount";
								_localUnitsCount = _localUnitsCount - 1;
								// set new total
								_headlessClient setVariable ["KISKA_hcLocalUnitsCount",_localUnitsCount];
							*/

							// take unit out of array
							_localUnitsArray deleteAt (_localUnitsArray findIf {_x isEqualTo _unit});

							_unit removeMPEventHandler ["MPKilled",_thisEventHandler];

							true
						};
					};
				};

			}];
		};
	};

	uiSleep 0.5;
};

["Headless ReBalance Is COMPLETE"] remoteExec ["hint",call CBA_fnc_players];

if (_checkInterval > 0 AND {_checkInterval != -1}) then {
	sleep _checkInterval;

	[_checkInterval] spawn KISKA_fnc_balanceHeadless;
};