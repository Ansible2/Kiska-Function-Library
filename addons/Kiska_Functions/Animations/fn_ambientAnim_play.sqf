/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_play

Description:
    Starts animations for KISKA_fnc_ambientAnim.

    This should not be directly called and is instead handled in events defined
     in KISKA_fnc_ambientAnim.

Parameters:
	0: _unit <OBJECT> - The unit to animate
	1: _previousAnim <STRING> - The previous animation the unit played

Returns:
    NOTHING

Examples:
    (begin example)
        (SHOULD NOT BE DIRECTLY CALLED)
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_play";

params [
    ["_unit",objNull,[objNull]],
    ["_previousAnim","",[""]]
];


if !(alive _unit) exitWith {
    [_unit] call KISKA_fnc_ambientAnim_stop;
};

private _ambientAnimInfoMap = _unit getVariable ["KISKA_ambientAnimMap",[]];
if (_ambientAnimInfoMap isEqualTo []) exitWith {
    ["Error: _ambientAnimInfoMap not found",true] call KISKA_fnc_log;
    nil
};


private _animationSetInfo = _ambientAnimInfoMap get "_animationSetInfo";
private _nearUnits = _unit nearEntities ["man", 5];

private _takenAnimations = _nearUnits apply {toLowerANSI (animationState _x)};
_takenAnimations pushBack (toLowerANSI _previousAnim);
private _setAnimations = _animationSetInfo getOrDefault ["animations",[]];
private _animationsToUse = _setAnimations - _takenAnimations;
if (_animationsToUse isEqualTo []) then {
    _animationsToUse = _setAnimations;
};
private _animation = [_animationsToUse,""] call KISKA_fnc_selectRandom;

if (_animationSetInfo getOrDefault ["canInterpolate",false]) then {
    _unit playMoveNow _animation;
} else {
    _unit switchMove _animation;
};
[["Play called for ", _unit," _previousAnim: ", _previousAnim, " Current Anim: ",_animation]] call KISKA_fnc_log;

nil
