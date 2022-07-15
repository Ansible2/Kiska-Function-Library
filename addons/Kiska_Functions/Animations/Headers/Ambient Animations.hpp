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
        animtions[] = {
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
        animtions[] = {
            "HubStandingUB_idle1",
            "HubStandingUB_idle2",
            "HubStandingUB_idle3",
            "HubStandingUB_move1"
        };

        removeAllWeapons = TRUE;
    };
    class STAND_U3
    {
        animtions[] = {
            "HubStandingUC_idle1",
            "HubStandingUC_idle2",
            "HubStandingUC_idle3",
            "HubStandingUC_move1",
            "HubStandingUC_move2"
        };

        removeAllWeapons = TRUE;
    };
};
