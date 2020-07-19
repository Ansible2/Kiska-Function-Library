KISKA_respawnStateMachine = call CBA_statemachine_fnc_create;

// create a starting state to sit at while we wait for group and player to be defined
[KISKA_respawnStateMachine,{},{},{},"start_state"] call CBA_statemachine_fnc_addState;

// checking if player and his group is defined first before moving to next state
[
	KISKA_respawnStateMachine,
	"start_state",
	"playerAndGroupReady_state",
	{!isNull player AND {!isNull (group player)}},
	{diag_log "player and group defined";}
] call CBA_statemachine_fnc_addTransition;

// dummy state to proceed to once player is ready, this is for easier mapping of the machine
[KISKA_respawnStateMachine,{},{diag_log "player and group ready";},{},"playerAndGroupReady_state"] call CBA_statemachine_fnc_addState;

// our first branch is whether or not the player is the leader
[
	KISKA_respawnStateMachine,
	"playerAndGroupReady_state",
	"playerIsLeader_state",
	{leader (group player) isEqualTo player},
	{diag_log "player is leader";}
] call CBA_statemachine_fnc_addTransition;
[
	KISKA_respawnStateMachine,
	"playerAndGroupReady_state",
	"playerIsNotLeader_state",
	{!(leader (group player) isEqualTo player)},
	{diag_log "player is not leader";}
] call CBA_statemachine_fnc_addTransition;


//// branching off now between choices

[KISKA_respawnStateMachine,{},{diag_log "Proceeding from player is leader confirmation";},{},"playerIsLeader_state"] call CBA_statemachine_fnc_addState;
[
	KISKA_respawnStateMachine,
	"playerIsLeader_state",
	"start_state",
	{!isNil "KISKA_respawnActionID"},
	{diag_log "player has the action already, going back to start";}
] call CBA_statemachine_fnc_addTransition;
[
	KISKA_respawnStateMachine,
	"playerIsLeader_state",
	"giveAction_state",
	{isNil "KISKA_respawnActionID"},
	{diag_log "player does not have action, gotta give them the action";}
] call CBA_statemachine_fnc_addTransition;
[KISKA_respawnStateMachine,{},{diag_log "Player given action";},{},"giveAction_state"] call CBA_statemachine_fnc_addState;
[
	KISKA_respawnStateMachine,
	"playerIsLeader_state",
	"start_state",
	{},
	{diag_log "player has been given the action, going back to start";}
] call CBA_statemachine_fnc_addTransition;



[KISKA_respawnStateMachine,{},{diag_log "Proceeding from player is NOT leader confirmation";},{},"playerIsNotLeader_state"] call CBA_statemachine_fnc_addState;
[
	KISKA_respawnStateMachine,
	"playerIsNotLeader_state",
	"deleteAction_state",
	{!isNil "KISKA_respawnActionID"},
	{diag_log "Player has action, it will be deleted"; missionNamespace setVariable ["KISKA_respawnStateMachine",nil];}
] call CBA_statemachine_fnc_addTransition;
[
	KISKA_respawnStateMachine,
	"playerIsNotLeader_state",
	"start_state",
	{isNil "KISKA_respawnActionID"},
	{diag_log "Player does NOT have action, going back to start";}
] call CBA_statemachine_fnc_addTransition;
[KISKA_respawnStateMachine,{},{diag_log "Action deleted";},{},"deleteAction_state"] call CBA_statemachine_fnc_addState;
[
	KISKA_respawnStateMachine,
	"deleteAction_state",
	"start_state",
	{},
	{diag_log "player has had the action deleted, going back to start";}
] call CBA_statemachine_fnc_addTransition;