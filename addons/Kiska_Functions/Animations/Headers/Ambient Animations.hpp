#define ON 1
#define OFF 0

class KISKA_AmbientAnimations
{
    class BRIEFING
    {
        animations[] = {
            "hubbriefing_loop",
            "hubbriefing_loop",
            "hubbriefing_lookaround1",
            "hubbriefing_lookaround2",
            "hubbriefing_scratch",
            "hubbriefing_stretch",
            "hubbriefing_talkaround"
        };
    };
    class BRIEFING_POINT_LEFT
    {
        animations[] = {
            "hubbriefing_loop",
            "hubbriefing_loop",
            "hubbriefing_lookaround1",
            "hubbriefing_lookaround2",
            "hubbriefing_pointleft",
            "hubbriefing_scratch",
            "hubbriefing_stretch",
            "hubbriefing_talkaround"
        };
    };
    class BRIEFING_POINT_RIGHT
    {
        animations[] = {
            "hubbriefing_loop",
            "hubbriefing_loop",
            "hubbriefing_lookaround1",
            "hubbriefing_lookaround2",
            "hubbriefing_pointright",
            "hubbriefing_scratch",
            "hubbriefing_stretch",
            "hubbriefing_talkaround"
        };
    };
    class BRIEFING_POINT_TABLE
    {
        animations[] = {
            "hubbriefing_loop",
            "hubbriefing_loop",
            "hubbriefing_lookaround1",
            "hubbriefing_lookaround2",
            "hubbriefing_pointattable",
            "hubbriefing_scratch",
            "hubbriefing_stretch",
            "hubbriefing_talkaround"
        };
    };

    class KNEEL
    {
        animations[] = {
            "amovpknlmstpslowwrfldnon",
            "aidlpknlmstpslowwrfldnon_ai",
            "aidlpknlmstpslowwrfldnon_g01",
            "aidlpknlmstpslowwrfldnon_g02",
            "aidlpknlmstpslowwrfldnon_g03",
            "aidlpknlmstpslowwrfldnon_g0s"
        };

        canInterpolate = ON;
    };

    class REPAIR_VEH_PRONE
    {
        animations[] = {
            "hubfixingvehicleprone_idle1"
        };

        removeBackpack = ON;
        removeAllWeapons = ON;
    };
    class REPAIR_VEH_KNEEL
    {
        animations[] = {
            "inbasemoves_repairvehicleknl"
        };
    };
    class REPAIR_VEH_STAND
    {
        animations[] = {
            "inbasemoves_assemblingvehicleerc"
        };
    };

    class PRONE_INJURED_UNARMED_1
    {
        animations[] = {
            "ainjppnemstpsnonwnondnon"
        };

        removeAllWeapons = ON;
        removeBackpack = ON;
    };
    class PRONE_INJURED_UNARMED_2 : PRONE_INJURED_UNARMED_1
    {
        animations[] = {
            "hubwoundedprone_idle1",
            "hubwoundedprone_idle2"
        };
    };
    class PRONE_INJURED_ARMED
    {
        animations[] = {
            "acts_injuredangryrifle01",
            "acts_injuredcoughrifle02",
            "acts_injuredlookingrifle01",
            "acts_injuredlookingrifle02",
            "acts_injuredlookingrifle03",
            "acts_injuredlookingrifle04",
            "acts_injuredlookingrifle05",
            "acts_injuredlyingrifle01"
        };

        removeBackpack = ON;
    };


    class KNEEL_TREAT_KEEP_PRESSURE
    {
        animations[] = {
            "ainvpknlmstpsnonwnondnon_medic1"
        };
    };
    class KNEEL_TREAT_1
    {
        animations[] = {
            "ainvpknlmstpsnonwnondnon_medic",
            "ainvpknlmstpsnonwnondnon_medic0",
            /* "ainvpknlmstpsnonwnondnon_medic1", */ // this animation does not end. Ruins looping
            "ainvpknlmstpsnonwnondnon_medic2",
            "ainvpknlmstpsnonwnondnon_medic3",
            "ainvpknlmstpsnonwnondnon_medic4",
            /* "ainvpknlmstpsnonwnondnon_medic5" */ // this animation does not end. Ruins looping
        };
    };
    class KNEEL_TREAT_2 : KNEEL_TREAT_1
    {
        animations[] = {
            "acts_treatingwounded01",
            "acts_treatingwounded02",
            "acts_treatingwounded03",
            "acts_treatingwounded04",
            "acts_treatingwounded05",
            "acts_treatingwounded06"
        };
    };

