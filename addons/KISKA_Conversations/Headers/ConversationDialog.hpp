
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Grid.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Colors.hpp"
#include "\KISKA_Functions\Headers\GUI\KISKA GUI Styles.hpp"
#include "ConversationDialogCommonDefines.hpp"

class RscText;
class RscListbox;
class ctrlButton;

class KISKA_converstationResponse_dialog
{
    idd = -1;
    enableSimulation = 1;
    movingEnabled = 1;

    class controlsBackground
    {
        class HeaderText : RscText
        {
            moving = 1;
            idc = CONVERSATION_DIALOG_HEADER_TEXT_IDC;
            x = KISKA_POS_X(-17.5);
            y = KISKA_POS_Y(6);
            w = KISKA_POS_W(35);
            h = KISKA_POS_H(1);
            colorBackground[] = KISKA_PROFILE_BACKGROUND_COLOR(1);
            style = 2; // center
        };
    };


    class controls
    {
        class ResponsesListBox : RscListbox
        {
            idc = CONVERSATION_DIALOG_OPTIONS_LISTBOX_IDC;
            x = KISKA_POS_X(-17.5);
            y = KISKA_POS_Y(7);
            w = KISKA_POS_W(35);
            h = KISKA_POS_H(6);
            colorBackground[] = {-1,-1,-1,0.5};
        };

        class SelectOptionButton : ctrlButton
        {
            idc = CONVERSATION_DIALOG_OPTIONS_SELECT_IDC;
            text = "Select";
            x = KISKA_POS_X(-17);
            y = KISKA_POS_Y(13.25);
            w = KISKA_POS_W(34);
            h = KISKA_POS_H(1);
        };
    };
};


