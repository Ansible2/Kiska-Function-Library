#include "..\..\..\Headers\Support Framework\Command Menu Macros.hpp"
#include "..\..\..\Headers\Support Framework\Support Type IDs.hpp"
// 173 TODO: redo commMenu open functions
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openCAS

Description:
    Opens a commanding menu that will allow the player to select the parameters
    of a version 1 CAS strike.

Parameters:
    0: _supportConfig <CONFIG> - The support config.
    1: _commMenuArgs <ARRAY> - The arguements passed by the CfgCommunicationMenu entry
        
        - 0. _caller <OBJECT> - The player calling for support
        - 1. _targetPosition <ARRAY> - The position (AGLS) at which the call is being made
            (where the player is looking or if in the map, the position where their cursor is)
        - 2. _target <OBJECT> - The cursorTarget object of the player
        - 3. _is3d <BOOL> - False if in map, true if not
        - 4. _commMenuId <NUMBER> The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
        - 5. _supportType <NUMBER> - The Support Type ID

    2: _numberOfUsesLeft <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)

Returns:
    NOTHING

Examples:
    (begin example)
        [

        ] call KISKA_fnc_commMenu_openCAS;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openCAS";

#define MIN_RADIUS 200

params ["_supportConfig", "_commMenuArgs", "_numberOfUsesLeft"];

if (isNull _supportConfig) exitWith {
    ["null _supportConfig used!",true] call KISKA_fnc_log;
    nil
};

private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done
private _thisArgs = _this; // just for readability


/* ----------------------------------------------------------------------------
    Vehicle Select Menu
---------------------------------------------------------------------------- */
private _supportDetailsConfig = _supportConfig >> "KISKA_supportDetails";
private _vehicles = getArray(_supportDetailsConfig >> "vehicleTypes");
private _vehicleMenu = [_vehicles] call KISKA_fnc_commMenu_buildVehicleSelectPanel;
SAVE_AND_PUSH(VEHICLE_SELECT_MENU_STR,_vehicleMenu)


/* ----------------------------------------------------------------------------
    Attack Type Menu
---------------------------------------------------------------------------- */
private _attackTypeMenu = [
    ["Attack Type",false]
];
// get allowed ammo types from config
private _attackTypes = getArray(_supportDetailsConfig >> "attackTypes");

// create formatted array to use in menu
private ["_casTitle","_keyCode"];
{
    if (_forEachIndex <= MAX_KEYS) then {
        // key codes are offset by 2 (1 on the number bar is key code 2)
        _keyCode = _forEachIndex + 2;
    } else {
        _keyCode = 0;
    };

    if (_x isEqualType []) then { // custom magazine pylons will be arrays
        // if a custom name was given in the config array for the custom ammo
        if ((count _x) > 2) then {
            _casTitle = _x select 2;
        } else {
            _casTitle = [configFile >> "CfgMagazines" >> (_x select 1)] call BIS_fnc_displayName;
        };
    } else {
        _casTitle = [_x] call KISKA_fnc_supportConfigs_getCasTitleFromId;
    };

    _attackTypeMenu pushBack STD_LINE_PUSH(_casTitle,_keyCode,_x);

} forEach _attackTypes;

SAVE_AND_PUSH(ATTACK_TYPE_MENU_STR,_attackTypeMenu)


/* ----------------------------------------------------------------------------
    Bearings Menu
---------------------------------------------------------------------------- */
_bearingsMenu = BEARING_MENU;

SAVE_AND_PUSH(BEARING_MENU_STR,_bearingsMenu)


/* ----------------------------------------------------------------------------
    Create Menu Path
---------------------------------------------------------------------------- */
_thisArgs pushBack _menuVariables;


[
    _menuPathArray,
    [_thisArgs, {
        params ["_vehicleClass","_attackType","_approachBearing"];

        private _numberOfUsesLeft = _thisArgs select 2;
        // if a ctrl key is held and one left clicks to select the support while in the map, they can call in an infinite number of the support
        if (
            visibleMap AND
            (missionNamespace getVariable ["KISKA_ctrlDown",false])
        ) exitWith {
            ["You can't call in a support while holding down a crtl key and in the map. It causes a bug with the support menu."] call KISKA_fnc_errorNotification;
            ADD_SUPPORT_BACK(_numberOfUsesLeft)
        };

        private _commMenuArgs = _thisArgs select 1;
        private _targetPosition = _commMenuArgs select 1;
        [
            AGLToASL _targetPosition,
            _attackType,
            _approachBearing,
            _vehicleClass,
            side (_commMenuArgs select 0)
        ] call KISKA_fnc_CAS;

        [SUPPORT_TYPE_CAS] call KISKA_fnc_supports_genericNotification;

        // if support still has uses left
        if (_numberOfUsesLeft > 1) then {
            _numberOfUsesLeft = _numberOfUsesLeft - 1;
            ADD_SUPPORT_BACK(_numberOfUsesLeft)
        };

        UNLOAD_GLOBALS
    }],
    [_thisArgs, {
        ADD_SUPPORT_BACK(_thisArgs select 2)
        UNLOAD_GLOBALS
    }]
] spawn KISKA_fnc_openCommandingMenuPath;


