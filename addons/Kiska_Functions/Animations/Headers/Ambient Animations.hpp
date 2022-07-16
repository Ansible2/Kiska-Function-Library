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

    class SIT_CHAIR_UNARMED
    {
        animations[] = {
            "HubSittingChairA_idle1",
            "HubSittingChairA_idle2",
            "HubSittingChairA_idle3",
            "HubSittingChairA_move1"
        };

        snapToObjects[] = {
            {"Land_ChairPlastic_F",{
                {0.21793,-0.0107422,4.46834},
                {0.980642,-0.0994109,0.168695},
                {-0.166414,0.0308706,0.985573}
            }},
            {"Land_CampingChair_V2_F",{
                {-0.0107422,-0.0825195,4.53242},
                {-0.099553,-0.994288,-0.0384766},
                {0.0308706,-0.0417363,0.998652}
            }},
            {"Land_CampingChair_V1_F",{
                {-0.0107422,-0.0825195,4.53242},
                {-0.099553,-0.994288,-0.0384766},
                {0.0308706,-0.0417363,0.998652}
            }},
            {"Land_ChairWood_F",{
                {-0.0170898,0.0266113,5.03957},
                {-0.099553,-0.994288,-0.0384766},
                {0.0308706,-0.0417363,0.998652}
            }},
            {"Land_OfficeChair_01_F",{
                {-0.0170898,0.0266113,5.03957},
                {-0.099553,-0.994288,-0.0384766},
                {0.0308706,-0.0417363,0.998652}
            }}
        };

        removeBackpack = TRUE;
    };

    class SIT_CHAIR_ARMED : SIT_CHAIR_UNARMED
    {

    };
};
