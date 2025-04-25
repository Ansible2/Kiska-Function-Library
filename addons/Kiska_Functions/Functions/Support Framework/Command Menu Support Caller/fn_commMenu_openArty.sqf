/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openArty

Description:
   Opens a commanding menu that will allow the player to select the parameters
   of an artillery strike.

Parameters:
    0: _supportId <STRING> - The ID of the specific support.
    1: _supportConfig <CONFIG> - The support's config path.

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
    ["_supportConfig",configNull,[configNull]]
];


if (isNull _supportConfig) exitWith {
    ["null _supportConfig used!",true] call KISKA_fnc_log;
    nil
};

private _supportDetailsConfig = _supportConfig >> "KISKA_supportDetails";

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
