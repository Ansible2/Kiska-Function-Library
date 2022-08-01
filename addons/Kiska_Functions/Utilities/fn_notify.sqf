#include "\a3\ui_f\hpp\defineCommonGrids.inc"

/* ----------------------------------------------------------------------------
Function: KISKA_fnc_notify

Description:
    Display a text message. Multiple incoming messages are queued. Also controls
     the lifetime of a notification

Parameters:
	0: _titleLine : <STRING or ARRAY> - If string, the message to display as title.
        If array:
            0: _text : <STRING> - Text to display or path to .paa or .jpg
                image (may be passed directly if only text is required)
            1: _size : <NUMBER> - Scale of text
            2: _color : <ARRAY> - RGB or RGBA color (range 0-1). (optional, default: [1, 1, 1, 1])

	1: _subLine : <STRING or ARRAY> - Formatted the same as _titleLine
	2: _skippable : <ARRAY> - If there are more notifications behind in the queue and this notification
        comes up, it will not be shown and thrown away
    3: _lifetime : <NUMBER> - How long the notification lasts in seconds (at least 2)

Examples:
    (begin example)
        [
            ["Hello",1.1,[0.75,0,0,1]],
            "World",
            false,
            5
        ] call KISKA_fnc_notify;
    (end)

Returns:
    NOTHING

Authors:
    commy2,
    Modified by: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_notify";
#define NOTIFY_DEFAULT_X (safezoneX + safezoneW - 13 * GUI_GRID_W)
#define NOTIFY_DEFAULT_Y (safezoneY + 6 * GUI_GRID_H)
#define NOTIFY_MIN_WIDTH (12 * GUI_GRID_W)
#define NOTIFY_MIN_HEIGHT (3 * GUI_GRID_H)

#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3

#define FADE_IN_TIME 0.2
#define FADE_OUT_TIME 1

#define BACKGROUND_OPACITY 0.25

#define GET_QUEUE localNamespace getVariable "KISKA_notificationQueue"
#define SET_QUEUE(var) localNamespace setVariable ["KISKA_notificationQueue",var]


if (canSuspend) exitWith {
    [
        KISKA_fnc_notify,
        _this
    ] call CBA_fnc_directCall;
};

if (!hasInterface) exitWith {};

params [
    ["_titleLine","",[[],""]],
    ["_subLine","",[[],""]],
    ["_skippable",false,[true]],
    ["_lifetime",4,[123]]
];

if (_lifetime < 2) then {
    _lifetime = 2;
};


/* ----------------------------------------------------------------------------
    Build composition
---------------------------------------------------------------------------- */
private _composition = [];

[lineBreak,_titleLine,lineBreak,_subLine,lineBreak,lineBreak] apply {
    if (_x isEqualTo lineBreak) then {
        _composition pushBack lineBreak;
        continue;
    };
    // Line

    _x params [
        ["_text","",[""]],
        ["_size",1,[123]],
        ["_color",[1,1,1,1],[[]],[3,4]]
    ];

    if ((count _color) isEqualTo 3) then {
        _color pushBack 1;
    };

    _color = _color call BIS_fnc_colorRGBAtoHTML;
    _size = _size * 0.55 / (getResolution select 5);

    private _isImage = (toLower _text) select [(count _text) - 4] in [".paa", ".jpg"];
    if (_isImage) then {
        _composition pushBack (parseText format ["<img align='center' valign='middle' size='%2' color='%3' image='%1'/>", _text, _size, _color]);

    } else {
        /* private _text = "<t size='3'><t size='1' align='right'>Top Right</t> <t size='1' valign='middle' align='center'>Middle Center</t> <t size='1' valign='bottom' align='left'>Bottom Left</t></t>"; */
        /* _composition pushBack (parseText _text); */
        _text = text _text;
        _text setAttributes [
            /* "align", "center", */
            "color", _color,
            "size", str _size
        ];

        _text = composeText [_text];
        _composition pushBack _text;
        /* _composition pushBack (parseText format ["<t align='center' size='%2' color='%3'>%1</t>", _text, _size, _color]); */
        /* _composition pushBack (format ["<t align='center' size='%2' color='%3'>%1</t>", _text, _size, _color]); */

    };
};

