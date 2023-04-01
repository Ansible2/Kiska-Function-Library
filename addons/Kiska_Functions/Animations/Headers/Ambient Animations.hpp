#define ON 1
#define OFF 0
// Animations can have multiple relative points for a single object type

// for instance a "position 1" and "position 2" will be labeled and consistently referencing the same
/// positions on a say a couch no matter which animation source it is
/// perhaps each attachment type can also denote how many seats it takes up in the object
/// so that something like lying down on a couch takes two slots where sitting takes 1

// The object map also needs a section to denote the max number of attaches entities


class KISKA_AmbientAnimations
{
    class ObjectSpecifics
    {
        class Land_Sofa_01_F 
        {
            snapAllowance = 2;
        };
    };

    class DefaultAnimationMap
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
                // "ainvpknlmstpsnonwnondnon_medic1", // this animation does not end. Ruins looping
                "ainvpknlmstpsnonwnondnon_medic2",
                "ainvpknlmstpsnonwnondnon_medic3",
                "ainvpknlmstpsnonwnondnon_medic4",
                // "ainvpknlmstpsnonwnondnon_medic5" // this animation does not end. Ruins looping
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
            attachToLogic = ON;
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

            attachToLogic = ON;
        };
        class STAND_UNARMED_2
        {
            animations[] = {
                "HubStandingUB_idle1",
                "HubStandingUB_idle2",
                "HubStandingUB_idle3",
                "HubStandingUB_move1"
            };

            attachToLogic = ON;
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

            attachToLogic = ON;
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
                class sofa 
                {
                    type = "Land_Sofa_01_F";
                    class snapPoints
                    {
                        class snap1
                        {
                            snapId = 1;
                            relativeInfo[] = {
                                // pos
                                {}, 
                                // vectorDir
                                {}, 
                                // vectorUp
                                {} 
                            };
                        };
                        class snap2
                        {
                            snapId = 2;
                            relativeInfo[] = {
                                {},
                                {},
                                {}
                            };
                        };
                    };
                };

                class plasticChair
                {
                    type = "Land_ChairPlastic_F";
                    relativePos[] = {0.142059,-0.00439453,-0.488663};
                    relativeDir[] = {0.980642,-0.0994109,0.168695};
                    relativeUp[] = {-0.166414,0.0308706,0.985573};
                };
                class campingChair_2
                {
                    type = "Land_CampingChair_V2_F";
                    relativeInfo[] = {
                        {-0.00927734,-0.0766602,-0.447827},
                        {0.0146026,-0.992466,-0.121646},
                        {-0.010771,-0.121808,0.992495}
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
                        {-0.0385742,0.0432129,0.0593152},
                        {0.0146026,-0.992466,-0.121646},
                        {-0.010771,-0.121808,0.992495}
                    };
                };
                class officeChair
                {
                    type = "Land_OfficeChair_01_F";
                    relativeInfo[] = {
                        {0.0205078,-0.0170898,-0.615759},
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

            attachToLogic = ON;

            class snapToObjects
            {
                class equipmentBox
                {
                    type = "Box_NATO_Equip_F";
                    relativeInfo[] = {
                        {-0.0839844,-0.0380859,-0.261503},
                        {0.873485,0.471424,-0.121585},
                        {0.112937,0.0467208,0.992503}
                    };
                };
                class woodenBox
                {
                    type = "Land_WoodenBox_02_F";
                    relativeInfo[] = {
                        {-0.324707,-0.144775,-0.104452},
                        {0.913661,0.37043,-0.167348},
                        {0.913661,0.37043,-0.167348}
                    };
                };
                class supplyCrate
                {
                    type = "B_supplyCrate_F";
                    relativeInfo[] = {
                        {0.131836,-0.199707,-0.150366},
                        {-0.396473,0.902665,-0.167346},
                        {-0.158369,0.112304,0.980973}
                    };
                };
                class uniformBox
                {
                    type = "Box_NATO_Uniforms_F";
                    relativeInfo[] = {
                        {-0.120605,-0.171875,-0.237037},
                        {0.88974,0.424688,-0.167341},
                        {0.107258,0.161826,0.980973}
                    };
                };
                class ammoPallet
                {
                    type = "Land_Pallet_MilBoxes_F";
                    relativeInfo[] = {
                        {0.681152,0.125977,-0.293976},
                        {-0.855404,-0.490189,-0.167327},
                        {-0.0948198,-0.169394,0.980976}
                    };
                };
                class palletStack
                {
                    type = "Land_Pallets_stack_F";
                    relativeInfo[] = {
                        {0.567383,0.0705566,-0.165104},
                        {-0.893654,-0.416398,-0.167319},
                        {-0.108748,-0.16079,0.980979}
                    };
                };
                class cargoBox
                {
                    type = "Land_CargoBox_V1_F";
                    relativeInfo[] = {
                        {0.579102,0.157227,0.144599},
                        {-0.893654,-0.416398,-0.167319},
                        {-0.108748,-0.16079,0.980979}
                    };
                };
                class hbarrierSmall_3
                {
                    type = "Land_HBarrier_3_F";
                    relativeInfo[] = {
                        {0.188965,-0.640625,-0.101336},
                        {-0.365412,0.915685,-0.167317},
                        {-0.154408,0.11763,0.98098}
                    };
                };
                class hbarrierSmall_5 : hbarrierSmall_3
                {
                    type = "Land_HBarrier_5_F";
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
                        {0.0297852,0.0412598,-0.500562},
                        {-0.910042,-0.414516,0},
                        {0,0,1}
                    };
                };
                class woodenBox : woodenBox
                {
                    relativeInfo[] = {
                        {-0.0126953,-0.204346,-0.386857},
                        {0.426327,-0.904569,0},
                        {0,0,1}
                    };
                };
                class supplyCrate : supplyCrate
                {
                    relativeInfo[] = {
                        {-0.0117188,-0.0500488,-0.427824},
                        {0.426327,-0.904569,0},
                        {0,0,1}
                    };
                };
                class uniformBox : uniformBox
                {
                    relativeInfo[] = {
                        {0.00683594,0.017334,-0.492255},
                        {-0.908667,-0.417521,0},
                        {0,0,1}
                    };
                };
                class ammoPallet : ammoPallet
                {
                    relativeInfo[] = {
                        {0.556641,-0.0361328,-0.553361},
                        {0.898839,0.438278,0},
                        {0,0,1}
                    };
                };
                class cargoBox : cargoBox
                {
                    relativeInfo[] = {
                        {0.0141602,-0.447266,-0.100509},
                        {0.441747,-0.89714,0},
                        {0,0,1}
                    };
                };
                class palletStack : palletStack
                {
                    relativeInfo[] = {
                        {0.443848,-0.0473633,-0.428129},
                        {0.929453,0.368941,0},
                        {0,0,1}
                    };
                };
                class hbarrierSmall_3 : hbarrierSmall_3
                {
                    relativeInfo[] = {
                        {-0.012207,-0.486084,-0.30972},
                        {0.400162,-0.916444,0},
                        {0,0,1}
                    };
                };
                class hbarrierSmall_5 : hbarrierSmall_3
                {
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

            attachToLogic = ON;

            class snapToObjects
            {
                class launchersBox_NATO
                {
                    type = "Box_NATO_WpsLaunch_F";
                    relativeInfo[] = {
                        {0.0489197,0.00891113,-0.148207},
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
                        {0.0341797,0.0270996,-0.114266},
                        {-0.129318,-0.981674,0.139975},
                        {0,0.14116,0.989987}
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
};
