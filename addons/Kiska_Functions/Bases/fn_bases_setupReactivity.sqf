/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_setupReactivity

Description:
	Spawns a configed KISKA base.

Parameters:
    0: _group <GROUP> - The group to add setup reactions for
    1: _reinforceId <NUMBER or STRING> - A globally unqiue identifier for this group (or a collection of groups)
    2: _canCallIds <ARRAY> - An array of _reinforceIds denoting groups that will respond to
        distress calls from this group
    3: _priority <NUMBER> - a number signifying how important this group's call will be
        (if a group is responding to another call, they will break away from it for this call if higher)
    4: _onEnteredCombat <CODE or STRING> - Code that will be executed when the group enters combat.
        Must return a boolean that denotes whether to execute default functionality that happens
        with the event (see KISKA_fnc_bases_triggerReaction).
        PARAMS:
            0: <GROUP> - The group the event is triggering for
            1: <ARRAY> - An array of GROUPs that can respond to the call (based on _canCallIds)
            1: <NUMBER> - The same _priority

Returns:
    <NUMBER> - The event id of the combatBehaviour eventhandler

Examples:
    (begin example)
		[
            aGroup,
            123,
            ["anotherGroupsId"],
            1,
            {
                hint str _this;
                false // continue with default reaction behaviour
            }
        ] call KISKA_fnc_bases_setupReactivity;
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

if (isNull _group) exitWith {
    ["Null group passed",true] call KISKA_fnc_log;
    -1
};


_group setVariable ["KISKA_bases_canCallReinforceIds", _canCallIds];
_group setVariable ["KISKA_bases_reinforcePriority", _priority];
_group setVariable ["KISKA_bases_reinforceId", _reinforceId];

if (_onEnteredCombat isEqualType "") then {
    _onEnteredCombat = compile _onEnteredCombat;
};
_group setVariable ["KISKA_bases_reinforceOnEnteredCombat",_onEnteredCombat];



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



[
    _group,
    configFile >> "KISKA_eventHandlers" >> "CombatBehaviour",
    KISKA_fnc_bases_triggerReaction
] call KISKA_fnc_eventHandler_addFromConfig;

// have something like a mission importance factor to assign in the class
// if a unit is responding to a lower priority call when called by a higher one
// they will drop that mission and move to the more important one
