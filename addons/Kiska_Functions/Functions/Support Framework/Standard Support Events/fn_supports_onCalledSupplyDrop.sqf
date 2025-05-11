/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supports_onCalledSupplyDrop

Description:
    The standard translator to handle a supply drop configured support's
     `onSupportCalled` event that is triggered by `KISKA_fnc_supports_call`.
    
    This standard handler then translates that to and actual call of
     `KISKA_fnc_supplyDrop` or `KISKA_fnc_supplyDropWithAircraft` depending
     on whether the `_argsMap` contains an `aircraftClass` key.

Parameters:
    0: _argsMap <HASHMAP> - The hashmap of args to provide to the supply drop function.

Returns:
    <BOOL>

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supports_onCalledSupplyDrop";

params [
    ["_argsMap",nil,[createHashMap]]
];

if ("aircraftClass" in _argsMap) then {
    [_argsMap] call KISKA_fnc_supplyDropWithAircraft;
} else {
    [_argsMap] call KISKA_fnc_supplyDrop;
};


true
