/* ----------------------------------------------------------------------------
Function: KISKA_fnc_showNotification

Description:
    A reimplementation of `BIS_fnc_showNotification`, this function works in tandem,
    however, the arguements are changed for more flexibility.

Parameters:
    0: _baseNotification <CONFIG | STRING | HASHMAP> - Config entry of the notification. 
        If a string, the config is expected to be located under a `"CfgNotifications"` config
        (e.g. `configFile >> "CfgNotifications" >> "MyNotification"`) and will
        be found with `KISKA_fnc_findConfigAny`. HashMap keys are case sensitive:

            - `title` <STRING>: Text at the top of the notification popup.
            - `iconPicture` <STRING>: The path of a picture to show on the 
                lefthand side of the notification.
            - `iconText` <STRING>: Text to display in the lefthand side panel.
            - `description` <STRING>: Text to show in the righthand bottom handle.
            - `color` <COLOR(RGBA)>: Color of all the text and icons in the notification.
                Will overwrite `colorIconPicture` and `colorIconText` if they are undefined
                when `_baseNotification` is a config.
            - `colorIconPicture` <COLOR(RGBA)>: Color of the icon picture.
            - `colorIconText` <COLOR(RGBA)>: Color of the icon text.
            - `duration` <NUMBER>: How long the notification is shown.
            - `priority` <NUMBER>: The priority of the notification; higher will
                put the notification higher in the queue.
            - `sound` <STRING>: A string className of a sound defined in `CfgSounds` of 
                a sound that will play when the notification is opened.
            - `soundClose` <STRING>: A string className of a sound defined in `CfgSounds` of 
                a sound that will play when the notification is closed.
            - `soundRadio` <>: A string className of a sound defined in `CfgSounds`.
                Unknown when it plays.
            - `iconSize` <NUMBER>: Ccale of the icon.

    1: _args <ANY[]> - Array of args to be passed to the template. Same as `BIS_fnc_showNotification`.
    2: _overwrites <HASHMAP> - A hashmap containing any values from the `_baseNotification`
        to overwrite.

Returns:
    NOTHING

Examples:
    (begin example)
        ["Warning"] call KISKA_fnc_showNotification;
    (end)
    
    (begin example)
        [
            configFile >> "MyNotifications" >> "MyNotification"
        ] call KISKA_fnc_showNotification;
    (end)
    
    (begin example)
        private _map = createHashMapFromArray [
            ["title","hello world"],
            ["description","my description"]
        ];
        [_map] call KISKA_fnc_showNotification;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_showNotification";

#define GET_TEXT_VALUE { if !(isText _paramConfig) exitWith {call _default}; getText _paramConfig }
#define GET_NUMBER_VALUE { if !(isNumber _paramConfig) exitWith {call _default}; getNumber _paramConfig }
#define GET_COLOR_VALUE { if !(isArray _paramConfig) exitWith {call _default}; private _color = getArray _paramConfig; _color call BIS_fnc_colorConfigToRGBA }
#define GET_ARRAY_VALUE { if !(isArray _paramConfig) exitWith {call _default}; getArray _paramConfig }

private _HASHMAP_COMPARE = createHashMap;
params [
    ["_baseNotification","",["",configNull,_HASHMAP_COMPARE]],
    ["_args",[],[[]]],
    "_overwrites"
];

if (_baseNotification isEqualType "") then {
    _baseNotification = [["CfgNotifications",_baseNotification]] call KISKA_fnc_findConfigAny;
};

if ((_baseNotification isEqualType configNull) AND {isNull _baseNotification}) exitWith {
    ["Null notification config passed",true] call KISKA_fnc_log;
    nil
};

private _baseNotificationIsHashmap = _baseNotification isEqualType _HASHMAP_COMPARE;
private _hasOverwrites = !(isNil "_overwrites") AND {_overwrites isEqualType _HASHMAP_COMPARE};
private ["_invalidParamMessage","_paramValue"];
private _notificationData = [
    ["title",{""},[""],GET_TEXT_VALUE],
    ["iconPicture",{""},[""],GET_TEXT_VALUE],
    ["iconText",{""},[""],GET_TEXT_VALUE],
    ["description",{""},[""],GET_TEXT_VALUE],
    [
        "color",
        {
            [
                (profilenamespace getvariable ['IGUI_TEXT_RGB_R',0]),
                (profilenamespace getvariable ['IGUI_TEXT_RGB_G',1]),
                (profilenamespace getvariable ['IGUI_TEXT_RGB_B',1]),
                (profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])
            ]
        },
        [[]],
        GET_COLOR_VALUE
    ],
    [
        "colorIconPicture",
        {
            if (_baseNotificationIsHashmap OR {!(isArray (_baseNotification >> "color"))}) exitWith {
                [
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_R',0]),
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_G',1]),
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_B',1]),
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])
                ]
            };

            getArray (_baseNotification >> "color") call BIS_fnc_colorConfigToRGBA
        },
        [[]],
        GET_COLOR_VALUE
    ],
    [
        "colorIconText",
        {
            if (_baseNotificationIsHashmap OR {!(isArray (_baseNotification >> "color"))}) exitWith {
                [
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_R',0]),
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_G',1]),
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_B',1]),
                    (profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])
                ]
            };

            getArray (_baseNotification >> "color") call BIS_fnc_colorConfigToRGBA
        },
        [[]],
        GET_COLOR_VALUE
    ],
    ["duration",{3},[123],GET_NUMBER_VALUE],
    ["priority",{0},[123],GET_NUMBER_VALUE],
    ["sound",{"defaultNotification"},[""],GET_TEXT_VALUE],
    ["soundClose",{"defaultNotificationClose"},[""],GET_TEXT_VALUE],
    ["soundRadio",{""},[""],GET_TEXT_VALUE],
    ["iconSize",{0},[123],GET_NUMBER_VALUE]
] apply {
    _x params ["_var", "_default", "_types", "_getConfigValue"];

    if (_hasOverwrites AND (_var in _overwrites)) then {
        _paramValue = _overwrites get _var;
    } else {
        if (_baseNotificationIsHashmap) then {
            _paramValue = _baseNotification getOrDefaultCall [_var,_default];
        } else {
            private _paramConfig = _baseNotification >> _var;
            _paramValue = call _getConfigValue;
        };
    };

    if !(_paramValue isEqualTypeAny _types) then {
        _invalidParamMessage = [_var," value ",_paramValue," is invalid, must be -> ",_types] joinString "";
        break;
    };

    _paramValue
};
if !(isNil "_invalidParamMessage") exitWith {
    [_invalidParamMessage,true] call KISKA_fnc_log;
    nil
};

// preserving compatiblity with BIS function
_notificationData insert [9,[_args]];


//--- Add to the queue
private _queue = missionnamespace getvariable ["BIS_fnc_showNotification_queue",[]];
private _priority = _notificationData select 8;
_queue resize (_priority max (count _queue));
if (isnil {_queue select _priority}) then {
    _queue set [_priority,[]];
};
private _queuePriority = _queue select _priority;
_queuePriority set [count _queuePriority,_notificationData];
missionnamespace setvariable ["BIS_fnc_showNotification_queue",_queue];

//--- Increase the counter
["BIS_fnc_showNotification_counter",+1] call bis_fnc_counter;

//--- Process the queue
private _notificationQueueProcess = missionnamespace getvariable "BIS_fnc_showNotification_process";
private _startNewQueueProcess = isNil "_notificationQueueProcess" OR {scriptDone _notificationQueueProcess};
if !(_startNewQueueProcess) exitWith {nil};

_notificationQueueProcess = [] spawn {
    scriptname "BIS_fnc_showNotification: queue";
    private _queue = missionnamespace getvariable ["BIS_fnc_showNotification_queue",[]];
    private _layers = [
        ("RscNotification_1" call bis_fnc_rscLayer),
        ("RscNotification_2" call bis_fnc_rscLayer)
    ];
    private _layerID = 0;
    while {(count _queue) > 0} do {
        private _queueID = count _queue - 1;
        private _queuePriority = _queue select _queueID;
        if (isNil "_queuePriority") then {
            if (_queueID isEqualTo ((count _queue) - 1)) then {
                _queue resize _queueID;
            };

            continue;
        };

        if ((count _queuePriority) > 0) then {
            private _dataID = count _queuePriority - 1;
            private _data = +(_queuePriority select _dataID);
            if (count _data > 0 AND (alive player || ismultiplayer)) then {
                private _duration = _data select 7;

                //--- Show
                missionnamespace setvariable ["RscNotification_data",_data];
                (_layers select _layerID) cutrsc ["RscNotification","plain"];
                _layerID = (_layerID + 1) % 2;
                ["BIS_fnc_showNotification_counter",-1] call bis_fnc_counter;

                sleep _duration;
                _queuePriority set [_dataID,[]];
            } else {
                _queuePriority resize _dataID;
            };
        };
        if ((count _queuePriority) isEqualTo 0) then {
            _queue resize _queueID;
        };
    };
};
missionnamespace setvariable ["BIS_fnc_showNotification_process",_notificationQueueProcess];


nil
