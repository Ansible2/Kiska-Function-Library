#include "..\Headers\Compass IDCs.hpp"
#include "..\Headers\Icon Info Indexes.hpp"
#include "..\Headers\Compass Globals.hpp"
#include "..\Headers\Compass Image Resolutions.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_compass_mainLoop

Description:
    Creates and then continues to execute a loop controlling the compass.

Parameters:
    0: _display <DISPLAY> - The display the compass will be on

Returns:
    NOTHING

Examples:
    (begin example)
        [findDisplay 46] spawn KISKA_fnc_compass_mainLoop;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_compass_mainLoop";

#define INACTIVE_IDC -1
#define SIMPLIFY_ANGLE(angle) (((angle) % 360) + 360) % 360;

if (!hasInterface) exitWith {};

// check if main menu
if (call KISKA_fnc_isMainMenu) exitWith {};

disableSerialization;

params [
    ["_display",displayNull,[displayNull]]
];


_display displayAddEventHandler ["Unload", {
    localNamespace setVariable [COMPASS_DISPLAY_VAR_STR,displayNull];
}];

private [
    "_ctrlGrp",
    "_compass",
    "_cameraVectorDir",
    "_cameraHeading",
    "_posX",
    "_grpW",
    "_grpWDivided",
    "_ctrlPos",
    "_iconMap",
    "_iconWidth",
    "_iconHeight",
    "_iconControl",
    "_iconColor",
    "_iconText",
    "_iconPos",
    "_iconWidthDivided",
    "_camDirTo",
    "_opposite"
];


waitUntil {
    if (!KISKA_compass_show OR (isNull _display)) exitWith {true};

    if !( _display getVariable [COMPASS_CONFIGED_VAR_STR,false] ) then {
        [ _display ] call KISKA_fnc_compass_configure;
    };

    _ctrlGrp = _display getVariable COMPASS_MAIN_CTRL_GRP_VAR_STR;
    _compass = _display getVariable COMPASS_IMAGE_CTRL_VAR_STR;

    _cameraVectorDir = getCameraViewDirection player;
    _cameraHeading = SIMPLIFY_ANGLE((_cameraVectorDir select 0) atan2 (_cameraVectorDir select 1));
    // convert heading to actual pixel position of compass control
    _posX = linearConversion[ 0, 360, _cameraHeading, KISKA_compass_pixelX_min, KISKA_compass_pixelX_max, true ];

    _compass ctrlSetPositionX -( _posX * pixelW ); // scroll the compass
    _compass ctrlCommit 0;



    // draw icons
    _iconMap = localNamespace getVariable [COMPASS_ICON_MAP_VAR_STR,[]];
    if (KISKA_compass_showIcons AND {(count _iconMap) > 0}) then {
        _ctrlPos = _display getVariable COMPASS_MAIN_CTRL_GRP_POS_VAR_STR;
        _grpW = _ctrlPos select 2;
        _grpWDivided = _grpW / 2;


        _iconMap apply {

            _iconPos = _y select ICON_POS;
            call {
                if (_iconPos isEqualType []) exitWith {
                    _camDirTo = SIMPLIFY_ANGLE(_cameraHeading - (player getDir _iconPos));
                };

                if (_iconPos isEqualType objNull AND {!( isNull _iconPos )}) exitWith {
                    _camDirTo = SIMPLIFY_ANGLE(_cameraHeading - (player getDir _iconPos));
                };

                if (_iconPos isEqualType locationNull AND {!( isNull _iconPos )}) exitWith {
                    private _locationPos = locationPosition _iconPos;
                    _camDirTo = SIMPLIFY_ANGLE(_cameraHeading - (player getDir _locationPos));
                };

                if (_iconPos isEqualType "") exitWith {
                    private _markerPos = getMarkerPos _iconPos;
                    if ( _markerPos isNotEqualTo [0,0,0] ) then {
                        _camDirTo = SIMPLIFY_ANGLE(_cameraHeading - (player getDir _markerPos));
                    };
                };

                _camDirTo = nil;
            };

            _iconControl = _y select ICON_CTRL;
            // only update if actually visible on compass range
            if (
                !(isNil "_camDirTo") AND
                {
                    (_camDirTo >= KISKA_compass_iconAngle_max) OR
                    {_camDirTo <= KISKA_compass_iconAngle_min}
                }
            ) then {
                private _iconActive = _y select ICON_ACTIVE;
                _iconWidth = [KISKA_compass_iconWidth_inactive,KISKA_compass_iconWidth_active] select _iconActive;

                _iconWidthDivided = _iconWidth / 2;
                _iconText = _y select ICON_TEXT; // this is the icon's picture path
                _iconColor = _y select ICON_COLOR;


                if (isNull _iconControl) then {
                    _iconControl = _display ctrlCreate [ "ctrlActivePicture", INACTIVE_IDC, _ctrlGrp ];

                    _iconHeight = [KISKA_compass_iconHeight_inactive,KISKA_compass_iconHeight_active] select _iconActive;
                    private _grpH = _ctrlPos select 3;
                    _iconControl ctrlSetPosition [_grpWDivided - _iconWidthDivided, _grpH - _iconHeight, _iconWidth, _iconHeight];

                    _iconControl ctrlSetText _iconText;
                    _iconControl ctrlSetTextColor _iconColor;

                    _iconControl ctrlCommit 0;
                    _y set [ ICON_CTRL, _iconControl ];

                } else {
                    if !(ctrlShown _iconControl) then {
                        _iconControl ctrlShow true;
                    };

                    if ( (ctrlText _iconControl) isNotEqualTo _iconText) then {
                        _iconControl ctrlSetText _iconText;
                    };

                    if ( (ctrlTextColor _iconControl) isNotEqualTo _iconColor) then {
                        _iconControl ctrlSetTextColor _iconColor;
                    };

                    // get the opposite angle
                    _opposite = SIMPLIFY_ANGLE(-_camDirTo + 180);
                    _posX = linearConversion[ KISKA_compass_shownAngle_min, KISKA_compass_shownAngle_max, _opposite, 0, _grpW, true ];
                //    hintSilent ([_camDirTo,_opposite,KISKA_compass_shownAngle_max,KISKA_compass_shownAngle_min] joinString "\n");
                    _iconControl ctrlSetPositionX (_posX - _iconWidthDivided);
                    _iconControl ctrlCommit 0;

                };
            } else {
                if (ctrlShown _iconControl) then {
                    _iconControl ctrlShow false;
                };

            };

        };
    };


    false
};
