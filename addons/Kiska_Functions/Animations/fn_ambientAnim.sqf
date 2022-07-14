// Works with agents
// Is able to take an animation map as a parameter
// Is able to convert a config into an animation map
// User can provide an array of desired animation sets to randomly (weighted too) select from
// User can define whther or not unit should exit animationwhile in combat
// user can define a function to activate when unit enters combat
// user can define a callback function that fires when the unit enters the animation
// user can manually terminate the animation
// attempts to not play the same animation twice within the same general area
// user can define levels of gear to remove from the unit

// handle remote units being passed

params [
    ["_units",objNull,[[],objNull]],
    ["_animationMap",configNull,[createHashMap,configNull]],
    ["_animSet","",["",[]]],
    ["_equipmentLevel","",["",[]]],
    ["_onAnimate",{},[{},[],""]]
];

/* ----------------------------------------------------------------------------

    Verify params

---------------------------------------------------------------------------- */
if (_units isEqualTo []) exitWith {
    ["Empty _units array passed!", true] call KISKA_fnc_log;
    nil
};

private _isObject = _units isEqualType objNull;
if (_isObject AND {isNull _units}) exitWith {
    ["Null unit passed", true] call KISKA_fnc_log;
    nil
};

if (_isObject) then {
    _units = [_units];
};

private _animationMapIsConfig = _animationMap isEqualType configNull;
if (_animationMapIsConfig AND {isNull _animationMap}) exitWith {
    ["_animationMap is null config!", true] call KISKA_fnc_log;
    nil
};

if (_animationMapIsConfig) then {
    _animationMap = [_animationMap] call KISKA_fnc_ambientAnim_createMapFromConfig;
};

/*
JSON rep of map
{
    someAnimSet: {
        animations: [
            "anim1",
            "anim2"
        ],
        allowedGear: [
            "full",
            "light",
            "medium"
        ],
        unarmed: true,
        forceHolster: true,
        interpolate: true // means animations will be played in a sequence
    }
}
*/

private _randomAnimSet = _animset isEqualType [];
private _randomEquipmentLevel = _equipmentLevel isEqualType [];

if (isNil "KISKA_ambientAnimUnitMap") then {
    missionNamespace setVariable ["KISKA_ambientAnimUnitMap",createHashMap];
};

/* ----------------------------------------------------------------------------

    Apply Animations

---------------------------------------------------------------------------- */
_units apply {
    private _unit = _x;
    private _unitInfoMap = createHashmap;

    /* --------------------------------------
        Get Animation Set Info
    -------------------------------------- */
    private _animSetSelection = _animset;
    if (_randomAnimSet) then {
        _animSetSelection = [_animSet,""] call KISKA_fnc_selectRandom;
    };
    private _animationSetInfo = _animationMap getOrDefault [_animSetSelection,[]];
    if (_animationSetInfo isEqualTo []) then {
        [["Empty animation set provided: ", _animSetSelection], true] call KISKA_fnc_log;
        continue;
    };

    /* --------------------------------------
        Handle Equipment
    -------------------------------------- */
    private _equipmentLevelSelection = _equipmentLevel;
    if (_randomEquipmentLevel) then {
        _equipmentLevelSelection = [_equipmentLevel,""] call KISKA_fnc_selectRandom;
    };

    private _unitLoadout = getUnitLoadout _unit;
    _unitInfoMap set ["loadout",_unitLoadout];

    private _makeUnitUnarmed = _animationSetInfo getOrDefault ["unarmed",false];
    if (_makeUnitUnarmed) then {
        removeAllWeapons _unit;
    };

    switch (_equipmentLevelSelection) do
    {
        case "NONE":
        {
            removeGoggles _unit;
            removeHeadgear _unit;
            removeVest _unit;
            removeAllWeapons _unit;

            _noBackpack = true;
            _noWeapon = true;
        };
        case "LIGHT":
        {
            removeGoggles _unit;
            removeHeadgear _unit;
            removeVest _unit;

            _noBackpack = true;
        };
        case "MEDIUM":
        {
            removeGoggles _unit;
            removeHeadgear _unit;
        };
        case "FULL":
        {
            removeGoggles _unit;
        };
        default
        {
        };
    };


    private _isAgent = isAgent (teamMember _unit);
    ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"] apply {
        _unit disableAI _x;
    };

    detach _unit;





    [
        missionNamespace getVariable "KISKA_ambientAnimUnitMap",
        _unit,
        _unitInfoMap
    ] call KISKA_fnc_hashmap_set;
};


nil
