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

if (canSuspend) exitWith {
    [
        KISKA_fnc_ambientAnim_play,
        _this
    ] call CBA_fnc_directCall;
};

params [
    ["_unit",objNull,[objNull]],
    ["_previousAnim","",[""]]
];

if !(alive _unit) exitWith {
    [_unit] call KISKA_fnc_ambientAnim_stop;
};

private _ambientAnimInfoMap = _unit getVariable "KISKA_ambientAnimMap";
if (isNil "_ambientAnimInfoMap") exitWith {
    ["Error: _ambientAnimInfoMap not found",true] call KISKA_fnc_log;
    nil
};

private _animationSetInfo = _ambientAnimInfoMap get "_animationSetInfo";
private _nearUnits = _unit nearEntities ["man", 5];
_nearUnits deleteAt (_nearUnits find _unit);

private _takenAnimations = _nearUnits apply {toLowerANSI (animationState _x)};
_takenAnimations pushBack (toLowerANSI _previousAnim);
private _setAnimations = _animationSetInfo getOrDefault ["animations",[]];
private _animationsToUse = _setAnimations - _takenAnimations;
if (_animationsToUse isEqualTo []) then {
    _animationsToUse = _setAnimations;
};
private _animation = [_animationsToUse,""] call KISKA_fnc_selectRandom;

if (_animationSetInfo getOrDefault ["canInterpolate",false]) then {
    private _jipId = _ambientAnimInfoMap get "KISKA_ambientAnim_JIPId_playMoveNow";
    [_unit,_animation] remoteExec ["playMoveNow",0,_jipId];

} else {
    // best practice to make sure an animation actually plays is to use both switchMove and playMoveNow
    private _jipId = _ambientAnimInfoMap get "KISKA_ambientAnim_JIPId_switchMove";
    [_unit,_animation] remoteExec ["switchMove",0,_jipId];
    
    _jipId = _ambientAnimInfoMap get "KISKA_ambientAnim_JIPId_playMoveNow";
    [_unit,_animation] remoteExec ["playMoveNow",0,_jipId];

};
/* [["Play called for ", _unit," _previousAnim: ", _previousAnim, " Current Anim: ",_animation]] call KISKA_fnc_log; */

nil
