#define CMD_EXECUTE -5
#define IS_ACTIVE "1"
#define IS_VISIBLE "1"
#define EXPRESSION(CODE) [["expression", CODE]]
#define KEY_SHORTCUT(KEY) [KEY]
#define SAVE_MENU missionNamespace setVariable [_menuName,_menuArray];
#define SAVE_AND_RETURN SAVE_MENU _menuArray
#define STD_LINE(TITLE,KEY,CODE) [TITLE, KEY_SHORTCUT(KEY), "", CMD_EXECUTE, EXPRESSION(CODE), IS_ACTIVE, IS_VISIBLE]
#define PUSHBACK_AND_PROCEED(VALUE) "(uiNamespace getVariable 'KISKA_commMenuTree_params') pushBack " + (str VALUE) + "; uiNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];"
#define DISTANCE_LINE(DIS,KEY) STD_LINE((str DIS) + "m",KEY,PUSHBACK_AND_PROCEED(DIS))