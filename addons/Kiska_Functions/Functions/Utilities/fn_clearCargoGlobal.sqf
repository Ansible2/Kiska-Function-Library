/* ----------------------------------------------------------------------------
Function: KISKA_fnc_clearCargoGlobal

Description:
    Deletes all cargo from the specified object on all machines.

Parameters:
    0: _object <OBJECT> - The object to delete all cargo from.

Returns:
    NOTHING

Examples:
    (begin example)
        [myVehicle] call KISKA_fnc_clearCargoGlobal;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_clearCargoGlobal";

params [
    ["_object",objNull,[objNull]]
];

if (isNull _object) exitWith {};

clearMagazineCargoGlobal _object;
clearWeaponCargoGlobal _object;
clearBackpackCargoGlobal _object;
clearItemCargoGlobal _object;
