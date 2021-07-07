/* ----------------------------------------------------------------------------
Function: KISKA_fnc_alivePlayers

Description:
	FInds all

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
params [
	["_seperateHeadless",true,[true]]
];

private "_alivePlayers";

if (_seperateHeadless) then {
	_alivePlayers = (call CBA_fnc_players) select {alive _x};
} else {
	_alivePlayers = allPlayers select {alive _x};
};

_alivePlayers