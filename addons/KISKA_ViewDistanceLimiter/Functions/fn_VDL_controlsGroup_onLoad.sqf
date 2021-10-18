#include "..\Headers\View Distance Limiter Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_VDL_controlsGroup_onLoad

Description:
	Acts as the onload event for the KISKA View Distance Limiter Dialog

Parameters:
	0: _controlsGroup <CONTROL> - The controls group for the particular setting
	1: _varName <STRING> - The name of the profileNamespace variable in which this
        setting will be saved when changed

Returns:
	NOTHING

Examples:
	(begin example)
        [controlsGroup,"someName"] call KISKA_fnc_VDL_controlsGroup_onLoad;
	(end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_VDL_controlsGroup_onLoad";

if (!hasInterface) exitWith {};

disableSerialization;

params ["_controlsGroup","_varName"];


_controlsGroup setVariable [CTRL_GRP_PROFILE_VAR_STR,_varName];

/* ----------------------------------------------------------------------------
    Slider
---------------------------------------------------------------------------- */
private _slider_ctrl = _controlsGroup controlsGroupCtrl SLIDER_IDC;
_controlsGroup setVariable [CTRL_GRP_SLIDER_CTRL_VAR_STR,_slider_ctrl];
_slider_ctrl ctrlAddEventHandler ["SliderPosChanged",{
    params ["_slider_ctrl", "_newValue"];

    private _paramControlGroup = ctrlParentControlsGroup _slider_ctrl;
    private _editBox_ctrl = _paramControlGroup getVariable CTRL_GRP_EDIT_CTRL_VAR_STR;
    _editBox_ctrl ctrlSetText (str _newValue);
}];


/* ----------------------------------------------------------------------------
    Set Button
---------------------------------------------------------------------------- */
private _setButton_ctrl = _controlsGroup controlsGroupCtrl BUTTON_IDC;
//_controlsGroup setVariable [CTRL_GRP_BUTTON_CTRL_VAR_STR,_setButton_ctrl];
_setButton_ctrl ctrlAddEventHandler ["ButtonClick",{
    params ["_setButton_ctrl"];

    private _paramControlGroup = ctrlParentControlsGroup _setButton_ctrl;
    private _slider_ctrl = _paramControlGroup getVariable [CTRL_GRP_SLIDER_CTRL_VAR_STR,controlNull];

    private _varName = _paramControlGroup getVariable CTRL_GRP_PROFILE_VAR_STR;
    private _value = sliderPosition _slider_ctrl;

    profileNamespace setVariable [_varName,_value];
    missionNamespace setVariable [_varName,_value];

    saveProfileNamespace;
    ["Saved changes"] call KISKA_fnc_notification;
}];


/* ----------------------------------------------------------------------------
    Edit Box
---------------------------------------------------------------------------- */
private _editBox_ctrl = _controlsGroup controlsGroupCtrl EDIT_IDC;
_controlsGroup setVariable [CTRL_GRP_EDIT_CTRL_VAR_STR,_editBox_ctrl];
_editBox_ctrl ctrlAddEventHandler ["KeyUp",{
    params ["_editBox_ctrl"];

    private _text = ctrlText _editBox_ctrl;
    private _number = _text call BIS_fnc_parseNumberSafe;
    // if we don't check that an actual number is present, we can't start with a blank edit box if say doing negative numbers
    if (str _number == _text) then {
        private _paramControlGroup = ctrlParentControlsGroup _editBox_ctrl;
        private _slider_ctrl = _paramControlGroup getVariable CTRL_GRP_SLIDER_CTRL_VAR_STR;

        private _sliderRange = sliderRange _slider_ctrl;
        private _sliderMin = _sliderRange select 0;
        private _sliderMax = _sliderRange select 1;
        // check to see if entered number fits inside slider range
        if ((_number >= _sliderMin) AND {_number <= _sliderMax}) then {
            _slider_ctrl ctrlSetTooltip (str _number);
            _slider_ctrl sliderSetPosition _number;
        };
    };
}];



private _defaultValue = getNumber(configFile >> "KISKA_viewDistanceLimiter_dialog" >> "controls" >> ctrlClassName _controlsGroup >> "controls" >> "settingSlider" >> "sliderPosition");
private _profileValue = profileNamespace getVariable [_varName,_defaultValue];
private _currentValue = missionNamespace getVariable [_varName,_profileValue];

_editBox_ctrl ctrlSetText (str _currentValue);
_slider_ctrl sliderSetPosition _currentValue;


nil
