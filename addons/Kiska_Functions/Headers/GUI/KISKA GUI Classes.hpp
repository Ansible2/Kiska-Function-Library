#include "KISKA GUI Colors.hpp"
#include "KISKA GUI Grid.hpp"

class RscButtonMenu;

class KISKA_RscCloseButton : RscButtonMenu
{
    idc = -1;
    text = "";
    x = POS_X(7.5);
    y = POS_Y(-10);
    w = POS_W(1);
    h = POS_H(1);
    colorText[] = GREY_COLOR(0,1);
    colorActive[] = GREY_COLOR(0,1);
    textureNoShortcut = "\A3\3den\Data\Displays\Display3DEN\search_END_ca.paa";
    class ShortcutPos
    {
        left = 0;
        top = 0;
        w = POS_W(1);
        h = POS_H(1);
    };
    animTextureNormal = "#(argb,8,8,3)color(1,0,0,0.57)";
    animTextureDisabled = "";
    animTextureOver = "#(argb,8,8,3)color(1,0,0,0.57)";
    animTextureFocused = "";
    animTexturePressed = "#(argb,8,8,3)color(1,0,0,0.57)";
    animTextureDefault = "";
};
