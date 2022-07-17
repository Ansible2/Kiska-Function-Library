#define TRUE 1

class KISKA_AmbientAnimations
{
    class STAND
    {
        animations[] = {
            "HubStanding_idle1",
            "HubStanding_idle2",
            "HubStanding_idle3"
        };

        canInterpolate = TRUE;
    };

    class STAND2
    {
        animations[] = {
            "amovpercmstpslowwrfldnon",
            "amovpercmstpslowwrfldnon",
            "aidlpercmstpslowwrfldnon_g01",
            "aidlpercmstpslowwrfldnon_g02",
            "aidlpercmstpslowwrfldnon_g03",
            "aidlpercmstpslowwrfldnon_g05"
        };

        canInterpolate = TRUE;
    };

    class STAND_U1
    {
        animations[] = {
            "HubStandingUA_idle1",
            "HubStandingUA_idle2",
            "HubStandingUA_idle3",
            "HubStandingUA_move1",
            "HubStandingUA_move2"
        };

        removeAllWeapons = TRUE;
    };
    class STAND_U2
    {
        animations[] = {
            "HubStandingUB_idle1",
            "HubStandingUB_idle2",
            "HubStandingUB_idle3",
            "HubStandingUB_move1"
        };

        removeAllWeapons = TRUE;
    };
    class STAND_U3
    {
        animations[] = {
            "HubStandingUC_idle1",
            "HubStandingUC_idle2",
            "HubStandingUC_idle3",
            "HubStandingUC_move1",
            "HubStandingUC_move2"
        };

        removeAllWeapons = TRUE;
    };

    class SIT_CHAIR_ARMED_1
    {
        animations[] = {
            "HubSittingChairA_idle1",
            "HubSittingChairA_idle2",
            "HubSittingChairA_idle3",
            "HubSittingChairA_move1"
        };

        class snapToObjects
        {
            class plasticChair
            {
                type = "Land_ChairPlastic_F";
                relativePos[] = {0.21793,-0.0107422,4.46834};
                relativeDir[] = {0.980642,-0.0994109,0.168695};
                relativeUp[] = {-0.166414,0.0308706,0.985573};
            };
            class campingChair_2
            {
                type = "Land_CampingChair_V2_F";
                relativeInfo[] = {
                    {-0.0107422,-0.0825195,4.53242},
                    {-0.099553,-0.994288,-0.0384766},
                    {0.0308706,-0.0417363,0.998652}
                };
            };
            class campingChair_1 : campingChair_2
            {
                type = "Land_CampingChair_V1_F";
            };
            class woodenChair
            {
                type = "Land_ChairWood_F";
                relativeInfo[] = {
                    {-0.0170898,0.0266113,5.03957},
                    {-0.099553,-0.994288,-0.0384766},
                    {0.0308706,-0.0417363,0.998652}
                };
            };
            class officeChair
            {
                type = "Land_OfficeChair_01_F";
                relativeInfo[] = {
                    {-0.0170898,0.0266113,5.03957},
                    {-0.099553,-0.994288,-0.0384766},
                    {0.0308706,-0.0417363,0.998652}
                };
            };
        };

        removeBackpack = TRUE;
    };

    class SIT_CHAIR_ARMED_2 : SIT_CHAIR_ARMED_1
    {
        animations[] = {
            "HubSittingChairB_idle1",
            "HubSittingChairB_idle2",
            "HubSittingChairB_idle3",
            "HubSittingChairB_move1"
        };
    };

    class SIT_AT_TABLE : SIT_CHAIR_ARMED_1
    {
        animations[] = {
            "HubSittingAtTableU_idle1",
            "HubSittingAtTableU_idle2",
            "HubSittingAtTableU_idle3"
        };
    };

    class SIT_CHAIR_RELAXED : SIT_CHAIR_ARMED_1
    {
        animations[] = {
            "HubSittingChairC_idle1",
            "HubSittingChairC_idle2",
            "HubSittingChairC_idle3",
            "HubSittingChairC_move1"
        };
    };

    class SIT_CHAIR_UNARMED_1 : SIT_CHAIR_ARMED_1
    {
        animations[] = {
            "HubSittingChairUA_idle1",
            "HubSittingChairUA_idle2",
            "HubSittingChairUA_idle3",
            "HubSittingChairUA_move1"
        };
        removeAllWeapons = TRUE;
    };

    class SIT_CHAIR_UNARMED_2 : SIT_CHAIR_UNARMED_1
    {
        animations[] = {
            "HubSittingChairUB_idle1",
            "HubSittingChairUB_idle2",
            "HubSittingChairUB_idle3",
            "HubSittingChairUB_move1"
        };
    };

    class SIT_CHAIR_UNARMED_3 : SIT_CHAIR_UNARMED_1
    {
        animations[] = {
            "HubSittingChairUC_idle1",
            "HubSittingChairUC_idle2",
            "HubSittingChairUC_idle3",
            "HubSittingChairUC_move1"
        };
    };

    class SIT_HIGH_1
    {
        animations[] = {
            "HubSittingHighA_idle1"
        };

        snapToObjects[] = {
            {"Box_NATO_Equip_F", {
                {-0.0800781,-0.050293,4.78615},
                {0.883283,0.46884,0},
                {0,0,1}
            }},
            {"Land_WoodenBox_02_F", {
                {-0.0170898,-0.32373,4.87455},
                {-0.634543,0.772887,0},
                {0,0,1}
            }},
            {"B_supplyCrate_F", {
                {-0.00244141,-0.150879,4.82193},
                {-0.331876,0.943323,0},
                {0,0,1}
            }},
            {"Box_NATO_Uniforms_F", {
                {-0.0712891,-0.0720215,4.75299},
                {0.944229,0.329291,0},
                {0,0,1}
            }},
            {"", {
                {},
                {},
                {}
            }},
            {"", {
                {},
                {},
                {}
            }},
            {"", {
                {},
                {},
                {}
            }},
            {"", {
                {},
                {},
                {}
            }}

        };
    };
};
