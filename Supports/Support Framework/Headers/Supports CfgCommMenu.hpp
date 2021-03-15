#include "Support Type IDs.hpp"
#include "Support Icons.hpp"
#include "Support Classes.hpp"
#include "CAS Type IDs.hpp"
#include "Arty Ammo Type IDs.hpp"
/*
    This master function for supports is used as go between for error cases such as when 
     a player provides an invalid position (looking at the sky). It will then refund the
     support back to the player.
*/
#define CALL_SUPPORT_MASTER(CLASS) "["#CLASS",_this,[%1,-1] select isNil {%1}] call KISKA_fnc_callingForSupportMaster"


/*
// expression arguments

[caller, pos, target, is3D, id]
    caller: Object - unit which called the item, usually player
    pos: Array in format Position - cursor position
    target: Object - cursor target
    is3D: Boolean - true when in 3D scene, false when in map
    id: String - item ID as returned by BIS_fnc_addCommMenuItem function
*/

/*
	if a class is to be solely a base one, you need to include _baseClass (EXACTLY AS IT IS CASE SENSITIVE)
	 somewhere in the class name so that it can be excluded from being added to the shop
*/
class KISKA_basicSupport_baseClass
{
    text = "I'm a support!"; // text in support menu
    subMenu = "";
    expression = ""; // code to compile upon call of menu item
    icon = CALL_ICON; // icon in support menu
    curosr = SUPPORT_CURSOR;
    enable = "cursorOnGround"; // Simple expression condition for enabling the item
    removeAfterExpressionCall = 1;

    // used for support selection menu
    condition = "";
};
class KISKA_variableArtillery_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_ARTY;
    isVariable = 1;
    canSelectRadius = 0;
    canSelectRounds = 0;

    roundCount = 8; // starting round count

    ammoTypes[] = {
        AMMO_155_HE_ID,
        AMMO_155_CLUSTER_ID,
        AMMO_155_MINES_ID,
        AMMO_155_ATMINES_ID,
        AMMO_120_HE_ID,
        AMMO_120_CLUSTER_ID,
        AMMO_120_MINES_ID,
        AMMO_120_ATMINES_ID,
        AMMO_120_SMOKE_ID,
        AMMO_82_HE_ID,
        AMMO_82_FLARE_ID,
        AMMO_82_SMOKE_ID,
        AMMO_230_HE_ID,
        AMMO_230_CLUSTER_ID
    };
};
class KISKA_variableCAS_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_CAS;
    isVariable = 1;
    canSelectRadius = 0;
    canSelectBearing = 0;
    
    attackTypes[] = {
        GUN_RUN_ID,
        GUNS_AND_ROCKETS_ARMOR_PIERCING_ID,
        GUNS_AND_ROCKETS_HE_ID,
        ROCKETS_ARMOR_PIERCING_ID,
        ROCKETS_HE_ID,
        AGM_ID,
        BOMB_LGB_ID,
        BOMB_CLUSTER_ID
    };

    aircraftTypes[] = {};
};
class KISKA_variableHeli_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_HELI_CAS;

    isVariable = 1;
    canSelectRadius = 0;
    canSelectFlyinHeight = 0;
    canSelectBearing = 0;

    aircraftTypes[] = {};
};