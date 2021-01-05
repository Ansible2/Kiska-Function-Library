/* ----------------------------------------------------------------------------
Function: KISKA_fnc_updateRallyAction

Description:
	Updates the rally point action for KISKA's respawn system; 
	This will be called (on all players) when a new player joins the group to possibly reassign the action if they are the new leader

Parameters:
	0: _playerGroup <GROUP> - The ship to attach the pods to
	1: _groupName <STRING> - (OPTIONAL) The name of the group you would like to appear on the marker set

Returns:
	NOTHING

Examples:
    (begin example)
		Initialized by KISKA_fnc_initializeRespawnSystem
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!isMultiplayer OR {!hasInterface} OR {!canSuspend}) exitWith {};

params [
	["_playerGroup",grpNull,[grpNull]],
	["_groupName","",[""]]
];

if (isNull _playerGroup) exitWith {
	"_playerGroup " + (str _playerGroup) + "isNull" call BIS_fnc_error;
};


private _player = call KISKA_fnc_getPlayerObject;

// waitUntil leader is alive
waitUntil {
	if (alive (leader _playerGroup)) exitWith {true};
	sleep 1;
	false
};


if !((group _player) isEqualTo _playerGroup) exitWith {
	"player is not in group" call BIS_fnc_error;
};

// if group name is undefined just use the groupId
if (_groupName isEqualTo "") then {_groupName = groupId _playerGroup};


private _leader = leader _playerGroup;
// remove the action if you are not the leader and have it
if ((!isNil "KISKA_spawnId") AND {!local _leader}) then {
	
	_player removeAction KISKA_spawnId;

	KISKA_spawnId = nil;
	KISKA_spawnInfo = nil;
};

// if you do not have the action registered and are the leader, add the action
if ((isNil "KISKA_spawnId") AND {local _leader}) then {
	
	private _actionId = _player addaction [
		"<t color='#4287f5'>Place Rally Point</t>",
		{
			private _groupName = param [3];

			[_this select 1, ([_groupName,"spawnMarker"] joinString "_"), ([_groupName,"Respawn Beacon"] joinString " ")] remoteExecCall ["KISKA_fnc_updateRespawnMarker",2]; 		

			hint "Rally Point Updated";
		},
		_groupName,
		1.5,
		false,
		true
	];

	// update global variables
	KISKA_spawnId = _actionId;
	KISKA_spawnInfo = [_playerGroup,_groupName]; 
};