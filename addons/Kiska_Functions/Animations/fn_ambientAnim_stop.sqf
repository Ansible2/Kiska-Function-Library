/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_stop

Description:
    Stops a unit's use of KISKA_fnc_ambientAnim and returns them to the state they
     were in before it ran.

Parameters:
    0: _unit <OBJECT> - The unit who is running KISKA ambient anims
    1: _triggeredByDeletion <BOOL> - If this stop was initiated by the delete Eventhandler

Returns:
    NOTHING

Examples:
    (begin example)
        [someUnit] call KISKA_fnc_ambientAnim_stop;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_stop";

params [
    ["_unit",objNull,[objNull]],
    ["_triggeredByDeletion",false,[true]]
];

if (isNull _unit) exitWith {
    ["_unit is null",false] call KISKA_fnc_log;
    nil
};

private _ambientAnimInfoMap = _unit getVariable "KISKA_ambientAnimMap";
if (isNil "_ambientAnimInfoMap") exitWith {
    if (!_triggeredByDeletion) then {
        [[_unit," does not have a KISKA_ambientAnimMap currently in their namespace!"],true] call KISKA_fnc_log;
    };

    nil
};

// remove JIP messages
remoteExec ["", _ambientAnimInfoMap get "KISKA_ambientAnim_JIPId_switchMove"];
remoteExec ["", _ambientAnimInfoMap get "KISKA_ambientAnim_JIPId_playMoveNow"];


detach _unit;
private _attachToLogic = _ambientAnimInfoMap getOrDefault ["_attachToLogic",objNull];
if !(isNull _attachToLogic) then {
    deleteVehicle _attachToLogic;
};

private _behaviourEventId = _ambientAnimInfoMap getOrDefault ["_behaviourEventId",-1];
if (_behaviourEventId >= 0) then {
    [
        _unit,
        (configFile >> "KISKA_eventHandlers" >> "Behaviour"),
        _behaviourEventId
    ] call KISKA_fnc_eventHandler_remove;
};

private _snapToObject = _ambientAnimInfoMap getOrDefault ["_snapToObject",objNull];
private _snapObjectIsNotNull = !(isNull _snapToObject);
if (_snapObjectIsNotNull) then {
    _snapToObject setVariable ["KISKA_ambientAnim_objectUsedBy",nil];
};


if (_triggeredByDeletion) exitWith {};
private _unitDeletedEventHandlerId = _ambientAnimInfoMap get "_unitDeletedEventHandlerId";
_unit removeEventHandler ["Deleted", _unitDeletedEventHandlerId];


if !(alive _unit) exitWith {};


["ANIM","AUTOTARGET","FSM","MOVE","TARGET"] apply {
    [_unit,_x] remoteExecCall ["enableAI",_unit];
};

private _animDoneEventHandlerId = _ambientAnimInfoMap get "_animDoneEventHandlerId";
_unit removeEventHandler ["AnimDone", _animDoneEventHandlerId];

private _unitKilledEventHandlerId = _ambientAnimInfoMap get "_unitKilledEventHandlerId";
_unit removeEventHandler ["KILLED", _unitKilledEventHandlerId];


_unit setVariable ["KISKA_ambientAnimMap",nil];


private _unitLoadoutBeforeAnimation = _ambientAnimInfoMap getOrDefault ["_unitLoadout",[]];
if (_unitLoadoutBeforeAnimation isNotEqualTo []) then {
    _unit setUnitLoadout _unitLoadoutBeforeAnimation;
};


if (_snapObjectIsNotNull) then {
    [_unit, _snapToObject] remoteExecCall ["enableCollisionWith", _unit];
    [_snapToObject,_unit] remoteExecCall ["enableCollisionWith", _snapToObject];
};


[_unit,""] remoteExecCall ["KISKA_fnc_resetMove"];


nil
