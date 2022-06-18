/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_setupReactivity

Description:
	Spawns a configed KISKA base.

Parameters:
    0: _baseConfig <STRING or CONFIG> - The config path of the base config or if
        in missionConfigFile >> "KISKA_bases" config, its class

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
    ["_canCallIds",[],[]]
];

// what the groups reinforce class is
// what groups can respond to the this group's call

// verify params

/* ----------------------------------------------------------------------------

---------------------------------------------------------------------------- */
if (isNil "KISKA_bases_groupCanCallReinforceMap") then {
    missionNamespace setVariable ["KISKA_bases_groupCanCallReinforceMap",createHashMap];
};
[
    KISKA_bases_groupCanCallReinforceMap,
    _group,
    _canCallIds
] call KISKA_fnc_hashmap_set;


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
private _onGroupEnteredCombat = {
    params ["_group","_combatBehaviour","_eventConfig"];

    if (_combatBehaviour == "combat") then {
        private _reinforceGroupIds = [
            KISKA_bases_groupCanCallReinforceMap,
            _group
        ] call KISKA_fnc_hashmap_get;

        private _groupsToRespond = [];
        _reinforceGroupIds apply {
            private _groups = KISKA_bases_idToReinforceGroups get _x;
            _groupsToRespond append _groups;
        };

        _groupsToRespond apply {
            /* _x setBehaviour "combat"; */
            [units _x, leader _x] remoteExec ["doFollow",leader _x];
            [leader _x,getPosATL (leader _group)] remoteExec ["move",leader _x];
            _x setBehaviour "aware";
        };
    };
};


[
    _x,
    configFile >> "KISKA_eventHandlers" >> "CombatBehaviour",
    _onGroupEnteredCombat
] call KISKA_fnc_eventHandler_addFromConfig;

// have something like a mission importance factor to assign in the class
// if a unit is responding to a lower priority call when called by a higher one
// they will drop that mission and move to the more important one
