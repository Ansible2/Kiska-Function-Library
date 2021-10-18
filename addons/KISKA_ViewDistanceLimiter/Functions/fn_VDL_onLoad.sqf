#include "..\Headers\View Distance Limiter Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_VDL_onLoad

Description:
	Acts as the onload event for the KISKA View Distance Limiter Dialog

Parameters:
	0: _display <DISPLAY> - The display of the dialog

Returns:
	NOTHING

Examples:
	(begin example)
        [display] call KISKA_fnc_VDL_onLoad;
	(end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_VDL_onLoad";

if (!hasInterface) exitWith {};

disableSerialization;

params ["_display"];

/* ----------------------------------------------------------------------------
    unload event
---------------------------------------------------------------------------- */
localNamespace setVariable [VDL_DISPLAY_VAR_STR,_display];
_display displayAddEventHandler ["Unload", {
    //params ["_display"];
    localNamespace setVariable [VDL_DISPLAY_VAR_STR,nil];
}];


/* ----------------------------------------------------------------------------
    System On Check box
---------------------------------------------------------------------------- */
(_display displayCtrl VDL_SYSTEM_ON_CHECKBOX_IDC) ctrlAddEventHandler ["CheckedChanged",{
    params ["_control", "_checked"];
    _checked = [false,true] select _checked;

    missionNamespace setVariable [VDL_GLOBAL_RUN_STR,_checked];
    if (_checked AND !(GET_VDL_GLOBAL_IS_RUNNING)) then {
        [] spawn KISKA_fnc_viewDistanceLimiter;
    };

}];


/* ----------------------------------------------------------------------------
    Tie View Distance Check box
---------------------------------------------------------------------------- */
(_display displayCtrl VDL_TIED_DISTANCE_CHECKBOX_IDC) ctrlAddEventHandler ["CheckedChanged",{
    params ["", "_checked"];
    _checked = [false,true] select _checked;
    missionNamespace setVariable [VDL_GLOBAL_RUN_STR,_checked];
}];


/* ----------------------------------------------------------------------------
    Close button
---------------------------------------------------------------------------- */
(_display displayCtrl VDL_CLOSE_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    (GET_VDL_DISPLAY) closeDisplay 2;
}];


/* ----------------------------------------------------------------------------
    Set all button
---------------------------------------------------------------------------- */
(_display displayCtrl VDL_SET_ALL_BUTTON_IDC) ctrlAddEventHandler ["ButtonClick",{
    params ["_setButton_ctrl"];

    private _display = localNamespace getVariable [VDL_DISPLAY_VAR_STR,displayNull];
    (_display getVariable VDL_CONTROL_GRPS_VAR_STR) apply {
        private _slider_ctrl = _x getVariable [CTRL_GRP_SLIDER_CTRL_VAR_STR,controlNull];

        private _varName = _x getVariable [CTRL_GRP_VAR_STR,""];
        private _value = sliderPosition _slider_ctrl;
        profileNamespace setVariable [_varName,_value];
        missionNamespace setVariable [_varName,_value];
    };

    saveProfileNamespace;
    ["Saved All changes"] call KISKA_fnc_notification;
}];


/* ----------------------------------------------------------------------------
    Control groups
---------------------------------------------------------------------------- */
private _controlGroups = [];
[
    [VDL_TARGET_FPS_CTRL_GRP_IDC, VDL_FPS_VAR_STR],
    [VDL_MIN_OBJECT_DIST_CTRL_GRP_IDC, VDL_MIN_DIST_VAR_STR],
    [VDL_MAX_OBJECT_DIST_CTRL_GRP_IDC, VDL_MAX_DIST_VAR_STR],
    [VDL_TERRAIN_DIST_CTRL_GRP_IDC, VDL_VIEW_DIST_VAR_STR],
    [VDL_CHECK_FREQ_CTRL_GRP_IDC, VDL_FREQUENCY_VAR_STR],
    [VDL_INCRIMENT_CTRL_GRP_IDC, VDL_INCREMENT_VAR_STR]
] apply {
    private _control = _display displayCtrl (_x select 0);
    [_control,_x select 1] call KISKA_fnc_VDL_controlsGroup_onLoad;
    _controlGroups pushBack _control;
};

_display setVariable [VDL_CONTROL_GRPS_VAR_STR,_controlGroups];


nil
