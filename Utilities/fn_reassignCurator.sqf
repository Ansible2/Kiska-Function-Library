/* ----------------------------------------------------------------------------
Function: KISKA_fnc_reassignCurator

Description:
	Reassigns a curator object to the local player.

Parameters:
	0: _curatorObject : <OBJECT or STRING> - The curator object to reassign
	1: _isManual : <BOOL> - Was this called from the diary entry (keeps hints from showing otherwise)

Returns:
	<BOOL> - true if added to player, false otherwise

Examples:
    (begin example)
		// show hint messages
		[myCuratorObject,true] call KISKA_fnc_reassignCurator;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_reassignCurator";

if (!hasInterface) exitWith {false};

params [
	["_curatorObject",objNull,[objNull,""]],
	["_isManual",false,[true]]
];

// check if player is host or admin
if !(call KISKA_fnc_isAdminOrHost) exitWith {
	if (_isManual) then {
		hint "Only admins can be assigned curator";
	};
	false
};

if (_curatorObject isEqualType "") then {
	_curatorObject = missionNamespace getVariable [_curatorObject,objNull];
};

if (isNull _curatorObject) exitWith {
	["_curatorObject isNull!",true] call KISKA_fnc_log;
	false
};

private _unitWithCurator = getAssignedCuratorUnit _curatorObject;
if (isNull _unitWithCurator) then {
	[player,_curatorObject] remoteExecCall ["assignCurator",2];
} else {
	if (alive _unitWithCurator) then {
		// no sense in alerting player if they are the curator still
		if (!(_unitWithCurator isEqualTo player)) then {
			hint "Another currently alive admin has the curator assigned to them already";
		} else {
			hint "You are already the curator";
		};

		false
	} else {
		[_unitWithCurator,_isManual,_curatorObject] spawn {
			params ["_unitWithCurator","_isManual","_curatorObject"];
			[_curatorObject] remoteExec ["unAssignCurator",2];

			// wait till curator doesn't have a unit to give it the player
			waitUntil {
				if !(isNull (getAssignedCuratorUnit _curatorObject)) exitWith {
					[player,_curatorObject] remoteExecCall ["assignCurator",2];
					if (_isManual) then {
						hint "You are now the curator";
					};
					true
				};

				[_curatorObject] remoteExec ["unAssignCurator",2];

				sleep 5;
				false
			};
		};

		true
	};
};
