/* ----------------------------------------------------------------------------
Function: KISKA_fnc_alivePlayers

Description:
    FInds all alive players with or without headless clients

Parameters:
    0: _noHeadless <BOOL> - Seperate Headless Clients

Returns:
    _alivePlayers <ARRAY> - All alive players

Examples:
    (begin example)
        [true] call KISKA_fnc_alivePlayers;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_alivePlayers";

params [
    ["_seperateHeadless",true,[true]]
];

private "_alivePlayers";

if (_seperateHeadless) then {
    _alivePlayers = (call KISKA_fnc_CBA_players) select {alive _x};
} else {
    _alivePlayers = allPlayers select {alive _x};
};

_alivePlayers
