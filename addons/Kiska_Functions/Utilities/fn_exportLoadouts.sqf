/* ----------------------------------------------------------------------------
Function: KISKA_fnc_exportLoadouts

Description:
    Sends a vehicle to a given point and fastropes the given units from the helicopter.

    Pilots should ideally be placed in "CARELESS" behaviour when around enemies.

Parameters:
    0: _units <OBJECT[] or OBJECT> - The units to get the loadouts of
    1: _exportAsConfig <BOOL> - Will export list in config array format ({} instead of [])

Returns:
    <STRING> - An array of loadouts as a string. This will be either 

Examples:
    (begin example)
        private _loadouts = [_units,true] call KISKA_fnc_exportLoadouts;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_exportLoadouts";

params [
    ["_units",[],[[],objNull]],
    ["_exportAsConfig",true,[false]]
];

if (_units isEqualType objNull) then {
    _units = [_units];
};

private _loadoutsAsString = "[";
private _loadouts = _units apply {
    private _loadout = getUnitLoadout _x;
    if (_loadout isEqualTo []) then {
        continue;
    };

    _loadoutsAsString = _loadoutsAsString + (endl + str _loadout + ",");
};

_loadoutsAsString = (_loadoutsAsString trim [",",2]) + endl + "]";
if (_exportAsConfig) then {
    _loadoutsAsString = _loadoutsAsString regexReplace ["\[","{"];
    _loadoutsAsString = _loadoutsAsString regexReplace ["\]","}"];
};


_loadoutsAsString
