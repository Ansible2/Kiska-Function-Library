#include "..\..\Headers\ConversationDialogCommonDefines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convo_createResponseDialog

Description:
    Creates or shows the response dialog to be able to selecte a response during
     a KISKA conversation.

Parameters:
    0: _speakingTo <OBJECT> - The NPC "person" the player is supposed to be speaking to.
        Can also be something like a game logic.
    1: _conversationConfig <CONFIG> - The config of the opened conversation in
        `_topicConfig >> "conversations"` class to open a dialog for.
    2: _topicConfig <CONFIG> - A config path to the *conversation* topic config.

Returns:
    NOTHING

Examples:
    (begin example)
        SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convo_createResponseDialog";
disableSerialization;

params ["_speakingTo","_conversationConfig","_topicConfig"];

private _optionsConfigClass = _conversationConfig >> "Options";
private _optionConfigs = configProperties [_optionsConfigClass,"isClass _x"];
if (_optionConfigs isEqualTo []) exitWith {
    [
        [
            "No Options found in conversation config ",
            _conversationConfig
        ],
        true
    ] call KISKA_fnc_log;
    call KISKA_fnc_convo_close;
    nil
};

private _display = localNamespace getVariable ["KISKA_converstationResponse_display",displayNull];
private _eventArgs = [_optionConfigs,_topicConfig,_speakingTo];
private "_listBoxControl";
if !(isNull _display) then {
    _display setVariable ["KISKA_convo_eventArgs",_eventArgs];
    (allControls _display) apply { 
        _x ctrlShow true;
        _x ctrlEnable true;
    };

} else {
    _display = createDialog ["KISKA_converstationResponse_dialog",true];
    _display setVariable ["KISKA_convo_eventArgs",_eventArgs];
    localNamespace setVariable ["KISKA_converstationResponse_display",_display];

    (_display displayCtrl CONVERSATION_DIALOG_HEADER_TEXT_IDC) ctrlSetText (name _speakingTo);
    _listBoxControl = _display displayCtrl CONVERSATION_DIALOG_OPTIONS_LISTBOX_IDC;
    _listBoxControl ctrlAddEventHandler ["LBDblClick", {
        params ["_control", "_selectedIndex"];

        private _display = ctrlParent _control;
        (_display getVariable "KISKA_convo_eventArgs") params [
            "_optionConfigs",
            "_topicConfig",
            "_speakingTo"
        ];

        [
            _optionConfigs select _selectedIndex,
            _speakingTo,
            _topicConfig
        ] call KISKA_fnc_convo_onOptionSelected;
        _display setVariable ["KISKA_convo_selectedOptionIndex",nil];
    }];

    _listBoxControl ctrlAddEventHandler ["LbSelChanged",{
        params ["_control","_selectedIndex"];
        private _display = ctrlParent _control;
        _display setVariable ["KISKA_convo_selectedOptionIndex",_selectedIndex];
    }];

    _display displayAddEventHandler ["KeyDown", {
        #define ESCAPE_KEY 1
        params ["", "_key"];
        
        private _dontCloseDialog = _key isEqualTo ESCAPE_KEY;
        _dontCloseDialog
    }];

    private _selectButton = _display displayCtrl CONVERSATION_DIALOG_OPTIONS_SELECT_IDC;
    _selectButton ctrlAddEventHandler ["ButtonClick",{
        params ["_control"];

        private _display = ctrlParent _control;
        private _selectedIndex = _display getVariable ["KISKA_convo_selectedOptionIndex",-1];
        if (_selectedIndex >= 0) then {
            (_display getVariable "KISKA_convo_eventArgs") params [
                "_optionConfigs",
                "_topicConfig",
                "_speakingTo"
            ];

            [
                _optionConfigs select _selectedIndex,
                _speakingTo,
                _topicConfig
            ] call KISKA_fnc_convo_onOptionSelected;
            _display setVariable ["KISKA_convo_selectedOptionIndex",nil];
        };
    }];
};


if (isNil "_listBoxControl") then {
    _listBoxControl = _display displayCtrl CONVERSATION_DIALOG_OPTIONS_LISTBOX_IDC;
};
lbClear _listBoxControl;
_optionConfigs apply {
    private _text = getText(_x >> "text");
    if (_text isEqualTo "") then {
        private _lineName = getText(_x >> "line");
        private _subtitleText = getText(_topicConfig >> "lines" >> "Sentences" >> _lineName >> "subtitle");
        if (_subtitleText isNotEqualTo "") then {
            _text = _subtitleText;
        } else {
            _text = configName _x;
        };
    };

    if (_x call KISKA_fnc_convo_hasOptionBeenSelected) then {
        _text = ["<SELECTED>",_text] joinString " ";
    };

    _listBoxControl lbAdd _text;
};


nil
