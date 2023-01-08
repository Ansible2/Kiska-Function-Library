/* ----------------------------------------------------------------------------
Function: KISKA_fnc_heliPatrol

Description:
    Has a helicopter patrol looking for enemy men.
    If "spotted", the helicopter will land in a safe area and drop off infantry if onboard.
    It will then move to engage the units if it has weapons or just stalk them if not.
    The infantry will continually stalk the unit until dead.

Parameters:
    0: _helicopter <OBJECT> - The patrolling helicopter
    1: _patrolPoints <ARRAY> - An Array of patrol points (OBJECTs or positions)
    2: _spotDistance3D <NUMBER> - How far away can the helicopter spot a player
    3: _patrolHeight <NUMBER> - What's the flying height of the helicopter
    4: _patrolSpeed <STRING> - setWaypointSpeed, takes "UNCHANGED", "LIMITED", "NORMAL", and "FULL"
    5: _randomPatrol <BOOL> - Should patrol points be randomized or followed in array order


Returns:
    <BOOL> - True if helicopter will patrol, false if problem encountered

Examples:
    (begin example)
        [heli,[logic1,logic2,logic3],500,200,false] call KISKA_fnc_heliPatrol;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_heliPatrol";

params [
    ["_helicopter",objNull,[objNull]],
    ["_patrolPoints",[],[[]]],
    ["_spotDistance3D",800,[123]],
    ["_patrolHeight",100,[123]],
    ["_patrolSpeed","NORMAL",[""]],
    ["_randomPatrol",true,[true]]
];

if (isNull _helicopter) exitWith {
    ["_helicopter is a null object",true] call KISKA_fnc_log;
    false
};

if (_patrolHeight > _spotDistance3D) exitWith {
    [[_patrolHeight," is higher then ",_spotDistance3D,". The helicopter can't spot anything"],true] call KISKA_fnc_log;
    false
};

if !(_patrolPoints isEqualTypeAny [objNull,[]]) exitWith {
    [[_patrolPoints," need to be either positions or objects, exiting..."],true] call KISKA_fnc_log;
    false
};

private _pilot = currentPilot _helicopter;

if (isNull _pilot) exitWith {
    [["No pilot found in ",_helicopter],true] call KISKA_fnc_log;
    false
};

private _helicopterGroup = group _pilot;
[_helicopterGroup,true] call KISKA_fnc_ACEX_setHCTransfer;
_helicopter flyInHeight _patrolHeight;

[_helicopterGroup,_patrolPoints,count _patrolPoints,_randomPatrol,"SAFE",_patrolSpeed,"WHITE"] call KISKA_fnc_patrolSpecific;



[_helicopter,_spotDistance3D,_helicopterGroup] spawn {
    params ["_helicopter","_spotDistance3D","_helicopterGroup"];

    // search for targets
    private ["_targets","_foundTargetIndex"];
    private _helicopterSide = side _helicopterGroup;
    waitUntil {
        _targets = _helicopter nearEntities ["MAN",_spotDistance3D];
        _foundTargetIndex = _targets findIf {
                ([side _x,_helicopterSide] call BIS_fnc_sideIsEnemy) AND
                {(_x distance _helicopter) <= _spotDistance3D} AND
                {side _x != Civilian}
            };
        if (_foundTargetIndex isNotEqualTo -1) exitWith {true};
        sleep 4;
        false
    };
    // Move to land
    private _foundTarget = _targets select _foundTargetIndex;
    private _foundTargetPosition = getPosATL _foundTarget;

    private _landingZone = [_foundTarget,300,500,5,0,0,0,[],[_foundTargetPosition,_foundTargetPosition]] call BIS_fnc_findSafePos;
    _landingZone pushBack 0;

    [_helicopterGroup] call KISKA_fnc_clearWaypoints;
    [_helicopterGroup,_landingZone,0,"TR UNLOAD","AWARE","WHITE","NORMAL"] call CBA_fnc_addwaypoint;


    // waituntil the helicopter is about to land
    waitUntil {
        sleep 2;
        ((getPosATLVisual _helicopter select 2) < 2)
    };
    // tell all groups that in the aircraft that aren't crew to stalk the target group
    private _targetGroup = group _foundTarget;
    private _groups = [];
    (crew _helicopter) apply {
        private _group = group _x;
        if (!(_group in _groups) AND {_group isNotEqualTo _helicopterGroup}) then {
            _groups pushBack _group
        };
    };
    _groups apply {
        [_x,_targetGroup] spawn BIS_fnc_stalk;
        _x setCombatMode "YELLOW";
    };


    // Wait for all passengers to be out
    private _helicopterGroupCount = count (units _helicopterGroup);
    waitUntil {
        if (count (crew _helicopter) <= _helicopterGroupCount) exitWith {true};
        sleep 1;
        false
    };

    // tell the helicopter to engage the target
    [_helicopterGroup,_targetGroup] spawn BIS_fnc_stalk;
    _helicopterGroup setCombatMode "RED";
};


true
