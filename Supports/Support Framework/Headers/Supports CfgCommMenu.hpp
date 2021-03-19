#include "Support Type IDs.hpp"
#include "Support Icons.hpp"
#include "CAS Type IDs.hpp"
#include "Arty Ammo Type IDs.hpp"
/*
    This master function for supports is used as go between for error cases such as when 
     a player provides an invalid position (looking at the sky). It will then refund the
     support back to the player.
*/
#define CALL_SUPPORT_MASTER(CLASS) "["#CLASS",_this,%1] call KISKA_fnc_callingForSupportMaster"


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
    // _this select 0 is the classname
    managerCondition = "";
};
class KISKA_artillery_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_ARTY;   
    radiuses[] = {};
    canSelectRounds = 1;
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
class KISKA_CAS_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_CAS;
    
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

    vehicleTypes[] = {};
};

class KISKA_attackHelicopterCAS_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_ATTACKHELI_CAS;
    timeOnStation = 180;

    radiuses[] = {};
    flyinHeights[] = {};
    vehicleTypes[] = {};
};
class KISKA_helicopterCAS_baseClass : KISKA_basicSupport_baseClass
{
    supportTypeId = SUPPORT_TYPE_HELI_CAS;
    timeOnStation = 180;

    radiuses[] = {};
    flyinHeights[] = {};
    vehicleTypes[] = {};
};

class KISKA_testArty : KISKA_artillery_baseClass
{
    text = "Test Arty";
    expression = CALL_SUPPORT_MASTER(KISKA_testArty);
    radiuses[] = {100};
};

class KISKA_testCAS : KISKA_CAS_baseClass
{
    text = "Test CAS";
    expression = CALL_SUPPORT_MASTER(KISKA_testCAS);
    vehicleTypes[] = {};
};

class KISKA_testHeliCAS : KISKA_attackHelicopterCAS_baseClass
{
    text = "Test Heli CAS";
    expression = CALL_SUPPORT_MASTER(KISKA_testHeliCAS);
    
    timeOnStation = 180;

    vehicleTypes[] = {"B_Heli_Attack_01_dynamicLoadout_F"};
    radiuses[] = {250};
    flyinHeights[] = {50};
};