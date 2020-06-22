/* ----------------------------------------------------------------------------
Function: KISKA_fnc_heliPatrol

Description:
	Has a helicopter patrol looking for enemy players.
    If "spotted", the helicopter will land in a safe area and drop off infantry if onboard.
    It will then move to engage the players if it has weapons or just stalk them if not.
    The infantry will continually stalk the players until dead.

    This is very simple and will likely see a new iteration that uses lineIntersects to actually simulate pilots seeing players

Parameters:
	0: _helicopter <OBJECT> - The patrolling helicopter
	1: _patrolPoints <ARRAY> - An Array of patrol points (OBJECTs or positions)
	2: _spotDistance3D <NUMBER> - How far away can the helicopter spot a player
    3. _patrolHeight <NUMBER> - What's the flying height of the helicopter
	4. _patrolSpeed <STRING> - setWaypointSpeed, takes "UNCHANGED", "LIMITED", "NORMAL", and "FULL"
    5: _randomPatrol <BOOL> - Should patrol points be randomized or followed in array order
	

Returns:
	BOOL

Examples:
    (begin example)
        [heli,[logic1,logic2,logic3],500,200,false] call KISKA_fnc_heliPatrol;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */


params [
    ["_helicopter",objNull,[objNull]],
    ["_patrolPoints",[],[[]]],
    ["_spotDistance3D",800,[123]],
    ["_patrolHeight",100,[123]],
    ["_patrolSpeed","NORMAL",[""]],
    ["_randomPatrol",true,[true]]
];

if (isNull _helicopter) exitWith {
    "_helicopter isNull" call BIS_fnc_error;
    false
};

if (_patrolHeight > _spotDistance3D) exitWith {
    "_patrolHeight is higher then _spotDistance3D. Nothing will be spotted" call BIS_fnc_error;
    false
};

if !(_patrolPoints isEqualTypeAny [objNull,[]]) exitWith {
    "_patrolPoints need to be either objects or groups" call BIS_fnc_error;
    false
};

private _pilot = currentPilot _helipcopter;

if (isNull _pilot) exitWith {
    "No pilot found in helicopter" call BIS_fnc_error;
    false
};

private _helicopterGroup = group _pilot;

_helicopter flyInHeight _patrolHeight;

[_helicopterGroup,count _patrolPoints,_patrolPoints,_randomPatrol,"SAFE",_patrolSpeed,"WHITE"] call KISKA_fnc_patrolSpecific;

[
    4,
    {
        params [
            ["_helicopter",objNull,[objNull]],
            ["_spotDistance3D",800,[123]],
            ["_helicopterGroup",grpNull,[grpNull]]
        ];

        private _players = call CBA_fnc_players;
        private _index = _players findIf {(_x distance _helicopter) <= _spotDistance3D};
        private _nearestPlayer = _players select _index;
        private _playerPosition = getPosATL _nearestPlayer;
    
        private _landingZone = [_nearestPlayer,300,500,5,0,0,0,[],[_playerPosition,_playerPosition]] call BIS_fnc_findSafePos;
        _landingZone pushBack 0;

        [_helicopterGroup] call CBA_fnc_clearWaypoints;
        [_helicopterGroup,_landingZone,0,"TR UNLOAD","AWARE","WHITE","NORMAL"] call CBA_fnc_addwaypoint;

        private _groups = [];

        (crew _helicopter) apply {
            private _group = group _x;

            if (!(_group in _groups) AND {!(_group isEqualTo _helicopterGroup)}) then {
                _groups pushBack _group
            };
        };


        [
            2,
            {
                params [
                    "_helicopter",
                    "_helicopterGroup",
                    "_nearestPlayer",
                    "_groups"
                ];
                private _playerGroup = group _nearestPlayer;

                [
                    1,
                    {
                        [_this select 1,_this select 2] spawn BIS_fnc_stalk;
                        (_this select 1) setCombatMode "RED";
                    },
                    // if the crew in the helicopter is the same amount as what's in the pilot's group e.g. all passengers are out
                    {count (crew (_this select 0)) isEqualTo (count (units (_this select 1)))},
                    [_helicopter,_helicopterGroup,_playerGroup]
                ] call KISKA_fnc_waitUntil;

                _groups apply {
                    [_x,_playerGroup] spawn BIS_fnc_stalk;
                    _x setCombatMode "YELLOW";
                };
                
            },
            {(getPosATLVisual (_this select 0) select 2) < 2},
            [_helicopter,_helicopterGroup,_nearestPlayer,_groups]
        ] call KISKA_fnc_waitUntil;

        
    },
    {
        // waitUntil heli finds an enemy player within the specified distance. Civilians seem to sometimes count as enemy
        !(
            ((call CBA_fnc_players) findIf {
                ([side _x,side (_this select 2)] call BIS_fnc_sideIsEnemy) AND 
                {(_x distance (_this select 0)) <= (_this select 1)} AND 
                {side _x != Civilian}
            }) isEqualTo -1
        )
    },
    [_helicopter,_spotDistance3D,_helicopterGroup]
] call KISKA_fnc_waitUntil;


true