/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_onSupportSelected

Description:
    Triggers when a communication menu item is selected from the commanding menu.

    Activates the given support's `onSupportSelected` event.

Parameters:
    0: _supportId <STRING> - The KISKA support id of the selected support.
    1: _targetPosition <PositionASL[]> - The position of the player's cursor in the map
        or where they are looking if it is 3d.
    2: _cursorTarget <OBJECT> - The `cursorTarget` at the time of the selection.
    3: _is3D <BOOL> - Whether or not the support was selected in the map or while
        not looking at the map.

Returns:
    NOTHING

Examples:
    (begin example)
        ["myClass",_this] call KISKA_fnc_commMenu_onSupportSelected;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_onSupportSelected";

params [
    "_supportId",
    "_targetPosition",
    "_cursorTarget",
    "_is3D"
];

private _supportMap = call KISKA_fnc_supports_getMap;
private _supportInfo = _supportMap get _supportId;
_supportInfo params ["_supportConfig","_numberOfUsesLeft"];

private _onSupportSelectedMap = [
    localNamespace,
    "KISKA_commMenu_onSupportSelectedMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _onSupportSelectedCompiled = _onSupportSelectedMap get _supportConfig;
if (isNil "_onSupportSelectedCompiled") then {
    private _onSupportSelected = getText(_supportConfig >> "KISKA_commMenuDetails" >> "onSupportSelected");
    _onSupportSelectedCompiled = compileFinal _onSupportSelected;
    _onSupportSelectedMap set [_supportConfig,_onSupportSelectedCompiled];
};

[
    _onSupportSelectedCompiled,
    [
        _supportId,
        _supportConfig,
        _targetPosition,
        _numberOfUsesLeft,
        _is3D,
        _cursorTarget
    ]
] call KISKA_fnc_CBA_directCall;


nil
