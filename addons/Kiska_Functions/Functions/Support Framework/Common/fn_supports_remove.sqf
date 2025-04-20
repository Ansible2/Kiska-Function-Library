/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_remove

Description:
    Removes a support from the local player's support KISKA support pool.

    Also calls the supports configured `onSupportRemoved` event.

Parameters:
    0: _supportId <STRING> - The ID of the support to remove.

Returns:
    <[CONFIG,NUMBER]> - The support config and the number of uses left.

Examples:
    (begin example)
        ["KISKA_support_1"] call KISKA_fnc_supports_remove;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_remove";

params [
    ["_supportId","",[""]]
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


_supportInfo params ["_supportConfig"];
private _onSupportRemovedMap = [
    localNamespace,
    "KISKA_supports_onSupportRemovedMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
private _onSupportRemovedCompiled = _onSupportRemovedMap get _supportConfig;
if (isNil "_onSupportRemovedCompiled") then {
    private _onSupportRemoved = getText(_supportConfig >> "KISKA_supportDetails" >> "onSupportRemoved");
    _onSupportRemovedCompiled = compileFinal _onSupportRemoved;
    _onSupportRemovedMap set [_supportConfig,_onSupportRemovedCompiled];
};

[
    _onSupportRemovedCompiled,
    [_supportId,_supportConfig]
] call CBA_fnc_directCall;

_supportMap deleteAt _supportId
