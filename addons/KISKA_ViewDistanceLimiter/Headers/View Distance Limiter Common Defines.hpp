#define VDL_GLOBAL_IS_RUNNING_STR "KISKA_VDL_isRunning"
#define GET_VDL_GLOBAL_IS_RUNNING missionNamespace getVariable [VDL_GLOBAL_IS_RUNNING_STR,false]
#define VDL_GLOBAL_RUN_STR "KISKA_VDL_run"


#define GET_PROFILE_VAR(name,default) profileNamespace getVariable [name,default]
#define GET_MISSION_VAR(name,default) missionNamespace getVariable [name,default]
//#define SET_PROFILE_VAR(name,value) profileNamespace setVariable [name,value]

#define VDL_DISPLAY_VAR_STR "KISKA_VDL_display"
#define GET_VDL_DISPLAY localNamespace getVariable [VDL_DISPLAY_VAR_STR,displayNull]

#define VDL_CONTROL_GRPS_VAR_STR "KISKA_VDL_controlGroups"


#define VDL_GLOBAL_TIED_VIEW_DIST_VAR_STR "KISKA_VDL_tiedViewDistance"
#define GET_VDL_GLOBAL_TIED_VIEW_DIST_VAR   GET_MISSION_VAR(VDL_GLOBAL_TIED_VIEW_DIST_VAR_STR,false)

#define VDL_FPS_VAR_STR "KISKA_VDL_fps"
#define GET_VDL_FPS_VAR         GET_MISSION_VAR(VDL_FPS_VAR_STR,60)

#define VDL_FREQUENCY_VAR_STR "KISKA_VDL_freq"
#define GET_VDL_FREQUENCY_VAR   GET_MISSION_VAR(VDL_FREQUENCY_VAR_STR,1)

#define VDL_MIN_DIST_VAR_STR "KISKA_VDL_minDist"
#define GET_VDL_MIN_DIST_VAR    GET_MISSION_VAR(VDL_MIN_DIST_VAR_STR,600)

#define VDL_MAX_DIST_VAR_STR "KISKA_VDL_maxDist"
#define GET_VDL_MAX_DIST_VAR    GET_MISSION_VAR(VDL_MAX_DIST_VAR_STR,1200)

#define VDL_VIEW_DIST_VAR_STR "KISKA_VDL_viewDist"
#define GET_VDL_VIEW_DIST_VAR   GET_MISSION_VAR(VDL_VIEW_DIST_VAR_STR,3000)

#define VDL_INCREMENT_VAR_STR "KISKA_VDL_increment"
#define GET_VDL_INCREMENT_VAR   GET_MISSION_VAR(VDL_INCREMENT_VAR_STR,25)


#ifndef TO_STRING
    #define TO_STRING(string) #string
#endif


#define SLIDER_IDC 562701
#define CTRL_GRP_SLIDER_CTRL_VAR_STR "KISKA_VDL_ctrlGrp_slider"

#define EDIT_IDC 562702
#define CTRL_GRP_EDIT_CTRL_VAR_STR "KISKA_VDL_ctrlGrp_editBox"

#define BUTTON_IDC 562700
#define CTRL_GRP_BUTTON_CTRL_VAR_STR "KISKA_VDL_ctrlGrp_setButton"

#define CTRL_GRP_VAR_STR "KISKA_VDL_varName"



#define VDL_IDD 2154
#define VDL_CLOSE_BUTTON_IDC 21541
#define VDL_SET_ALL_BUTTON_IDC 21542
#define VDL_SYSTEM_ON_CHECKBOX_IDC 21543
#define VDL_TIED_DISTANCE_CHECKBOX_IDC 21544
#define VDL_TARGET_FPS_CTRL_GRP_IDC 21545
#define VDL_MIN_OBJECT_DIST_CTRL_GRP_IDC 21546
#define VDL_MAX_OBJECT_DIST_CTRL_GRP_IDC 21547
#define VDL_TERRAIN_DIST_CTRL_GRP_IDC 21548
#define VDL_CHECK_FREQ_CTRL_GRP_IDC 21549
#define VDL_INCRIMENT_CTRL_GRP_IDC 215410
