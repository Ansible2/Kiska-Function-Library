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
        draw3dMarker = ON;
        canSelectAttackDirection = ON;
    };
    
    class KISKA_supportDetails
    {
        numberOfUses = 1;
        onSupportAdded = "_this call KISKA_fnc_commMenu_onSupportAdded";
        onSupportRemoved = "_this call KISKA_fnc_commMenu_onSupportRemoved";
        onSupportCalled = "_this call KISKA_fnc_supports_onCalledCloseAirSupport";
    };

    class KISKA_supportManagerDetails
    {
        picture = CAS_ICON;
    };
};

class KISKA_support_commMenu_gunRun_template : KISKA_abstract_commMenuCloseAirSupport
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "CAS - Gun Run";
        aircraftClass = "B_Plane_CAS_01_dynamicLoadout_F";

        class AttackTypes
        {
            class GunRun
            {
                label = "Gun Run";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "Gatling_30mm_Plane_CAS_01_F",
                        "",
                        200,
                        0.05,
                        "",
                        0.1
                    }
                };
            };
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "CAS - Gun Run";
    };
};

class KISKA_support_commMenu_gunsRockets_template : KISKA_abstract_commMenuCloseAirSupport
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "CAS - Guns & Rockets";
        aircraftClass = "B_Plane_CAS_01_dynamicLoadout_F";

        class AttackTypes
        {
            class GunRun
            {
                label = "Gun Run";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "Gatling_30mm_Plane_CAS_01_F",
                        "",
                        200,
                        0.05,
                        "",
                        0.1
                    }
                };
            };
            class HERockets
            {
                label = "HE Rockets";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "pylon",
                        "PylonRack_7Rnd_Rocket_04_HE_F",
                        7,
                        0.5,
                        "guide_to_strafe_target",
                        0.01
                    },
                    {
                        "pylon",
                        "PylonRack_7Rnd_Rocket_04_HE_F",
                        7,
                        0.5,
                        "guide_to_strafe_target",
                        0.01
                    }
                };
            };
            class APRockets
            {
                label = "AP Rockets";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "pylon",
                        "PylonRack_7Rnd_Rocket_04_AP_F",
                        7,
                        0.5,
                        "guide_to_strafe_target",
                        0.01
                    },
                    {
                        "pylon",
                        "PylonRack_7Rnd_Rocket_04_AP_F",
                        7,
                        0.5,
                        "guide_to_strafe_target",
                        0.01
                    }
                };
            };
            class GunsAndHERockets
            {
                label = "Guns & HE Rockets";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "Gatling_30mm_Plane_CAS_01_F",
                        "",
                        100,
                        0.05,
                        "",
                        0.1
                    },
                    {
                        "pylon",
                        "PylonRack_7Rnd_Rocket_04_HE_F",
                        7,
                        0.5,
                        "guide_to_strafe_target",
                        0.01
                    }
                };
            };
            class GunsAndAPRockets
            {
                label = "Guns & AP Rockets";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "Gatling_30mm_Plane_CAS_01_F",
                        "",
                        100,
                        0.05,
                        "",
                        0.1
                    },
                    {
                        "pylon",
                        "PylonRack_7Rnd_Rocket_04_AP_F",
                        7,
                        0.5,
                        "guide_to_strafe_target",
                        0.01
                    }
                };
            };
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "CAS - Guns & Rockets";
    };
};

class KISKA_support_commMenu_bombs_template : KISKA_abstract_commMenuCloseAirSupport
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "CAS - Bombs";
        aircraftClass = "B_Plane_CAS_01_dynamicLoadout_F";

        class AttackTypes
        {
            class LGB
            {
                label = "Laserguided Bomb";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "pylon",
                        "PylonMissile_1Rnd_Bomb_04_F",
                        1,
                        0.05,
                        "",
                        0.1
                    }
                };
            };
            class ClusterBomb
            {
                label = "Cluster Bomb";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "pylon",
                        "PylonMissile_1Rnd_BombCluster_01_F",
                        1,
                        0.05,
                        "",
                        0.1
                    }
                };
            };
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "CAS - Bombs";
    };
};

class KISKA_support_commMenu_napalm_template : KISKA_abstract_commMenuCloseAirSupport
{
    class KISKA_commMenuDetails : KISKA_commMenuDetails
    {
        text = "CAS - Napalm";
        aircraftClass = "vn_b_air_f4c_hcas";

        class AttackTypes
        {
            class Napalm
            {
                label = "4x Napalm Bombs";
                allowDamage = OFF;
                fireOrders[] = {
                    {
                        "pylon",
                        "vn_bomb_f4_out_500_blu1b_fb_mag_x4",
                        4,
                        0.5,
                        "guide_to_strafe_target",
                        1
                    }
                };
            };
        };
    };

    class KISKA_supportManagerDetails : KISKA_supportManagerDetails
    {
        text = "CAS - Napalm";
    };
};


/* ----------------------------------------------------------------------------
    Helicopter CAS
---------------------------------------------------------------------------- */
class KISKA_abstract_commMenuHelicopterCAS
{
    class KISKA_commMenuDetails
    {
        icon = CAS_HELI_ICON;
        aircraftClass = "B_Heli_Attack_01_dynamicLoadout_F";
        onSupportSelected = "_this call KISKA_fnc_commMenu_openHelicopterCAS";
        canSelectIngress = ON;
        draw3dMarker = ON;
        patrolRadiuses[] = {200};
        patrolAltitudes[] = {50};
        patrolDuration = 180;
    };
    
    class KISKA_supportDetails
    {
        numberOfUses = 1;
        onSupportAdded = "_this call KISKA_fnc_commMenu_onSupportAdded";
        onSupportRemoved = "_this call KISKA_fnc_commMenu_onSupportRemoved";
        onSupportCalled = "_this call KISKA_fnc_supports_onCalledHelicopterGunner";
    };

    class KISKA_supportManagerDetails
    {
        picture = CAS_HELI_ICON;
    };
};