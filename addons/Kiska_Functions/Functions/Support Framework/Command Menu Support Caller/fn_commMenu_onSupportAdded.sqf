/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_onSupportAdded

Description:
    Designed to be an event handler for when a support that's meant to be used in
    the event a support item that is part of the comm menu is added.
    
Parameters:
    0: _supportId <STRING> - The support's id
    1: _supportConfig <CONFIG> - The support config
    2: _numberOfUsesLeft <NUMBER> - The number of support uses left or rounds
        available to use.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_supports_1",
            missionConfigFile >> "CfgCommunicationMenu" >> "MySupport",
            1
        ] call KISKA_fnc_commMenu_onSupportAdded;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_onSupportAdded";

#define SUPPORT_CURSOR "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"

params [
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]]
];

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";
if (isNull _commMenuDetailsConfig) exitWith {
    ["_supportConfig has no KISKA_commMenuDetails class defined",true] call KISKA_fnc_log;
    nil
};

private _commMenuSupportDetailsMap = [
    localNamespace,
    "KISKA_commMenu_configToDetailsMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
private _commMenuSupportDetails = _commMenuSupportDetailsMap getOrDefault [_supportConfig,[]];
_commMenuSupportDetails params [
    "_text",
    "_icon",
    "_iconText",
    "_cursor"
];
if (isNil "_commMenuSupportDetails") then {
    _text = getText(_commMenuDetailsConfig >> "text");
    _icon = getText(_commMenuDetailsConfig >> "icon");
    _iconText = getText(_commMenuDetailsConfig >> "iconText");
    _cursor = getText(_commMenuDetailsConfig >> "cursor");
    if (_cursor isEqualTo "") then {
        _cursor = SUPPORT_CURSOR;
    };

    _commMenuSupportDetailsMap set [
        _supportConfig,
        [
            _text,
            _icon,
            _iconText,
            _cursor
        ]
    ]
};


private _commMenuExpression = format ["[%1,AGLToASL _pos,_target,_is3D] call KISKA_fnc_commMenu_onSupportSelected;",_supportId];
private _idToDetailsMap = [
    localNamespace,
    "KISKA_commMenu_supportIdToDetailsMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
private _commMenuIndex = _idToDetailsMap set [
    _supportId,
    [
        _supportId,
        _text,
        "", // subMenu unused
        _commMenuExpression,
        1, // enable unused
        _cursor,
        _icon,
        _iconText
    ]
];

call KISKA_fnc_commMenu_refresh;

// Close the menu when opened
if (commandingMenu == "#User:BIS_fnc_addCommMenuItem_menu") then {
    showcommandingmenu "";
};


nil