private _notification = [_composition, _lifetime, _skippable];

// add the queue
if (isNil {GET_QUEUE}) then {
    SET_QUEUE([]);
};

(GET_QUEUE) pushBack _notification;


/* ----------------------------------------------------------------------------
    loop
---------------------------------------------------------------------------- */
if !(localNamespace getVariable ["KISKA_notificationLoopRunning",false]) then {
    localNamespace setVariable ["KISKA_notificationLoopRunning",true];

    [] spawn {
        /* ----------------------------------------------------------------------------
            _fn_createNotification
        ---------------------------------------------------------------------------- */
        private _fn_createNotification = {
            params [
                "_composition",
                "_lifetime"
            ];

            "KISKA_ui_notify" cutRsc ["RscTitleDisplayEmpty", "PLAIN", 0, true];
            private _display = uiNamespace getVariable "RscTitleDisplayEmpty";

            private _vignette = _display displayCtrl 1202;
            _vignette ctrlShow false;

            private _text = _display ctrlCreate ["RscStructuredText", -1];

            private _structuredText = composeText _composition;
            _structuredText setAttributes ["align","center"];
            _structuredText = composeText [_structuredText];
            _text ctrlSetStructuredText _structuredText;
            _text ctrlSetBackgroundColor [0,0,0,BACKGROUND_OPACITY];
            _text ctrlCommit 0.1;

            // using CBA notification position if available
            private _left = profileNamespace getVariable ['TRIPLES(IGUI,cba_ui_notify,x)', NOTIFY_DEFAULT_X];
            private _top = profileNamespace getVariable ['TRIPLES(IGUI,cba_ui_notify,y)', NOTIFY_DEFAULT_Y];
            /* private _width = profileNamespace getVariable ['TRIPLES(IGUI,cba_ui_notify,w)', NOTIFY_MIN_WIDTH];
            private _height = profileNamespace getVariable ['TRIPLES(IGUI,cba_ui_notify,h)', NOTIFY_MIN_HEIGHT];

            _width = (ctrlTextWidth _text) max _width;

            private _textHeight = ctrlTextHeight _text; */

            private _width = ctrlTextWidth _text;
            private _height = ctrlTextHeight _text;
            // ensure the box not going off screen
            private _right = _left + _width;
            private _bottom = _top + _height;

            private _leftEdge = safezoneX;
            private _rightEdge = safezoneW + safezoneX;
            private _topEdge = safezoneY;
            private _bottomEdge = safezoneH + safezoneY;

            if (_right > _rightEdge) then {
                _left = _left - (_right - _rightEdge);
            };

            if (_left < _leftEdge) then {
                _left = _left + (_leftEdge - _left);
            };

            if (_bottom > _bottomEdge) then {
                _top = _top - (_bottom - _bottomEdge);
            };

            if (_top < _topEdge) then {
                _top = _top + (_topEdge - _top);
            };


            /* _text ctrlSetPosition [_left, _top, _width,_height]; */
            _text ctrlSetPositionW _width;
            _text ctrlSetPositionX _left;
            _text ctrlSetPositionY _top;

            _text ctrlSetFade 1;
            _text ctrlCommit 0;
            _text ctrlSetPositionH (ctrlTextHeight _text);
            _text ctrlSetFade 0;
            _text ctrlCommit (FADE_IN_TIME);

            sleep _lifetime - FADE_OUT_TIME;

            _text ctrlSetFade 1;
            _text ctrlCommit (FADE_OUT_TIME);

            sleep FADE_OUT_TIME;
        };


        /* ----------------------------------------------------------------------------
            Queue loop
        ---------------------------------------------------------------------------- */
        private ["_notificationInfo","_skippable"];
        private _queue = GET_QUEUE;

        while {(count _queue) > 0} do {
            _notificationInfo = _queue deleteAt 0;
            _skippable = _notificationInfo deleteAt 2;

            if !(_skippable AND ((count _queue) > 0)) then {
                _notificationInfo call _fn_createNotification;
            };
        };

        localNamespace setVariable ["KISKA_notificationLoopRunning",false];
    };

};


nil
