#include "Headers\CAS Titles.hpp"
#include "Headers\CAS Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getCasTitleFromId

Description:
	Takes a number (id) and translates it into the title name for that number.
	Used to fill out menus with a consistent string for the corresponding round type.

Parameters:
	0: _id : <NUMBER> - The ammo type ID

Returns:
	<STRING> - ClassName for the corresponding Id number, otherwise empty string

Examples:
    (begin example)
		_title = [0] call KISKA_fnc_getCasTitleFromId
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getCasTitleFromId";


#define CHECK_ID(AMMO_TYPE,TITLE) if (_id isEqualTo AMMO_TYPE) exitWith {TITLE};


params [
	["_id",0,[123]]
];


CHECK_ID(GUN_RUN_ID,GUN_RUN_TITLE)
CHECK_ID(GUNS_AND_ROCKETS_ARMOR_PIERCING_ID,GUNS_AND_ROCKETS_ARMOR_PIERCING_TITLE)
CHECK_ID(GUNS_AND_ROCKETS_HE_ID,GUNS_AND_ROCKETS_HE_TITLE)
CHECK_ID(ROCKETS_ARMOR_PIERCING_ID,ROCKETS_ARMOR_PIERCING_TITLE)
CHECK_ID(ROCKETS_HE_ID,ROCKETS_HE_TITLE)
CHECK_ID(AGM_ID,AGM_TITLE)
CHECK_ID(BOMB_LGB_ID,BOMB_LGB_TITLE)
CHECK_ID(BOMB_CLUSTER_ID,BOMB_CLUSTER_TITLE)


// return empty string if not found
""
