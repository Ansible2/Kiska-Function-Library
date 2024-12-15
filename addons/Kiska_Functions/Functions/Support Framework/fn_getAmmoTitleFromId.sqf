#include "..\..\Headers\Support Framework\Arty Ammo Titles.hpp"
#include "..\..\Headers\Support Framework\Arty Ammo Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getAmmoClassFromId

Description:
    Takes a number (id) and translates it into the title name for that number.
    Used to fill out menus with a consistent string for the corresponding round type.

Parameters:
    0: _id : <NUMBER> - The ammo type ID

Returns:
    <STRING> - ClassName for the corresponding Id number, otherwise empty string

Examples:
    (begin example)
        _title = [0] call KISKA_fnc_getAmmoClassFromId
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getAmmoTitleFromId";


#define CHECK_ID(AMMO_TYPE,TITLE) if (_id isEqualTo AMMO_TYPE) exitWith {TITLE};


params [
    ["_id",0,[123]]
];

// 155
CHECK_ID(AMMO_155_HE_ID, AMMO_155_HE_TITLE)
CHECK_ID(AMMO_155_CLUSTER_ID, AMMO_155_CLUSTER_TITLE)
CHECK_ID(AMMO_155_MINES_ID, AMMO_155_MINES_TITLE)
CHECK_ID(AMMO_155_ATMINES_ID, AMMO_155_ATMINES_TITLE)

// 120
CHECK_ID(AMMO_120_HE_ID, AMMO_120_HE_TITLE)
CHECK_ID(AMMO_120_CLUSTER_ID, AMMO_120_CLUSTER_TITLE)
CHECK_ID(AMMO_120_MINES_ID, AMMO_120_MINES_TITLE)
CHECK_ID(AMMO_120_ATMINES_ID, AMMO_120_ATMINES_TITLE)
CHECK_ID(AMMO_120_SMOKE_ID, AMMO_120_SMOKE_TITLE)

// 82
CHECK_ID(AMMO_82_HE_ID, AMMO_82_HE_TITLE)
CHECK_ID(AMMO_82_FLARE_ID, AMMO_82_FLARE_TITLE)
CHECK_ID(AMMO_82_SMOKE_ID, AMMO_82_SMOKE_TITLE)

// 230
CHECK_ID(AMMO_230_HE_ID, AMMO_230_HE_TITLE)
CHECK_ID(AMMO_230_CLUSTER_ID, AMMO_230_CLUSTER_TITLE)


// return empty string if not found
""
