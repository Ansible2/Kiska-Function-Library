#include "..\Headers\Command Menu Macros.hpp"
#include "..\Headers\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForCAS

Description:
    Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.

    This is essentially just another level of abrstraction to be able to more easily reuse
     code between similar supports and make things easier to read instead of fitting it all
     in the config.

Parameters:
    0: _supportClass <STRING> - The class as defined in the CfgCommunicationMenu
    1: _commMenuArgs <ARRAY> - The arguements passed by the CfgCommunicationMenu entry
        
        0. _caller <OBJECT> - The player calling for support
        1. _targetPosition <ARRAY> - The position (AGLS) at which the call is being made
            (where the player is looking or if in the map, the position where their cursor is)
        2. _target <OBJECT> - The cursorTarget object of the player
        3. _is3d <BOOL> - False if in map, true if not
        4. _commMenuId <NUMBER> The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
        5. _supportType <NUMBER> - The Support Type ID

    2: _useCount <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)

Returns:
    NOTHING

Examples:
    (begin example)
        [] call KISKA_fnc_callingForCAS;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForCAS";

#define MIN_RADIUS 200

params [
    "_supportClass",
    "_commMenuArgs",
    ["_useCount",-1]
];


private _supportConfig = [["CfgCommunicationMenu",_supportClass]] call KISKA_fnc_findConfigAny;
if (isNull _supportConfig) exitWith {
    [["Could not find class: ",_supportClass," in any config!"],true] call KISKA_fnc_log;
    nil
};

// get use count from config if -1
private _args = _this; // just for readability
private _useCountConfig = _supportConfig >> "useCount";
if (_useCount < 0 AND (isNumber _useCountConfig)) then {
    _useCount = getNumber _useCountConfig;
    _args set [2,_useCount];
};

private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done


/* ----------------------------------------------------------------------------
    Vehicle Select Menu
---------------------------------------------------------------------------- */
private _vehicles = [_supportConfig >> "vehicleTypes"] call BIS_fnc_getCfgDataArray;
if (_vehicles isEqualTo []) then {
    _vehicles = [side (_commMenuArgs select 0),_commMenuArgs select 5] call KISKA_fnc_getSupportVehicleClasses;
};

private _vehicleMenu = [_vehicles] call KISKA_fnc_createVehicleSelectMenu;
SAVE_AND_PUSH(VEHICLE_SELECT_MENU_STR,_vehicleMenu)


/* ----------------------------------------------------------------------------
    Attack Type Menu
---------------------------------------------------------------------------- */
private _attackTypeMenu = [
    ["Attack Type",false]
];
// get allowed ammo types from config
private _attackTypes = [_supportConfig >> "attackTypes"] call BIS_fnc_getCfgDataArray;

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
        _casTitle = [_x] call KISKA_fnc_getCasTitleFromId;
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
_args pushBack _menuVariables;


[
    _menuPathArray,
    [_args, {
        params ["_vehicleClass","_attackType","_approachBearing"];

        private _useCount = _thisArgs select 2;
        // if a ctrl key is held and one left clicks to select the support while in the map, they can call in an infinite number of the support
        if (
            visibleMap AND
            (missionNamespace getVariable ["KISKA_ctrlDown",false])
        ) exitWith {
            ["You can't call in a support while holding down a crtl key and in the map. It causes a bug with the support menu."] call KISKA_fnc_errorNotification;
            ADD_SUPPORT_BACK(_useCount)
        };

        private _commMenuArgs = _thisArgs select 1;
        private _targetPosition = _commMenuArgs select 1;
        [
            AGLToASL _targetPosition,
            _attackType,
            _approachBearing,
            _vehicleClass,
            side (_commMenuArgs select 0)
        ] spawn KISKA_fnc_CAS;

        [SUPPORT_TYPE_CAS] call KISKA_fnc_supportNotification;

        // if support still has uses left
        if (_useCount > 1) then {
            _useCount = _useCount - 1;
            ADD_SUPPORT_BACK(_useCount)
        };

        UNLOAD_GLOBALS
    }],
    [_args, {
        ADD_SUPPORT_BACK(_thisArgs select 2)
        UNLOAD_GLOBALS
    }]
] spawn KISKA_fnc_commandMenuTree;


nil
