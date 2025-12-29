/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_setPerFrameHandlerDelay

Description:
    Copied version of the CBA system that enables `CBA_fnc_setPerFrameHandlerDelay`.

    Updates the delay of an existing perFrameHandler.

    If the new delay is shorter then the previous delay and the next iteration 
     would have happend in the past, it will execute now and the following iteration 
     will be executed based on current time + new delay.

Parameters:
    0: _handle <NUMBER> - The existing perFrameHandler's ID.
    1: _delay <NUMBER> Default: `0` - The number of seconds between each execution.
        If `0`, the code will be executed every frame.

Returns:
    <BOOL> - `true` if successful, `false` otherwise

Example:
    (begin example)
        private _wasSuccessful = [
            _handle, 
            _newDelay
        ] call KISKA_fnc_CBA_setPerFrameHandlerDelay;
    (end)

Author(s):
    Mokka, OverlordZorn,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_setPerFrameHandlerDelay";

#define DELAY_INDEX 1
#define NEXT_EXECUTION_TICK_TIME_INDEX 2

params [
    ["_handle", -1, [0]], 
    ["_newDelay", 0, [0]]
];

[
    {
        params ["_handle", "_newDelay"];

        private _index = KISKA_CBA_PFHhandles param [_handle];
        if (isNil "_index") exitWith { false };

        private _handleInfo = KISKA_CBA_perFrameHandlerArray select _index;
        private _prvDelay = _handleInfo#DELAY_INDEX;
        _handleInfo set [DELAY_INDEX, _newDelay];

        private _newDelta = _handleInfo#NEXT_EXECUTION_TICK_TIME_INDEX - _prvDelay + _newDelay;
        private _tickTime = diag_tickTime;

        // if the next iteration Time with the updated delay would have been in the past,
        //  next iteration will be set to "now" so the following iteration will respect 
        //  the new delay between iterations
        if (_newDelta < _tickTime) then { _newDelta = _tickTime; };
        _handleInfo set [NEXT_EXECUTION_TICK_TIME_INDEX, _newDelta];

        true
    }, 
    [_handle, _newDelay]
] call KISKA_fnc_CBA_directCall;
