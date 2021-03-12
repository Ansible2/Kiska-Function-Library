#include "Support Radio Defines.hpp"
#include "Support Icons.hpp"
#include "Support Classes.hpp"

/*
    This master function for supports is used as go between for error cases such as when 
     a player provides an invalid position (looking at the sky). It will then refund the
     support back to the player.
*/
#define CALL_SUPPORT_MASTER(CLASS) "[_this,"#CLASS"] call KISKA_fnc_callingForSupportMaster"


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
    enable = "1"; // Simple expression condition for enabling the item
    removeAfterExpressionCall = 1;
};
class KISKA_basicVariableSupport_baseClass : KISKA_basicSupport_baseClass
{
    removeAfterExpressionCall = 0;
};

class CLASS_155_ARTY_VARIABLE : KISKA_basicSupport_baseClass
{
    text = "155 no remove";
    expression = CALL_SUPPORT_MASTER(CLASS_155_ARTY_VARIABLE);
    icon = ARTILLERY_ICON;
};
class CLASS_155_ARTY_VARIABLE_OTHER : KISKA_basicVariableSupport_baseClass
{
    text = "155 do remove";
    expression = CALL_SUPPORT_MASTER(CLASS_155_ARTY_VARIABLE_OTHER);
    icon = ARTILLERY_ICON;
};