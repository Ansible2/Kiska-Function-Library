/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_setStoredLoadout

Description:
    When a unit has it's loadout adjusted for an ambient animation, the loadout
     they previously had is stored and restored after their ambient animation stops.

Parameters:
    0: _unit <OBJECT> - The unit to animate
    1: _loadout <ARRAY> - The loadout to store

Returns:
    NOTHING

Examples:
    (begin example)
        [
            someUnit,
            getUnitLoadout someUnit
        ] call KISKA_fnc_ambientAnim_setStoredLoadout;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_setStoredLoadout";

params [
    ["_unit",objNull,[objNull]],
    ["_loadout",[],[[]]]
];

if (isNull _unit) exitWith {
    ["null unit passed",true] call KISKA_fnc_log;
    nil
};

private _ambientAnimInfoMap = _unit getVariable "KISKA_ambientAnimMap";
if (isNil "_ambientAnimInfoMap") exitWith {
    [[_unit," does not have a KISKA_ambientAnimMap within their namespace"],true] call KISKA_fnc_log;
    nil
};

_ambientAnimInfoMap set ["_unitLoadout",_loadout];


nil
