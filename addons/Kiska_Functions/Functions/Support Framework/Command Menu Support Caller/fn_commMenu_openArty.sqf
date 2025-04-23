#include "..\..\..\Headers\Support Framework\Arty Ammo Classes.hpp"
#include "..\..\..\Headers\Support Framework\Command Menu Macros.hpp"
#include "..\..\..\Headers\Support Framework\Support Type IDs.hpp"
// 173 TODO: redo commMenu open functions
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openArty

Description:
   Opens a commanding menu that will allow the player to select the parameters
   of an artillery strike.

Parameters:
    0: _supportId <STRING> - The ID of the specific support.
    1: _supportConfig <CONFIG> - The support's config path.
    2: _targetPosition <PositionASL[]> - The position the player is looking at or 
        the current position of the player's cursor on the map.
    3: _numberOfRoundsLeft <NUMBER> - How many rounds this support has left to use.
    4: _is3d <BOOL> - `false` if player is in the map, `true` if they are looking at the map.
    5: _cursorTarget <OBJECT> - The player's `cursorTarget`.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_support_1",
            configFile >> "MyArtillerySupport",
            [0,0,0],
            20,
            true,
            objNull
        ] call KISKA_fnc_commMenu_openArty;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openArty";

#define AMMO_TYPE_MENU_GVAR "KISKA_menu_ammoSelect"
#define ROUND_COUNT_MENU_GVAR "KISKA_menu_roundCount"
#define RADIUS_MENU_GVAR "KISKA_menu_radius"
#define MIN_RADIUS 0

params [
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]],
    ["_targetPosition",[],[[]],3],
    ["_numberOfRoundsLeft",-1,[123]],
    ["_is3d",false,[true]],
    ["_cursorTarget",cursorTarget,[objNull]]
];


if (isNull _supportConfig) exitWith {
    ["null _supportConfig used!",true] call KISKA_fnc_log;
    nil
};

private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done

/* ----------------------------------------------------------------------------
    Ammo Menu
---------------------------------------------------------------------------- */
private _ammoMenu = [
    ["Select Ammo",false] // menu title
];
private _supportDetailsConfig = _supportConfig >> "KISKA_supportDetails";
private "_keyCode";
{
    if (_forEachIndex <= MAX_KEYS) then {
        // key codes are offset by 2 (1 on the number bar is key code 2)
        _keyCode = _forEachIndex + 2;
    } else {
        _keyCode = 0;
    };

    _x params [
        "_ammoClass",
        ["_ammoTitle","Undefined Ammo Title"]
    ];

    _ammoMenu pushBack [
        _ammoTitle,
        [_keyCode],
        "", // submenu
        -5 // execute command
        [["expression", format ["(localNamespace getVariable 'KISKA_commMenuTree_params') pushBack '%1'; localNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];",_ammoClass]]],
        "1", // is active
        "1" // is visible
    ];
} forEach (getArray(_supportDetailsConfig >> "ammoTypes"));

missionNamespace setVariable [AMMO_TYPE_MENU_GVAR,_ammoMenu];
_menuVariables pushBack AMMO_TYPE_MENU_GVAR;
_menuPathArray pushBack (["#USER:",AMMO_TYPE_MENU_GVAR] joinString "");


/* ----------------------------------------------------------------------------
    Radius Menu
---------------------------------------------------------------------------- */
private _selectableRadiuses = getArray(_supportDetailsConfig >> "radiuses");
if (_selectableRadiuses isEqualTo []) then {
    _selectableRadiuses = missionNamespace getVariable ["KISKA_CBA_supp_radiuses_arr",[]];

    if (_selectableRadiuses isEqualTo []) then {
        _selectableRadiuses = [200];
    };
};
sort _selectableRadiuses;

