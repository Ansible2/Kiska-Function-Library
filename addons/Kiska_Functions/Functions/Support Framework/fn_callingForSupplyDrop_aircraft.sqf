#include "..\..\Headers\Support Framework\Command Menu Macros.hpp"
#include "..\..\Headers\Support Framework\Support Type IDs.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_callingForSupplyDrop_aircraft

Description:
    Used as a means of expanding on the "expression" property of the CfgCommunicationMenu.

    This is essentially just another level of abstraction to be able to more easily reuse
     code between similar supports and make things easier to read instead of fitting it all
     in the config.

Parameters:
    0: _supportClass <STRING> - The class as defined in the CfgCommunicationMenu
    1: _commMenuArgs <ARRAY> - The arguements passed by the CfgCommunicationMenu entry
        
        - 0. _caller <OBJECT> - The player calling for support
        - 1. _targetPosition <ARRAY> - The position (AGLS) at which the call is being made
            (where the player is looking or if in the map, the position where their cursor is)
        - 2. _target <OBJECT> - The cursorTarget object of the player
        - 3. _is3d <BOOL> - False if in map, true if not
        - 4. _commMenuId <NUMBER> - The ID number of the Comm Menu added by BIS_fnc_addCommMenuItem
        - 5. _supportType <NUMBER> - The Support Type ID

    2: _count <NUMBER> - Used for keeping track of how many of a count a support has left (such as rounds)

Returns:
    NOTHING

Examples:
    (begin example)
        [] call KISKA_fnc_callingForSupplyDrop_aircraft;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_callingForSupplyDrop_aircraft";

#define FLYIN_RADIUS 2000
#define ARSENAL_LIFETIME -1

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


private _menuPathArray = [];
private _menuVariables = []; // keeps track of global variable names to set to nil when done

// get use count from config if -1
private _args = _this; // just for readability
private _useCountConfig = _supportConfig >> "useCount";
if (_useCount < 0 AND (isNumber _useCountConfig)) then {
    _useCount = getNumber _useCountConfig;
    _args set [2,_useCount];
};

/* ----------------------------------------------------------------------------
    Vehicle Select Menu
---------------------------------------------------------------------------- */
private _vehicles = [_supportConfig >> "vehicleTypes"] call BIS_fnc_getCfgDataArray;
if (_vehicles isEqualTo []) then {
    // caller side & _supportType id
    _vehicles = [side (_commMenuArgs select 0),_commMenuArgs select 5] call KISKA_fnc_getSupportVehicleClasses;
};

private _vehicleMenu = [_vehicles] call KISKA_fnc_createVehicleSelectMenu;
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
_flyInHeights apply {
    _flyInHeightMenu pushBackUnique DISTANCE_LINE(_x,0);
};

SAVE_AND_PUSH(FLYIN_HEIGHT_MENU_STR,_flyInHeightMenu)



/* ----------------------------------------------------------------------------
    Create Menu Path
---------------------------------------------------------------------------- */
_args pushBack _menuVariables;

_args pushBack ([_supportConfig >> "crateList"] call BIS_fnc_getCfgDataArray);
_args pushBack ([_supportConfig >> "deleteCargo"] call BIS_fnc_getCfgDataBool);
_args pushBack ([_supportConfig >> "addArsenals"] call BIS_fnc_getCfgDataBool);


[
    _menuPathArray,
    [_args, {
        params ["_vehicleClass","_approachBearing","_flyinHeight"];

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
        private _dropPosition = _commMenuArgs select 1;

        private _crateList = _thisArgs select 4;
        private _deleteCargo = _thisArgs select 5;
        private _addArsenals = _thisArgs select 6;

        [
            _dropPosition,
            _vehicleClass,
            _crateList,
            _deleteCargo,
            _addArsenals,
            _flyinHeight,
            _approachBearing,
            FLYIN_RADIUS,
            ARSENAL_LIFETIME,
            side (_commMenuArgs select 0)
        ] call KISKA_fnc_supplyDrop_aircraft;

        [SUPPORT_TYPE_SUPPLY_DROP_AIRCRAFT] call KISKA_fnc_supportNotification;

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
