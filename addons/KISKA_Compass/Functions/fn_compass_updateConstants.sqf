#include "..\Headers\Compass Image Resolutions.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_compass_updateConstants

Description:
    Updates a number of constant global variables used for the KISKA compass.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_compass_updateConstants;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_compass_updateConstants";

private _pixelOffset = ((COMPASS_USEABLE_WIDTH / 2) - KISKA_compass_widthScale) / 2;
missionNamespace setVariable ["KISKA_compass_pixelX_min",(MIN_COMPASS_WIDTH + _pixelOffset) * KISKA_compass_scale];
missionNamespace setVariable ["KISKA_compass_pixelX_max",(MAX_COMPASS_WIDTH + _pixelOffset) * KISKA_compass_scale];

private _offset = linearConversion[ 630, 1260, KISKA_compass_widthScale, 0, 45, true ];
missionNamespace setVariable ["KISKA_compass_shownAngle_min",135 - _offset];
missionNamespace setVariable ["KISKA_compass_shownAngle_max",225 + _offset];
missionNamespace setVariable ["KISKA_compass_iconAngle_min",45 + _offset];
missionNamespace setVariable ["KISKA_compass_iconAngle_max",315 - _offset];


missionNamespace setVariable ["KISKA_compass_iconW",KISKA_compass_iconPixelSize * pixelW * KISKA_compass_scale];
missionNamespace setVariable ["KISKA_compass_iconH",KISKA_compass_iconPixelSize * pixelH * KISKA_compass_scale];

missionNamespace setVariable ["KISKA_compass_iconWidth_active",KISKA_compass_iconW * KISKA_compass_activeIconMultiplier];
missionNamespace setVariable ["KISKA_compass_iconHeight_active",KISKA_compass_iconH * KISKA_compass_activeIconMultiplier];

missionNamespace setVariable ["KISKA_compass_iconWidth_inactive",KISKA_compass_iconW * KISKA_compass_inactiveIconMultiplier];
missionNamespace setVariable ["KISKA_compass_iconHeight_inactive",KISKA_compass_iconH * KISKA_compass_inactiveIconMultiplier];
