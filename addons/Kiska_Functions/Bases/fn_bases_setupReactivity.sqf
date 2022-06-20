/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_setupReactivity

Description:
	Spawns a configed KISKA base.

Parameters:
    0:  <> -

Returns:
    <> -

Examples:
    (begin example)
		[
            aGroup,
            aGroup getVariable ["KISKA_bases_config"]
        ] call KISKA_fnc_createBaseFromConfig;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_bases_setupReactivity";

params [
    ["_group",grpNull,[grpNull]],
    ["_reinforceId","",[123,""]],
    ["_canCallIds",[],[[]]],
    ["_priority",1,[123]],
    ["_onEnteredCombat",{},["",{}]]
];

// what the groups reinforce class is
// what groups can respond to the this group's call

// verify params

/* ----------------------------------------------------------------------------

---------------------------------------------------------------------------- */
_group setVariable ["KISKA_bases_canCallReinforceIds",_canCallIds];
_group setVariable ["KISKA_bases_reinforcePriority",_priority];

if (_onEnteredCombat isEqualType "") then {
    _onEnteredCombat = compile _onEnteredCombat;
};
_group setVariable ["KISKA_bases_reinforceOnEnteredCombat",_onEnteredCombat];


/* ----------------------------------------------------------------------------

---------------------------------------------------------------------------- */
if (isNil "KISKA_bases_reinforceGroupsMap") then {
    missionNamespace setVariable ["KISKA_bases_reinforceGroupsMap",createHashMap];
};

private _entryWithId = KISKA_bases_reinforceGroupsMap getOrDefault [_reinforceId,[]];
private _idTaken = _entryWithId isNotEqualTo [];
if (_idTaken) then {
    _entryWithId pushBackUnique _group;
};

if !(_idTaken) then {
    KISKA_bases_reinforceGroupsMap set [_reinforceId,[_group]];
};


/* ----------------------------------------------------------------------------

---------------------------------------------------------------------------- */
[
    _x,
    configFile >> "KISKA_eventHandlers" >> "CombatBehaviour",
    KISKA_fnc_bases_triggerReaction
] call KISKA_fnc_eventHandler_addFromConfig;

// have something like a mission importance factor to assign in the class
// if a unit is responding to a lower priority call when called by a higher one
// they will drop that mission and move to the more important one
