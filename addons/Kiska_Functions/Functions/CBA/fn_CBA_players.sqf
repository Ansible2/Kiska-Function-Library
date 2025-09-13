/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_players

Description:
    Copied function `CBA_fnc_players` from CBA3.

    Reports all (human) player objects. Does not include headless client entities.

Parameters:
    NONE

Returns:
    <OBEJCT[]> - a list of all player objects.

Example:
    (begin example)
        private _players = call KISKA_fnc_CBA_players;
    (end)

Author(s):
    esteldunedain and PabstMirror, donated from ACE3,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_players";

private _units = allUnits;
_units append allDeadMen;
_units select {
    (isPlayer _x) AND { !(_x isKindOf "HeadlessClient_F") }
}
