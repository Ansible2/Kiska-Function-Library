#include "..\Headers\Compass IDCs.hpp"
#include "..\Headers\Compass Globals.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_compass_configure

Description:
	Initializes several display namespace variables for the compass and sets
	 up their images for the compass.

Parameters:
	0: _display <DISPLAY> - The display of the compass

Returns:
	NOTHING

Examples:
    (begin example)
		call KISKA_fnc_compass_configure;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_compass_configure";

disableSerialization;

params [
	["_display",displayNull]
];
if (isNull _display) exitWith {};


localNamespace setVariable [COMPASS_DISPLAY_VAR_STR,_display];

private _mainCompassCtrlGroup = _display displayCtrl COMPASS_GRP_IDC;
_display setVariable [COMPASS_MAIN_CTRL_GRP_VAR_STR,_mainCompassCtrlGroup];

private _compassImageCtrl = _mainCompassCtrlGroup controlsGroupCtrl COMPASS_IMG_IDC;
_display setVariable [COMPASS_IMAGE_CTRL_VAR_STR,_compassImageCtrl];

private _compassBackgroundCtrl = _mainCompassCtrlGroup controlsGroupCtrl COMPASS_BACK_IDC;
_display setVariable [COMPASS_BACKGROUND_CTRL_VAR_STR,_compassBackgroundCtrl];

private _compassCenterMarkersCtrl = _mainCompassCtrlGroup controlsGroupCtrl COMPASS_CENTER_IDC;
_display setVariable [COMPASS_CENTER_MARKERS_CTRL_VAR_STR,_compassCenterMarkersCtrl];



[
	[ _mainCompassCtrlGroup, true ],
	[ _compassImageCtrl, false, KISKA_compass_mainColor, KISKA_compass_image ],
	[ _compassBackgroundCtrl, false, KISKA_compass_backgroundColor, "#(rgb,8,8,3)color(1,1,1,1)" ],
	[ _compassCenterMarkersCtrl, false, KISKA_compass_centerColor, KISKA_compass_center_image ]
] apply {
	_x params [
		"_ctrl",
		"_changePos",
		[ "_color", [1,1,1,1] ],
		[ "_image", "" ]
	];


	(ctrlPosition _ctrl) params[ "_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH" ];
	if (_ctrlW isEqualTo 0) then {
		_ctrlW = KISKA_compass_widthScale * pixelW;
	};


	// ctrlSetScale cuts off the image (I don't know why for now, so using this scaling instead)
	// ctrlSetScale also scales in such a way that is not ideal for the compass
	_ctrlW = _ctrlW * KISKA_compass_scale;
	_ctrlH = _ctrlH * KISKA_compass_scale;
	if ( _changePos ) then {
		_ctrlX = ( safeZoneX + ( safeZoneW / 2 ) - ( _ctrlW / 2 ) );
		_ctrlY = safeZoneY + ((pixelH * pixelGrid) * KISKA_compass_y_offset)
	};

	// using ctrlSetPosition instead of individual commands because setting them with those causes the compass to be offset from center
	_ctrl ctrlSetPosition [_ctrlX,_ctrlY,_ctrlW,_ctrlH];
	_ctrl ctrlCommit 0;


	if ( _image isNotEqualTo "" ) then {
		_ctrl ctrlSetText _image;
		_ctrl ctrlSetTextColor _color;
	};

};


private _mainCtrlGrp_pos = ctrlPosition _mainCompassCtrlGroup;
_display setVariable [COMPASS_MAIN_CTRL_GRP_POS_VAR_STR,_mainCtrlGrp_pos];


// position center marker at the center of the control group
private _mainCtrlGrp_posX_by2 = (_mainCtrlGrp_pos select 2) / 2;
(ctrlPosition _compassCenterMarkersCtrl) params[ "", "_ctrlY", "_ctrlW", "" ];
_compassCenterMarkersCtrl ctrlSetPosition[ _mainCtrlGrp_posX_by2 - ( _ctrlW / 2 ), _ctrlY  ];
_compassCenterMarkersCtrl ctrlCommit 0;


_display setVariable [COMPASS_CONFIGED_VAR_STR,true];
