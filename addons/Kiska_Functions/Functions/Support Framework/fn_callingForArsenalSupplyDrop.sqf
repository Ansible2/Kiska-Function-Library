#include "..\..\Headers\Support Framework\Command Menu Macros.hpp"
#include "..\..\Headers\Support Framework\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForArsenalSupplyDrop

Description:
    Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.

    This is essentially just another level of abstraction to be able to more easily reuse
     code between similar supports and make things easier to read instead of fitting it all
     in the config.

Parameters:
    0: _supportConfig <CONFIG> - The support config.
    1: _commMenuArgs <ARRAY> - The arguements passed by the CfgCommunicationMenu entry
        
        - 0. _caller <OBJECT> - The player calling for support
        - 1. _targetPosition <ARRAY> - The position (AGLS) at which the call is being made
            (where the player is looking or if in the map, the position where their cursor is)
        - 2. _target <OBJECT> - The cursorTarget object of the player
        - 3. _is3d <BOOL> - False if in map, true if not
        - 4. _commMenuId <NUMBER> - The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
        - 5. _supportType <NUMBER> - The Support Type ID

    2: _numberOfUsesLeft <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)

Returns:
    NOTHING

Examples:
    (begin example)
        [
        
        ] call KISKA_fnc_callingForArsenalSupplyDrop;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForArsenalSupplyDrop";

#define ARSENAL_CRATE_TYPE "B_supplyCrate_F"
#define FLYIN_RADIUS 2000
#define ARSENAL_LIFETIME -1

params [
    "_supportConfig",
    "_commMenuArgs",
    ["_numberOfUsesLeft",-1]
];


if (isNull _supportConfig) exitWith {
    ["Null _supportConfig used",true] call KISKA_fnc_log;
    nil
};


private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done

// get use count from config if -1
private _thisArgs = _this; // just for readability
private _useCountConfig = _supportConfig >> "useCount";
if (_numberOfUsesLeft < 0 AND (isNumber _useCountConfig)) then {
    _numberOfUsesLeft = getNumber _useCountConfig;
    _thisArgs set [2,_numberOfUsesLeft];
};

/* ----------------------------------------------------------------------------
    Vehicle Select Menu
---------------------------------------------------------------------------- */
private _vehicles = [_supportConfig >> "vehicleTypes"] call BIS_fnc_getCfgDataArray;
if (_vehicles isEqualTo []) then {
    _vehicles = [side (_commMenuArgs select 0),_commMenuArgs select 5] call KISKA_fnc_getSupportVehicleClasses;
};

private _vehicleMenu = [_vehicles] call KISKA_fnc_commMenu_buildVehicleSelectPanel;
SAVE_AND_PUSH(VEHICLE_SELECT_MENU_STR,_vehicleMenu)


/* ----------------------------------------------------------------------------
    Bearings Menu
---------------------------------------------------------------------------- */
_bearingsMenu = BEARING_MENU;

SAVE_AND_PUSH(BEARING_MENU_STR,_bearingsMenu)


/* ----------------------------------------------------------------------------
    flyInHeight Menu
---------------------------------------------------------------------------- */
private _flyInHeights = [_supportConfig >> "flyinHeights"] call BIS_fnc_getCfgDataArray;
if (_flyInHeights isEqualTo []) then {
    _flyInHeights = missionNamespace getVariable ["KISKA_CBA_supp_flyInHeights_arr",[]];

    if (_flyInHeights isEqualTo []) then {
        _flyInHeights = [50];
    };
};

private _flyInHeightMenu = [
    ["Altitude",false]
];
{
    _flyInHeightMenu pushBackUnique DISTANCE_LINE(_x,0);
} forEach _flyInHeights;
SAVE_AND_PUSH(FLYIN_HEIGHT_MENU_STR,_flyInHeightMenu)




/* ----------------------------------------------------------------------------
    Create Menu Path
---------------------------------------------------------------------------- */
_thisArgs pushBack _menuVariables;

[
    _menuPathArray,
    [_thisArgs, {
        params ["_vehicleClass","_approachBearing","_flyinHeight"];

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
        private _dropPosition = _commMenuArgs select 1;

        [
            _dropPosition,
            _vehicleClass,
            [ARSENAL_CRATE_TYPE],
            true,
            true,
            _flyinHeight,
            _approachBearing,
            FLYIN_RADIUS,
            ARSENAL_LIFETIME,
            side (_commMenuArgs select 0)
        ] call KISKA_fnc_supplyDrop_aircraft;

        [SUPPORT_TYPE_ARSENAL_DROP] call KISKA_fnc_supportNotification;

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
] spawn KISKA_fnc_commMenu_openTree;


nil