private _radiusMenu = [
    ["Area Spread",false]
];
private _pushedMinRadius = false;
{
    private _radius = _x;
    private _isMinRadius = _radius <= MIN_RADIUS;
    if (_pushedMinRadius AND _isMinRadius) then { continue };
    if (_isMinRadius) then {
        _pushedMinRadius = true;
        _radius = MIN_RADIUS;
    };

    if (_forEachIndex <= MAX_KEYS) then {
        // key codes are offset by 2 (1 on the number bar is key code 2)
        _keyCode = _forEachIndex + 2;
    } else {
        _keyCode = 0;
    };

    // _radiusMenu pushBack DISTANCE_LINE(_x,_keyCode);
    _radiusMenu pushBack [
        ([_radius,"m"] joinString ""),
        [_keyCode],
        "",
        -5
        [["expression", format ["(localNamespace getVariable 'KISKA_commMenuTree_params') pushBack %1; localNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];",_radius]]],
        "1", // is active
        "1" // is visible
    ];
} forEach _selectableRadiuses;

missionNamespace setVariable [RADIUS_MENU_GVAR,_radiusMenu];
_menuVariables pushBack RADIUS_MENU_GVAR;
_menuPathArray pushBack (["#USER:",RADIUS_MENU_GVAR] joinString "");


/* ----------------------------------------------------------------------------
    Round Count Menu
---------------------------------------------------------------------------- */
private _roundsMenu = [
    ["Number of Rounds",false]
];
private _canSelectRounds = [_supportDetailsConfig >> "canSelectRounds",true] call KISKA_fnc_getConfigData;
if (_canSelectRounds) then {
    for "_i" from 1 to _numberOfRoundsLeft do {
        if (_i <= MAX_KEYS) then {
            _keyCode = _i + 1;
        } else {
            _keyCode = 0;
        };

        _roundsMenu pushBack [
            ([_i,"Round(s)"] joinString " "),
            [_keyCode],
            "",
            -5
            [["expression", format ["(localNamespace getVariable 'KISKA_commMenuTree_params') pushBack %1; localNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];",_i]]],
            "1",
            "1"
        ];
    };

} else {
    _roundsString = [_numberOfRoundsLeft,"Round(s)"] joinString " ";
    _roundsMenu pushBack [
        ([_numberOfRoundsLeft,"Round(s)"] joinString " "),
        [2],
        "",
        -5
        [["expression", format ["(localNamespace getVariable 'KISKA_commMenuTree_params') pushBack %1; localNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];",_numberOfRoundsLeft]]],
        "1",
        "1"
    ];

};

missionNamespace setVariable [ROUND_COUNT_MENU_GVAR,_roundsMenu];
_menuVariables pushBack ROUND_COUNT_MENU_GVAR;
_menuPathArray pushBack (["#USER:",ROUND_COUNT_MENU_GVAR] joinString "");


/* ----------------------------------------------------------------------------
    Create Menu
---------------------------------------------------------------------------- */
if ([_supportConfig >> "draw3dMarker",true] call KISKA_fnc_getConfigData) then {
    call KISKA_fnc_drawLookingAtMarker_start;
};

private _thisArgs = [
    _menuVariables,
    _numberOfRoundsLeft,
    _supportId
];

[
    _menuPathArray,
    [_thisArgs, {
        params ["_ammo","_radius","_numberOfRounds"];

        private _roundsAvailable = _thisArgs select 2;
        // if a ctrl key is held and one left clicks to select the support while in the map, they can call in an infinite number of the support
        if (
            visibleMap AND
            (missionNamespace getVariable ["KISKA_ctrlDown",false])
        ) exitWith {
            ["You can't call in a support while holding down a crtl key and in the map. It causes a bug with the support menu."] call KISKA_fnc_errorNotification;
            nil
        };

        // TODO: this should be in another function to find the support position
        private "_targetPosition";
        if (visibleMap) then {
            _targetPosition = call KISKA_fnc_getMapCursorPosition;
        } else {
            _targetPosition = call KISKA_fnc_getPositionPlayerLookingAt;
        };


        // TODO: this should be handled in the call event form KISKA_fnc_supports_call
        [_targetPosition,_ammo,_radius,_numberOfRounds] spawn KISKA_fnc_virtualArty;
        [SUPPORT_TYPE_ARTY] call KISKA_fnc_supports_genericNotification;

        UNLOAD_GLOBALS
        call KISKA_fnc_drawLookingAtMarker_stop;
    }],
    [_thisArgs, {
        UNLOAD_GLOBALS
        call KISKA_fnc_drawLookingAtMarker_stop;
    }]
] spawn KISKA_fnc_commMenu_openTree;


nil
