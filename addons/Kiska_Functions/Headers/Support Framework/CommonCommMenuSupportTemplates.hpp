#include "CommonSupportConfigMacros.hpp"

/* ----------------------------------------------------------------------------
    Artillery
---------------------------------------------------------------------------- */
class KISKA_abstract_commMenuArty
{
    class KISKA_commMenuDetails
    {
        icon = ARTILLERY_ICON;
        onSupportSelected = "_this call KISKA_fnc_commMenu_openArty";
        canSelectRounds = ON;
        draw3dMarker = ON;
        radiuses[] = {25,50,100};
    };
    
    class KISKA_supportDetails
    {
        numberOfUses = 10;
        onSupportAdded = "_this call KISKA_fnc_commMenu_onSupportAdded";
        onSupportRemoved = "_this call KISKA_fnc_commMenu_onSupportRemoved";
        onSupportCalled = "_this call KISKA_fnc_supports_onCalledVirtualArty";
    };

    class KISKA_supportManagerDetails
    {
        picture = ARTILLERY_ICON;
    };
};

class KISKA_support_commMenu_155Arty_template : KISKA_abstract_commMenuArty
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "Artillery - 155mm";
        ammoTypes[] = {
            AMMO_155_HE,
            AMMO_155_CLUSTER,
            AMMO_155_MINES,
            AMMO_155_ATMINES
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "Artillery - 155mm";
    };  
};

class KISKA_support_commMenu_120Arty_template : KISKA_abstract_commMenuArty
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "Artillery - 120mm";
        ammoTypes[] = {
            AMMO_120_HE,
            AMMO_120_CLUSTER,
            AMMO_120_MINES,
            AMMO_120_ATMINES,
            AMMO_120_SMOKE
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "Artillery - 120mm";
    };  
};

class KISKA_support_commMenu_82Mortar_template : KISKA_abstract_commMenuArty
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "Artillery - 82mm";
        ammoTypes[] = {
            AMMO_82_HE,
            AMMO_82_FLARE,
            AMMO_82_SMOKE
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "Artillery - 82mm";
    };  
};

class KISKA_support_commMenu_230Arty_template : KISKA_abstract_commMenuArty
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "Artillery - 230mm";
        ammoTypes[] = {
            AMMO_230_HE,
            AMMO_230_CLUSTER
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "Artillery - 230mm";
    };  
};



/* ----------------------------------------------------------------------------
    Close Air Support
---------------------------------------------------------------------------- */
class KISKA_abstract_commMenuCloseAirSupport
{
    class KISKA_commMenuDetails
    {
        icon = CAS_ICON;
        onSupportSelected = "_this call KISKA_fnc_commMenu_openCas";
    };
    
    class KISKA_supportDetails
    {
        numberOfUses = 1;
        draw3dMarker = ON;
        onSupportAdded = "_this call KISKA_fnc_commMenu_onSupportAdded";
        onSupportRemoved = "_this call KISKA_fnc_commMenu_onSupportRemoved";
        onSupportCalled = "_this call KISKA_fnc_suppports_onCalledCloseAirSupport";
    };

    class KISKA_supportManagerDetails
    {
        picture = CAS_ICON;
    };
};