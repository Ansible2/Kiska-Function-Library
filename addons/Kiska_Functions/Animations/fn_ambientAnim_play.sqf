scriptName "KISKA_fnc_ambientAnim_play";

params ["_unit","_previousAnim"];

if !(alive _unit) exitWith {
    [_unit] call KISKA_fnc_ambientAnim_terminate;
};

private _ambientAnimInfoMap = _unit getVariable ["KISKA_ambientAnimMap",[]];

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


nil
