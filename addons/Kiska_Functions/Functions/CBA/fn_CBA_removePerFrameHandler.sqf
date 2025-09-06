/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_removePerFrameHandler

Description:
    Copied version of the CBA system that enables `CBA_fnc_removePerFrameHandler`.

    Removes a per frame handler created with `KISKA_fnc_CBA_addPerFrameHandler`.

Parameters:
    0: _function <CODE> - Code that will execute that the given interval.
    1: _delay <NUMBER> Default: `0` - The number of seconds between each execution.
        If `0`, the code will be executed every frame.
    2: _args <ANY> Default: `[]` - Parameters passed to the function executing. This will be the 
        same reference every execution.

Returns:
    <BOOL> - `true` if removed successful, `false` otherwise.

Example:
    (begin example)
        0 spawn {
            private _handle = [
                {
                    player sideChat format["every frame! _this: %1", _this];
                },
                0,
                ["some","params",1,2,3]
            ] call KISKA_fnc_CBA_addPerFrameHandler;
            
            sleep 10;
            
            _handle call KISKA_fnc_CBA_removePerFrameHandler;
        };
    (end)

Author(s):
    Nou & Jaynus, donated from ACRE project code for use by the community; commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_removePerFrameHandler";

params [
    ["_handle", -1, [0]]
];

[
    {
        params ["_handle"];

        private _index = KISKA_CBA_PFHhandles param [_handle];
        if (isNil "_index") exitWith {false};

        KISKA_CBA_PFHhandles set [_handle, nil];
        (KISKA_CBA_perFrameHandlerArray select _index) set [0, {}];

        if (KISKA_CBA_perFrameHandlersToRemove isEqualTo []) then {
            {
                KISKA_CBA_perFrameHandlersToRemove apply {
                    KISKA_CBA_perFrameHandlerArray set [_x, objNull];
                };

                KISKA_CBA_perFrameHandlerArray = KISKA_CBA_perFrameHandlerArray - [objNull];
                KISKA_CBA_perFrameHandlersToRemove = [];

                {
                    KISKA_CBA_PFHhandles set [(_x select 5), _forEachIndex];
                } forEach KISKA_CBA_perFrameHandlerArray;
            } call KISKA_fnc_CBA_execNextFrame;
        };

        KISKA_CBA_perFrameHandlersToRemove pushBackUnique _index;
        true
    }, 
    _handle
] call KISKA_fnc_CBA_directCall;