    class STAND_ARMED_1
    {
        animations[] = {
            "HubStanding_idle1",
            "HubStanding_idle2",
            "HubStanding_idle3"
        };

        canInterpolate = OFF;
        attachToLogic = ON;
    };

    class STAND_ARMED_2
    {
        animations[] = {
            // removed amovpercmstpslowwrfldnon because they are animations that never end
            "aidlpercmstpslowwrfldnon_g01",
            "aidlpercmstpslowwrfldnon_g02",
            "aidlpercmstpslowwrfldnon_g03",
            "aidlpercmstpslowwrfldnon_g05"
        };

        canInterpolate = ON;
    };

    class STAND_UNARMED_1
    {
        animations[] = {
            "HubStandingUA_idle1",
            "HubStandingUA_idle2",
            //"HubStandingUA_idle3", causes hips to glitch for unknown reason
            "HubStandingUA_move1",
            "HubStandingUA_move2"
        };
    };
    class STAND_UNARMED_2
    {
        animations[] = {
            "HubStandingUB_idle1",
            "HubStandingUB_idle2",
            "HubStandingUB_idle3",
            "HubStandingUB_move1"
        };
    };
    class STAND_UNARMED_3
    {
        animations[] = {
            "HubStandingUC_idle1",
            "HubStandingUC_idle2",
            "HubStandingUC_idle3",
            "HubStandingUC_move1",
            "HubStandingUC_move2"
        };
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
                    {0.0078125,-0.0603027,4.41063},
                    {0.00617849,-0.99071,-0.135852},
                    {0,-0.135855,0.990729}
                };
            };
        };

        removeBackpack = ON;
        attachToLogic = ON;
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
        removeAllWeapons = ON;
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

        class snapToObjects
        {
            class equipmentBox
            {
                type = "Box_NATO_Equip_F";
                relativeInfo[] = {
                    {-0.0800781,-0.050293,4.78615},
                    {0.883283,0.46884,0},
                    {0,0,1}
                };
            };
            class woodenBox
            {
                type = "Land_WoodenBox_02_F";
                relativeInfo[] = {
                    {-0.0170898,-0.32373,4.87455},
                    {-0.634543,0.772887,0},
                    {0,0,1}
                };
            };
            class supplyCrate
            {
                type = "B_supplyCrate_F";
                relativeInfo[] = {
                    {-0.00244141,-0.150879,4.82193},
                    {-0.331876,0.943323,0},
                    {0,0,1}
                };
            };
            class uniformBox
            {
                type = "Box_NATO_Uniforms_F";
                relativeInfo[] = {
                    {-0.0712891,-0.0720215,4.75299},
                    {0.944229,0.329291,0},
                    {0,0,1}
                };
            };
            class ammoPallet
            {
                type = "Land_Pallet_MilBoxes_F";
                relativeInfo[] = {
                    {0.675781,-0.145508,4.72226},
                    {-0.972904,-0.231209,0},
                    {0,0,1}
                };
            };
            class cargoBox
            {
                type = "Land_CargoBox_V1_F";
                relativeInfo[] = {
                    {-0.0756836,-0.54248,5.15809},
                    {-0.273105,0.961984,0},
                    {0,0,1}
                };
            };
            class hbarrierSmall_3
            {
                type = "Land_HBarrier_3_F";
                relativeInfo[] = {
                    {-0.015625,-0.595215,4.90471},
                    {-0.273105,0.961984,0},
                    {0,0,1}
                };
            };
            class hbarrierSmall_5
            {
                type = "Land_HBarrier_5_F";
                relativeInfo[] = {
                    {0.600586,-0.576172,4.96254},
                    {-0.273105,0.961984,0},
                    {0,0,1}
                };
            };
        };
    };

    class SIT_HIGH_2 : SIT_HIGH_1
    {
        animations[] = {
            "HubSittingHighB_move1"
        };
        class snapToObjects : snapToObjects
        {
            class equipmentBox : equipmentBox
            {
                relativeInfo[] = {
                    {0.0200195,-0.0288086,4.52232},
                    {-0.890749,-0.454495,0},
                    {0,0,1}
                };
            };
            class woodenBox : woodenBox
            {
                relativeInfo[] = {
                    {0.0703125,-0.188965,4.63355},
                    {0.317043,-0.948411,0},
                    {0,0,1}
                };
            };
            class supplyCrate : supplyCrate
            {
                relativeInfo[] = {
                    {0,-0.0400391,4.57443},
                    {0.388223,-0.921565,0},
                    {0,0,1}
                };
            };
            class uniformBox : uniformBox
            {
                relativeInfo[] = {
                    {0.0219727,0.0126953,4.5194},
                    {-0.890749,-0.454495,0},
                    {0,0,1}
                };
            };
            class ammoPallet : ammoPallet
            {
                relativeInfo[] = {
                    {0.574707,-0.210938,4.47999},
                    {0.904759,0.425924,0},
                    {0,0,1}
                };
            };
            class cargoBox : cargoBox
            {
                relativeInfo[] = {
                    {0.00195313,-0.473145,4.86601},
                    {0.434003,-0.900911,0},
                    {0,0,1}
                };
            };
            class hbarrierSmall_3 : hbarrierSmall_3
            {
                relativeInfo[] = {
                    {-0.722656,-0.542969,4.59109},
                    {0.434003,-0.900911,0},
                    {0,0,1}
                };
            };
            class hbarrierSmall_5 : hbarrierSmall_5
            {
                relativeInfo[] = {
                    {0.600586,-0.513672,4.64892},
                    {0.434003,-0.900911,0},
                    {0,0,1}
                };
            };
        };
    };

    class SIT_GROUND_ARMED
    {
        animations[] = {
            "amovpsitmstpslowwrfldnon",
            "amovpsitmstpslowwrfldnon_smoking",
            "amovpsitmstpslowwrfldnon_weaponcheck1",
            "amovpsitmstpslowwrfldnon_weaponcheck2"
        };

        canInterpolate = ON;
    };
    class SIT_GROUND_UNARMED
    {
        animations[] = {
            "aidlpsitmstpsnonwnondnon_ground00",
            "amovpsitmstpsnonwnondnon_ground"
        };
    };

    class WATCH_1
    {
        animations[] = {
            "inbasemoves_patrolling1"
        };

        canInterpolate = OFF;
    };

    class WATCH_2 : WATCH_1
    {
        animations[] = {
            "inbasemoves_patrolling2"
        };
    };

    class STAND_HANDS_BEHIND_BACK_1
    {
        animations[] = {
            "inbasemoves_handsbehindback1",
            "inbasemoves_handsbehindback2"
        };

        // some clipping may happen but it doesn't seem to outweigh
        // being able to see if a unit is armed
        /* removeBackpack = ON; */
        /* removeAllWeapons - ON; */
    };
    class STAND_HANDS_BEHIND_BACK_2 : STAND_HANDS_BEHIND_BACK_1
    {
        animations[] = {
            "unaercposlechvelitele1",
            "unaercposlechvelitele2",
            "unaercposlechvelitele3",
            "unaercposlechvelitele4"
        };
    };

    class SIT_LOW
    {
        animations[] = {
            "c5efe_michalloop"
        };

        class snapToObjects
        {
            class launchersBox_NATO
            {
                type = "Box_NATO_WpsLaunch_F";
                relativeInfo[] = {
                    {0.012207,-0.0300293,4.84837},
                    {-0.220085,-0.975481,0},
                    {0,0,1}
                };
            };
            class launchersBox_IND : launchersBox_NATO
            {
                type = "Box_IND_WpsLaunch_F";
            };
            class launchersBox_CSAT : launchersBox_NATO
            {
                type = "Box_East_WpsLaunch_F";
            };

            class specialPurposeBox_NATO
            {
                type = "Box_NATO_WpsSpecial_F";
                relativeInfo[] = {
                    {0.0180664,0.0864258,4.91076},
                    {-0.220202,-0.957546,0.186057},
                    {0,0.190739,0.981641}
                };
            };
            class specialPurposeBox_IND : specialPurposeBox_NATO
            {
                type = "Box_IND_WpsSpecial_F";
            };
            class specialPurposeBox_CSAT : specialPurposeBox_NATO
            {
                type = "Box_East_WpsSpecial_F";
            };

            class weaponsBox_NATO : specialPurposeBox_NATO
            {
                type = "Box_NATO_Wps_F";
            };
            class weaponsBox_IND : weaponsBox_NATO
            {
                type = "Box_IND_Wps_F";
            };
            class weaponsBox_CSAT : weaponsBox_NATO
            {
                type = "Box_East_Wps_F";
            };
        };
    };

    class SIT_LOW_SAD : SIT_LOW
    {
        animations[] = {
            "c5efe_honzaloop"
        };
    };
};
