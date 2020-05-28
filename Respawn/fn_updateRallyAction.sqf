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


if (!isMultiplayer OR {!hasInterface}) exitWith {false};

params [
	["_playerGroup",grpNull,[grpNull]],
	["_groupName","",[""]]
];

if (isNull _playerGroup) exitWith {
	"_playerGroup " + (str _playerGroup) + "isNull" call BIS_fnc_error;
};

[
	{!isNull player AND {alive (leader (_this select 0))}},
	{	
		
		params ["_playerGroup","_groupName"];

		if !((group player) isEqualTo _playerGroup) exitWith {
			["player is not in group"] call BIS_fnc_error;
		};

		// if group name is undefined just use the groupId
		if (_groupName isEqualTo "") then {_groupName = groupId _playerGroup};

		private _leader = leader _playerGroup;
		
		// remover the action if you are not the leader, add it if you are
		if (!(isNil "KISKA_spawnId") AND {!local _leader}) then {
			
			player removeAction (missionNamespace getVariable "KISKA_spawnId");

			missionNamespace setVariable ["KISKA_spawnId",nil];
			missionNamespace setVariable ["KISKA_spawnInfo",nil];
		};
		
		if ((isNil "KISKA_spawnId") AND {local _leader}) then {
			
			private _actionId = _leader addaction [
				"<t color='#4287f5'>Place Rally Point</t>",
				{
					private _groupName = ((_this select 3) select 0);

					[_this select 1, ([_groupName,"spawnMarker"] joinString "_"), ([_groupName,"Respawn Beacon"] joinString " ")] remoteExec ["KISKA_fnc_updateRespawnMarker",2]; 		

					hint "Rally Point Updated";
				},
				[_groupName],
				1.5,
				false,
				true
			];

			// update global variables
			missionNamespace setVariable ["KISKA_spawnId",_actionId];
			missionNamespace setVariable ["KISKA_spawnInfo",[_playerGroup,_groupName]];
		};
	},
	[_playerGroup,_groupName]
] call CBA_fnc_waitUntilAndExecute;