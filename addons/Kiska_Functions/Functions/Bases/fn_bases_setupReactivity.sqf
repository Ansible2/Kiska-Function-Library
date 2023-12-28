/* ----------------------------------------------------------------------------
Function: KISKA_fnc_bases_setupReactivity

Description:
    Adds values and eventhandlers to the given group's namespace to be able to 
     interact with KISKA bases reaction system

Parameters:
    0: _group <GROUP> - The group to add setup reactions for
    1: _reinforceId <NUMBER or STRING> - A globally unqiue identifier for this group (or a collection of groups)
    2: _canCallIds <STRING[]> - An array of _reinforceIds denoting groups that will respond to
        distress calls from this group
    3: _priority <NUMBER> - a number signifying how important this group's call will be
        (if a group is responding to another call, they will break away from it for this call if higher)
    4: _onEnemyDetected <CODE or STRING> - Code that will be executed when the group enters combat.
        Must return a boolean that denotes whether to execute default functionality that happens
        with the event (see KISKA_fnc_bases_triggerReaction).
        
        Parameters:
        - 0: <GROUP> - The group the event is triggering for
        - 1: <OBJECT> - The enemy unit that was detected
        - 2: <ARRAY> - An array of GROUPs that can respond to the call (based on _canCallIds)
        - 3: <NUMBER> - The same _priority

Returns:
    <NUMBER> - The event id of the EnemyDetected group eventhandler

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
    ["_onEnemyDetected",{},["",{}]]
];

if (isNull _group) exitWith {
    ["Null group passed",true] call KISKA_fnc_log;
    -1
};


_group setVariable ["KISKA_bases_canCallReinforceIds", _canCallIds];
_group setVariable ["KISKA_bases_reinforcePriority", _priority];
_group setVariable ["KISKA_bases_reinforceId", _reinforceId];

if (_onEnemyDetected isEqualType "") then {
    _onEnemyDetected = compile _onEnemyDetected;
};
_group setVariable ["KISKA_bases_reinforceOnEnemyDetected",_onEnemyDetected];



if (isNil "KISKA_bases_reinforceGroupsMap") then {
    missionNamespace setVariable ["KISKA_bases_reinforceGroupsMap",createHashMap];
};

private _entryWithId = KISKA_bases_reinforceGroupsMap getOrDefault [_reinforceId,[]];
private _idTaken = _entryWithId isNotEqualTo [];
if (_idTaken) then {
    _entryWithId pushBackUnique _group;
} else {
    KISKA_bases_reinforceGroupsMap set [_reinforceId,[_group]];
};


_group addEventHandler ["EnemyDetected",KISKA_fnc_bases_triggerReaction];
