/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_getPerFrameHandlerDelay

Description:
    Copied version of the CBA system that enables `CBA_fnc_getPerFrameHandlerDelay`.

    Returns the current delay of an existing perFrameHandler.

Parameters:
    0: _handle <NUMBER> - The existing perFrameHandler's ID.

Returns:
    <NUMBER> - Current Delay of perFrameHandler. Will return `-1` if failed.

Example:
    (begin example)
        private _currentDelay = [_handle] call KISKA_fnc_CBA_getPerFrameHandlerDelay;
    (end)

Author(s):
    Mokka, OverlordZorn,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_getPerFrameHandlerDelay";

#define DELAY_INDEX 1

params [
    ["_handle", -1, [0]]
];

[
    {
        private _index = KISKA_CBA_PFHhandles param [_handle];
        if (isNil "_index") exitWith { -1 };

        (KISKA_CBA_perFrameHandlerArray select _index) select DELAY_INDEX
    }, 
    [_handle]
] call KISKA_fnc_CBA_directCall;
