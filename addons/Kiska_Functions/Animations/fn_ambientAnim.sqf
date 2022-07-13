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
//

params [
    ["_units",objNull,[[],objNull]],
    ["_animationMap",configNull,[createHashMap,configNull]]
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
        unarmed: true
    }
}
*/

/* ----------------------------------------------------------------------------

    Apply Animations

---------------------------------------------------------------------------- */
_units apply {

};


nil
