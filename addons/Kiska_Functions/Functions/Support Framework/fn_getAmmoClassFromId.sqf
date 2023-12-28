#include "..\..\Headers\Support Framework\Arty Ammo Classes.hpp"
#include "..\..\Headers\Support Framework\Arty Ammo Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getAmmoClassFromId

Description:
    Takes a number (id) and translates it into the class name for that number

Parameters:
    0: _id : <NUMBER> - The ammo type ID

Returns:
    <STRING> - ClassName for the corresponding Id number, otherwise empty string

Examples:
    (begin example)
        _class = [0] call KISKA_fnc_getAmmoClassFromId
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getAmmoClassFromId";


#define CHECK_ID(AMMO_TYPE,CLASS) if (_id isEqualTo AMMO_TYPE) exitWith {CLASS};


params [
    ["_id",0,[123]]
];

// 155
CHECK_ID(AMMO_155_HE_ID, AMMO_155_HE_CLASS)
CHECK_ID(AMMO_155_CLUSTER_ID, AMMO_155_CLUSTER_CLASS)
CHECK_ID(AMMO_155_MINES_ID, AMMO_155_MINES_CLASS)
CHECK_ID(AMMO_155_ATMINES_ID, AMMO_155_ATMINES_CLASS)

// 120
CHECK_ID(AMMO_120_HE_ID, AMMO_120_HE_CLASS)
CHECK_ID(AMMO_120_CLUSTER_ID, AMMO_120_CLUSTER_CLASS)
CHECK_ID(AMMO_120_MINES_ID, AMMO_120_MINES_CLASS)
CHECK_ID(AMMO_120_ATMINES_ID, AMMO_120_ATMINES_CLASS)
CHECK_ID(AMMO_120_SMOKE_ID, AMMO_120_SMOKE_CLASS)

// 82
CHECK_ID(AMMO_82_HE_ID, AMMO_82_HE_CLASS)
CHECK_ID(AMMO_82_FLARE_ID, AMMO_82_FLARE_CLASS)
CHECK_ID(AMMO_82_SMOKE_ID, AMMO_82_SMOKE_CLASS)

// 230
CHECK_ID(AMMO_230_HE_ID, AMMO_230_HE_CLASS)
CHECK_ID(AMMO_230_CLUSTER_ID, AMMO_230_CLUSTER_CLASS)


// return empty string if not found
""
