#include "..\Headers\Compass Globals.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_compass_addIcon

Description:
	Adds and icon to the compass

Parameters:
    0: _iconId <STRING> - A unique id for referencing the compass marker
	1: _iconText <STRING> - The icon's image path or text
    2: _iconPos <ARRAY, OBJECT, MARKER, or LOCATION> - The position of the icon
    3: _color <ARRAY> - The RGBa of the icon
    4: _isActive <BOOL> - Icon will use "active" scale of icon

Returns:
	<BOOL> - false if new iconId, true if overwriting the icon id

Examples:
    (begin example)
		[
            "myMarkerID"
            "images\info_icon.paa"
        ] call KISKA_fnc_compass_addIcon;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_compass_addIcon";

params [
    ["_iconId","",[""]],
    ["_iconText","",[""]],
    ["_iconPos",[0,0,0],[[],objNull,"",locationNull]],
    ["_color",[1,1,1,1],[[]],4],
    ["_isActive",true,[true]]
];


private _hashMap = GET_COMPASS_ICON_MAP_DEFAULT;
private _overWritten = _hashMap set [_iconId,
    [
        _iconText,
        _iconPos,
        _color,
        _isActive,
        controlNull
    ]
];

if (isNil {GET_COMPASS_ICON_MAP}) then {
    localNamespace setVariable [COMPASS_ICON_MAP_VAR_STR,_hashMap];
};


_overWritten
