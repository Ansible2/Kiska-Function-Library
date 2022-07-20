/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_stop

Description:
    Stops a unit's use of KISKA_fnc_ambientAnim and returns them to the state they
     were in before it ran.

Parameters:
	0: _unit <OBJECT> - The unit who is running KISKA ambient anims

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
    ["_unit",objNull,[objNull]]
];

if (isNull _unit) exitWith {
    ["_unit is null",false] call KISKA_fnc_log;
    nil
};

private _ambientAnimInfoMap = _unit getVariable ["KISKA_ambientAnimMap",[]];
if (_ambientAnimInfoMap isEqualTo []) exitWith {
    [[_unit," does not have a KISKA_ambientAnimMap in their namespace!"],true] call KISKA_fnc_log;
    nil
};


["ANIM","AUTOTARGET","FSM","MOVE","TARGET"] apply {
    _unit enableAI _x;
};


detach _unit;
_unit switchMove "";

private _attachToLogic = _ambientAnimInfoMap getOrDefault ["_attachToLogic",objNull];
if !(isNull _attachToLogic) then {
    deleteVehicle _attachToLogic;
};

private _unitLoadoutBeforeAnimation = _ambientAnimInfoMap getOrDefault ["_unitLoadout",[]];
if (_unitLoadoutBeforeAnimation isNotEqualTo []) then {
    _unit setUnitLoadout _unitLoadoutBeforeAnimation;
};


private _animDoneEventHandlerId = _ambientAnimInfoMap get "_animDoneEventHandlerId";
_unit removeEventHandler ["AnimDone", _animDoneEventHandlerId];

private _unitKilledEventHandlerId = _ambientAnimInfoMap get "_unitKilledEventHandlerId";
_unit removeEventHandler ["KILLED", _unitKilledEventHandlerId];

private _behaviourEventId = _ambientAnimInfoMap getOrDefault ["_behaviourEventId",-1];
if (_behaviourEventId >= 0) then {
    [
        _unit,
        (configFile >> "KISKA_eventHandlers" >> "Behaviour"),
        _behaviourEventId
    ] call KISKA_fnc_eventHandler_remove;
};


private _snapToObject = _ambientAnimInfoMap get ["_snapToObject",objNull];
_snapToObject setVariable ["KISKA_ambientAnim_objectUsedBy",nil];
_unit enableCollisionWith _snapToObject;


_unit setVariable ["KISKA_ambientAnimMap",nil];

nil
