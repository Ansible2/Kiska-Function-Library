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

private _commMenuDetailsConfig = _supportConfig >> "KISKA_commMenuDetails";

/* ----------------------------------------------------------------------------
    Radius Menu
---------------------------------------------------------------------------- */
private _selectableRadiuses = getArray(_commMenuDetailsConfig >> "radiuses");
if (_selectableRadiuses isEqualTo []) then {
    _selectableRadiuses = missionNamespace getVariable ["KISKA_CBA_supp_radiuses_arr",[]];

    if (_selectableRadiuses isEqualTo []) then {
        _selectableRadiuses = [200];
    };
};
_selectableRadiuses sort true;

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
private _canSelectRounds = [_commMenuDetailsConfig >> "canSelectRounds",true,true] call KISKA_fnc_getConfigData;
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
private _draw3dMarker = [_commMenuDetailsConfig >> "draw3dMarker",true,true] call KISKA_fnc_getConfigData;
if (_draw3dMarker) then {
    call KISKA_fnc_drawLookingAtMarker_start;
};

[
    [
        ["Select Ammo", getArray(_commMenuDetailsConfig >> "ammoTypes")],
        ["Area Spread", _radiusMenuOptions],
        ["Number of Rounds", _roundsMenuOptions]
    ],
    [[_supportId], {
        params ["_ammoClass","_radiusOfFire","_numberOfRoundsToFire"];
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
