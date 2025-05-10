/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_getCommonTargetPosition

Description:
    Retrieves either the position the player is currently looking at or if the 
    map is open, their cursor position.

Parameters:
    NONE

Returns:
    <PositionASL[]> - The common target point.

Examples:
    (begin example)
        private _positionToTarget = call KISKA_fnc_supports_getCommonTargetPosition;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_getCommonTargetPosition";

if (visibleMap) exitWith { call KISKA_fnc_getMapCursorPosition };

call KISKA_fnc_getPositionPlayerLookingAt