nil












/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openArty

Description:
   Opens a commanding menu that will allow the player to select the parameters
   of an artillery strike.

Parameters:
    0: _supportId <STRING> - The ID of the specific support.
    1: _supportConfig <CONFIG> - The support's config path.
    2: _numberOfRoundsLeft <NUMBER> - How many rounds this support has left to use.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "KISKA_support_1",
            configFile >> "MyArtillerySupport"
        ] call KISKA_fnc_commMenu_openArty;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openArty";

#define MIN_RADIUS 0

params [
    ["_supportId","",[""]],
    ["_supportConfig",configNull,[configNull]],
    ["_numberOfRoundsLeft",-1,[123]]
];


if (isNull _supportConfig) exitWith {
    ["null _supportConfig used!",true] call KISKA_fnc_log;
    nil
};


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

private _radiusMenuOptions = [];
private _pushedMinRadius = false;
_selectableRadiuses apply {
    private _radius = _x;
    private _isMinRadius = _radius <= MIN_RADIUS;
    if (_pushedMinRadius AND _isMinRadius) then { continue };
    if (_isMinRadius) then {
        _pushedMinRadius = true;
        _radius = MIN_RADIUS;
    };
    _radiusMenuOptions pushBack [ [_radius,"m"] joinString "", _radius ];
};


/* ----------------------------------------------------------------------------
    Round Count Menu
---------------------------------------------------------------------------- */
private _roundsMenuOptions = [];
private _canSelectRounds = [_supportDetailsConfig >> "canSelectRounds",true] call KISKA_fnc_getConfigData;
private _numberOfRoundsLeft = [_supportId] call KISKA_fnc_supports_getNumberOfUsesLeft;
if (_canSelectRounds) then {
    for "_i" from 1 to _numberOfRoundsLeft do {
        _roundsMenuOptions pushBack [[_i,"Round(s)"] joinString " ",_i]; 
    };
} else {
    _roundsMenuOptions pushBack [[_numberOfRoundsLeft,"Round(s)"] joinString " ",_numberOfRoundsLeft]; 
};


/* ----------------------------------------------------------------------------
    Create Menu
---------------------------------------------------------------------------- */
private _draw3dMarker = [_supportDetailsConfig >> "draw3dMarker",true] call KISKA_fnc_getConfigData;
if (_draw3dMarker) then {
    call KISKA_fnc_drawLookingAtMarker_start;
};

[
    [
        ["Select Ammo", getArray(_supportDetailsConfig >> "ammoTypes")],
        ["Area Spread", _radiusMenuOptions],
        ["Number of Rounds", _roundsMenuOptions]
    ],
    [[_supportId], {
        params ["_ammoClass","_radiusOfFire","_numberOfRoundsToFire"];

        // if a ctrl key is held and one left clicks to select the support while in the map, they can call in an infinite number of the support
        if (
            visibleMap AND
            (missionNamespace getVariable ["KISKA_ctrlDown",false])
        ) exitWith {
            ["You can't call in a support while holding down a crtl key and in the map. It causes a bug with the support menu."] call KISKA_fnc_errorNotification;
            nil
        };

        _thisArgs params ["_supportId"];
        [
            _supportId,
            call KISKA_fnc_supports_getCommonTargetPosition,
            _numberOfRoundsToFire,
            [_ammoClass,_radiusOfFire]
        ] call KISKA_fnc_supports_call;
    }],
    {},
    [[_draw3dMarker],{
        _thisArgs params ["_draw3dMarker"];
        if !(_draw3dMarker) exitWith {};
        
        call KISKA_fnc_drawLookingAtMarker_stop 
    }]
] spawn KISKA_fnc_openCommandingMenuPath;


nil
