/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCH_getPlayerSide

Description:
    Returns the side of the player's group in order to avoid if the player is
     captive and the object is technically a part of the civ faction for instance.

Parameters:
    NONE

Returns:
    <SIDE> - The side of the player's group

Examples:
    (begin example)
        private _playerSide = call KISKA_fnc_GCH_getPlayerSide;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_GCH_getPlayerSide";

if (!hasInterface) exitWith {
    sideLogic
};


side (group player)