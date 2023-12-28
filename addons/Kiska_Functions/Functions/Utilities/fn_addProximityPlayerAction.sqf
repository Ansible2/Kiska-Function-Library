/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addProximityPlayerAction

Description:
    Adds an action to the player that will be activated and deactivated when within
     a certain radius of a given position.

Parameters:
    0: _center : <OBJECT or ARRAY> - The position the player needs to be close to.
        If array, format as Postion2D or PositionAGL.
    1: _radius : <NUMBER> - The max distance the player can be from the _center to
        get the action.
    2: _action : <ARRAY> - The action array used with "addAction" command
    3: _refreshInterval : <NUMBER> - How often to look to update action visibility

Returns:
    <NUMBER> - The porximity action id to be used with KISKA_fnc_removeProximityPlayerAction
        (-1 if failure)

Examples:
    (begin example)
        [
            cursorObject,
            15,
            ["test",{hint "action"},[]]
        ] call KISKA_fnc_addProximityPlayerAction
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addProximityPlayerAction";

if (!hasInterface) exitWith {
    ["Can't be added to headless user", false] call KISKA_fnc_log;
    -1
};


params [
    ["_center",objNull,[[],objNull]],
    ["_radius",5,[123]],
    ["_action",[],[[]]],
    ["_refreshInterval",1,[123]]
];

if (_center isEqualType objNull AND {isNull _center}) exitWith {
    ["_center is null object", true] call KISKA_fnc_log;
    -1
};


private _proximityActionId = ["KISKA_proximityPlayerActionLatestId"] call KISKA_fnc_idCounter;
private _varBase = "KISKA_proximityAction_" + (str _proximityActionId);
private _actionShouldBeRemovedVar = _varBase + "_remove";
private _actionIdVar = _varBase + "_currentId";
localNamespace setVariable [_actionShouldBeRemovedVar, false];
localNamespace setVariable [_actionIdVar, -1];

[
    {
        params [
            "_center",
            "_radius",
            "_action",
            "_refreshInterval",
            "_actionShouldBeRemovedVar",
            "_actionIdVar"
        ];

        private _actionId = localNamespace getVariable [_actionIdVar, -1];
        private _playerInRange = player distance _center <= _radius;
        private _actionIsVisible = _actionId isNotEqualTo -1;

        if (_playerInRange AND !(_actionIsVisible)) exitWith {
            _actionId = player addAction _action;
            localNamespace setVariable [_actionIdVar, _actionId];
            false;
        };

        private _endAction = localNamespace getVariable [_actionShouldBeRemovedVar, false];
        if (
            _actionIsVisible AND
            (!_playerInRange OR _endAction)
        ) then {
            player removeAction _actionId;
            localNamespace setVariable [_actionIdVar, -1];
        };

        _endAction
    },
    {
        params ["","","","","_actionShouldBeRemovedVar","_actionIdVar"];

        localNamespace setVariable [_actionShouldBeRemovedVar, nil];
        localNamespace setVariable [_actionIdVar, nil];
    },
    _refreshInterval,
    [
        _center,
        _radius,
        _action,
        _refreshInterval,
        _actionShouldBeRemovedVar,
        _actionIdVar
    ]
] call KISKA_fnc_waitUntil;


_proximityActionId
