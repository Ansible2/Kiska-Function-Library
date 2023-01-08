/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_assignTeamCombo

Description:
    Reassigns a unit's team

Parameters:
    0: _unit <OBJECT> - The unit to reassign
    1: _team <NUMBER> - the team to assign

Returns:
    NOTHING

Examples:
    (begin example)
        [aUnit] remoteExec ["KISKA_fnc_GCH_assignTeam",LocalPlayerUnitOrLeaderOfGroup];
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_assignTeam";

if (!canSuspend) exitWith {
    ["Needs to be run in scheduled!",true] call KISKA_fnc_log;
    _this spawn KISKA_fnc_GCH_assignTeam;
};

params [
    ["_unit",objNull,[objNull]],
    ["_team",0,[123]]
];

if (isNull _unit) exitWith {
    ["Null object passed",true] call KISKA_fnc_log;
    nil
};

switch (_team) do {
    case 1:{
        _unit assignTeam "BLUE";
    };
    case 2:{
        _unit assignTeam "GREEN";
    };
    case 3:{
        _unit assignTeam "RED";
    };
    case 4:{
        _unit assignTeam "YELLOW";
    };

    default {
        _unit assignTeam "MAIN";
    };
};


nil
