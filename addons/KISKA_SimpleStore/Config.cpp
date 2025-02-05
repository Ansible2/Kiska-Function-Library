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
        class SimpleStore
        {
			file="KISKA_SimpleStore\Functions";
            class simpleStore_getDisplay
            {};
            class simpleStore_getPoolItems
            {};
            class simpleStore_getStoreMap
            {};
            class simpleStore_isStoreOpen
            {};
            class simpleStore_open
            {};
            class simpleStore_updatePoolList
            {};
        };
    };
};


#include "Headers\SimpleStoreDialog.hpp"
