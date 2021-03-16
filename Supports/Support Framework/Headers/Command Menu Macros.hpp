#define CMD_EXECUTE -5
#define IS_ACTIVE "1"
#define IS_VISIBLE "1"
#define EXPRESSION(CODE) [["expression", CODE]]
#define KEY_SHORTCUT(KEY) [KEY]
#define SAVE_MENU missionNamespace setVariable [_menuName,_menuArray];
#define SAVE_AND_RETURN SAVE_MENU _menuArray
#define STD_LINE(TITLE,KEY,CODE) [TITLE, KEY_SHORTCUT(KEY), "", CMD_EXECUTE, EXPRESSION(CODE), IS_ACTIVE, IS_VISIBLE]
#define PUSHBACK_AND_PROCEED(VALUE) "(uiNamespace getVariable 'KISKA_commMenuTree_params') pushBack " + (str VALUE) + "; uiNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];"
#define STD_LINE_PUSH(TITLE,KEY,VALUE) [TITLE, KEY_SHORTCUT(KEY), "", CMD_EXECUTE, EXPRESSION(PUSHBACK_AND_PROCEED(VALUE)), IS_ACTIVE, IS_VISIBLE]
#define DISTANCE_LINE(DIS,KEY) STD_LINE((str DIS) + "m",KEY,PUSHBACK_AND_PROCEED(DIS))
#define WITH_USER(GVAR) "#USER:" + GVAR
#define ADD_SUPPORT_BACK(COUNT) [(_args select 0) select 0,_args select 1,nil,COUNT,""] call KISKA_fnc_addCommMenuItem;
#define TO_STRING(STRING) #STRING
#define MAX_KEYS 9
#define UNLOAD_GLOBALS (_args select 3) apply {missionNamespace setVariable [_x,nil]};
#define SAVE_AND_PUSH(GVAR,MENU_ARRAY) \
	missionNamespace setVariable [GVAR,MENU_ARRAY]; \
	_menuVariables pushBack GVAR; \
	_menuPathArray pushBack WITH_USER(GVAR);