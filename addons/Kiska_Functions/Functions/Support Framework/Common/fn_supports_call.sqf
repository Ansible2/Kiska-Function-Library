/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_call

Description:
    Triggers a given support's on call event by it's ID and will decrement its 
    number of uses left and remove it if the remaining uses is less than or equal
    to 0.

Parameters:
    0: _supportId <STRING> - The ID of the support to use.
    1: _targetPosition <PositionASL[]> - The position for the support to target.
    2: _numberOfTimesUsed <NUMBER> - Default: `1` - The number of times the support
        uses are to be decremented. A value below zero will be interpreted as zero.
    3: _onCallArgs <ANY> - Default: `[]` - Any additional arguments to provide to the
        support's configured `onSupportCalled` event. 

Returns:
    NOTHING

Examples:
    (begin example)
        // marked as using one time
        ["KISKA_support_1",[0,0,0]] call KISKA_fnc_supports_call;
    (end)

    (begin example)
        [
            "KISKA_support_1",
            getPosASL MyTarget,
            1,
            ["some_additional_args"] // additional onSupportCalled event args
        ] call KISKA_fnc_supports_call;
    (end)

    (begin example)
        // infinite uses
        ["KISKA_support_1",[0,0,0],0] call KISKA_fnc_supports_call;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_call";

params [
    ["_supportId","",[""]],
    ["_targetPosition",[],[[]],3],
    ["_numberOfTimesUsed",1,[123]],
    ["_onCallArgs",[],[]]
];

private _supportMap = call KISKA_fnc_supports_getMap;
private _supportInfo = _supportMap get _supportId;
if (isNil "_supportInfo") exitWith {
    [
        [
            "Support id ",
            _supportId,
            " does not exist in kiska support map"
        ],
        true
    ] call KISKA_fnc_log;

    nil
};

if (_numberOfTimesUsed < 0) then { _numberOfTimesUsed = 0 };

_supportInfo params ["_supportConfig","_numberOfUsesLeft"];

if (_numberOfUsesLeft < _numberOfTimesUsed) exitWith {
    [
        [
            "Support id ",
            _supportId,
            " has only ",
            _numberOfUsesLeft,
            " but was used ",
            _numberOfTimesUsed,
            " times"
        ],
        true
    ] call KISKA_fnc_log;

    nil
};

private _onCalledMap = [
    localNamespace,
    "KISKA_supports_onSupportCalledMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
private _onSupportCalledCompiled = _onCalledMap get _supportConfig;
if (isNil "_onSupportCalledCompiled") then {
    private _onSupportCalled = getText(_supportConfig >> "KISKA_supportDetails" >> "onSupportCalled");
    _onSupportCalledCompiled = compileFinal _onSupportCalled;
    _onCalledMap set [_supportConfig,_onSupportCalledCompiled];
};

private _successfullyCalled = [
    _onSupportCalledCompiled,
    [
        _supportId,
        _supportConfig,
        _targetPosition,
        _numberOfTimesUsed,
        _onCallArgs
    ]
] call CBA_fnc_directCall;
if (!_successfullyCalled) exitWith {
    [[_supportId," was not successfully called."], false] call KISKA_fnc_log;
    nil
};

private _notificationClass = _supportDetailsConfig >> "CalledNotifcation";
if (isClass _notificationClass) then {
    private _genericNotification = [_notificationClass >> "genericMessageId"] call KISKA_fnc_getConfigData;
    if !(isNil "_genericNotification") then {
        [_genericNotification] call KISKA_fnc_supports_genericNotification;
    };
};

_numberOfUsesLeft = _numberOfUsesLeft - _numberOfTimesUsed;
if (_numberOfUsesLeft <= 0) exitWith {
    [_supportId] call KISKA_fnc_supports_remove;
    nil
};

_supportMap set [_supportId,[_supportConfig,_numberOfUsesLeft]];


nil
