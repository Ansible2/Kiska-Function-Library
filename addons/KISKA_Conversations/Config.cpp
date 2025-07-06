class CfgPatches
{
    class KISKA_SimpleStore
    {
        units[]={};
        weapons[]={};
        requiredVersion=0.1;
        requiredAddons[]={
            "cba_main",
            "KISKA_Functions"
        };
    };
};

class CfgFunctions
{
    class KISKA
    {
        class Conversation
        {
            file = "KISKA_Conversations\Functions";
            class convo_close
            {};
            class convo_createResponseDialog
            {};
            class convo_markOptionAsSelected
            {};
            class convo_hasOptionBeenSelected
            {};
            class convo_onOptionSelected
            {};
            class convo_open
            {};
        };
    };
};


#include "Headers\ConversationDialog.hpp"
