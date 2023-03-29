#include "..\Headers\Icon Info Indexes.hpp"
#include "..\Headers\Compass Globals.hpp"

/* ----------------------------------------------------------------------------
    Toggle Options
---------------------------------------------------------------------------- */
[
    "KISKA_compass_show",
    "CHECKBOX",
    "Show Compass",
    "KISKA Compass",
    false,
    nil,
    {
        if (!hasInterface) exitWith {};
            
        params ["_show"];

        private _display = GET_COMPASS_DISPLAY;
        if (!isNull _display) then {
            _display setVariable [COMPASS_CONFIGED_VAR_STR,false];
        };

        if ( _show ) then {
            (COMPASS_LAYER_NAME call BIS_fnc_rscLayer) cutRsc [ "KISKA_compass_rsc", "PLAIN", -1, false ];

        } else {
            (COMPASS_LAYER_NAME call BIS_fnc_rscLayer) cutText [ "", "PLAIN", -1, false ];

        };
    }
] call CBA_fnc_addSetting;

[
    "KISKA_compass_showIcons",
    "CHECKBOX",
    "Show Icons On Compass",
    "KISKA Compass",
    true,
    nil,
    {
        if (!hasInterface) exitWith {};

        params ["_show"];

        if !(_show) then {
            private _iconMap = localNamespace getVariable COMPASS_ICON_MAP_VAR_STR;
            if (isNil "_iconMap") then {
                private _iconControl = controlNull;
                _iconMap apply {
                    _iconControl = _y select ICON_CTRL;

                    if !(isNull _iconControl) then {
                        ctrlDelete _iconControl;
                        _y set [ICON_CTRL,controlNull];
                    };
                };
            };

        };
    }
] call CBA_fnc_addSetting;


/* ----------------------------------------------------------------------------
    Appearance
---------------------------------------------------------------------------- */
private _compassListArray = [
    configFile >> "KISKA_compass" >> "compass",
    "KISKA_compass_configs"
] call KISKA_fnc_compass_parseConfig;
[
    "KISKA_compass_image",
    "LIST",
    "Compass",
    ["KISKA Compass", "Appearance"],
    _compassListArray,
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;

private _compassCenterListArray = [
    configFile >> "KISKA_compass" >> "center",
    "KISKA_compass_centerconfigs"
] call KISKA_fnc_compass_parseConfig;
[
    "KISKA_compass_center_image",
    "LIST",
    "Center Marker",
    ["KISKA Compass", "Appearance"],
    _compassCenterListArray,
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;


/* ----------------------------------------------------------------------------
    Scaling
---------------------------------------------------------------------------- */
[
    "KISKA_compass_scale",
    "SLIDER",
    "Overall Compass Scale",
    ["KISKA Compass", "Scaling"],
    [0.01, 3, 1.25, 0, true],
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;

[
    "KISKA_compass_widthScale",
    "SLIDER",
    ["Compass Width Scale","Determines how many 'pixels' of the compass are shown at once. Essentially, 1260 means you will see 180 degrees of compass at once and 630 means you will see 90 degrees"],
    ["KISKA Compass", "Scaling"],
    [630, 1260, 840, 0],
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;

[
    "KISKA_compass_y_offset",
    "SLIDER",
    ["Vertical Position Offset", "Adjusts how far beneath the top of the screen your compass is."],
    ["KISKA Compass", "Scaling"],
    [0, 100, 1, 0],
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;

[
    "KISKA_compass_iconPixelSize",
    "SLIDER",
    "Icon Size",
    ["KISKA Compass", "Scaling"],
    [10, 50, 25, 0],
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;

[
    "KISKA_compass_activeIconMultiplier",
    "SLIDER",
    "Active Icon Size Multiplier",
    ["KISKA Compass", "Scaling"],
    [1, 2, 1.5, 2],
    nil,
    {
        call KISKA_fnc_compass_updateConstants;
        call KISKA_fnc_compass_refresh;
    }
] call CBA_fnc_addSetting;

[
    "KISKA_compass_inactiveIconMultiplier",
    "SLIDER",
    "Inactive Icon Size Multiplier",
    ["KISKA Compass", "Scaling"],
    [1, 2, 1, 2],
    nil,
    {
        call KISKA_fnc_compass_updateColors;
    }
] call CBA_fnc_addSetting;



/* ----------------------------------------------------------------------------
    Colors
---------------------------------------------------------------------------- */
[
    "KISKA_compass_mainColor",
    "COLOR",
    "Main Compass Color",
    ["KISKA Compass","Colors"],
    [1,1,1,1],
    nil,
    {
        call KISKA_fnc_compass_updateColors;
    }
] call CBA_fnc_addSetting;
[
    "KISKA_compass_centerColor",
    "COLOR",
    "Center Markers Color",
    ["KISKA Compass","Colors"],
    [0,1,0,1],
    nil,
    {
        call KISKA_fnc_compass_updateColors;
    }
] call CBA_fnc_addSetting;
[
    "KISKA_compass_backgroundColor",
    "COLOR",
    "Background Color",
    ["KISKA Compass","Colors"],
    [0,0,0,0], // transparent
    nil,
    {
        call KISKA_fnc_compass_updateColors;
    }
] call CBA_fnc_addSetting;
