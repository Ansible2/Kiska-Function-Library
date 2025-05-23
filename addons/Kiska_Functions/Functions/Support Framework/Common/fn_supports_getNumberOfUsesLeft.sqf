/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_getNumberOfUsesLeft

Description:
    Gets the specific number of uses left for a given support by its ID

Parameters:
    0: _supportId <STRING> - The ID of the support to check.

Returns:
    <NUMBER | NIL> - the number of support uses left or `nil` if the support ID is not found

Examples:
    (begin example)
        private _numberLeft = ["KISKA_support_1"] call KISKA_fnc_supports_getNumberOfUsesLeft;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_getNumberOfUsesLeft";

params [
    ["_supportId","",[""]]
];

private _supportMap = call KISKA_fnc_supports_getMap;
private _supportInfo = _supportMap get _supportId;
if (isNil "_supportInfo") exitWith { nil };
_supportInfo params ["","_numberOfUsesLeft"];


_numberOfUsesLeft
