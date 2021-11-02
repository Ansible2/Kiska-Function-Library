// compass display
#define COMPASS_DISPLAY_VAR_STR "KISKA_compass_display"
#define GET_COMPASS_DISPLAY localNamespace getVariable [COMPASS_DISPLAY_VAR_STR,displayNull]

// misc var strings
#define COMPASS_MAIN_CTRL_GRP_VAR_STR "KISKA_compass_mainCtrlGroup"
#define COMPASS_MAIN_CTRL_GRP_POS_VAR_STR "KISKA_compass_mainCtrlGroup_pos"
#define COMPASS_IMAGE_CTRL_VAR_STR "KISKA_compass_imageCtrl"
#define COMPASS_BACKGROUND_CTRL_VAR_STR "KISKA_compass_backgroundCtrl"
#define COMPASS_CENTER_MARKERS_CTRL_VAR_STR "KISKA_compass_centerMarkersCtrl"

#define COMPASS_LAYER_NAME "KISKA_compass_uiLayer"
#define COMPASS_CONFIGED_VAR_STR "KISKA_compass_configed"

// icon map
#define COMPASS_ICON_MAP_VAR_STR "KISKA_compass_iconHashMap"
#define GET_COMPASS_ICON_MAP_DEFAULT localNamespace getVariable [COMPASS_ICON_MAP_VAR_STR,createHashMap]
#define GET_COMPASS_ICON_MAP localNamespace getVariable COMPASS_ICON_MAP_VAR_STR
