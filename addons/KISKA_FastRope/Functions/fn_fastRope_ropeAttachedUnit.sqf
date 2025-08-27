/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_ropeAttachedUnit

Description:
    Attaches or detachs a given unit from the given rope.

    Also sets the rope info as being occupied or unoccupied.

Parameters:
    0: _ropeInfoMap <HASHMAP> - The info map of the rope to attach or detach a unit from.
    1: _setAttachedUnit <OBJECT> - Default: `nil` - A `nil` value will detach the
        currently attached unit from the rope. If an object, that unit will be
        attached to the rope.

Returns:
    NOTHING

Examples:
    (begin example)
        // attach player to the rope
        [MY_ROPE_INFO, player] call KISKA_fnc_fastRope_ropeAttachedUnit;
    (end)

    (begin example)
        // detach unit from rope
        [MY_ROPE_INFO] call KISKA_fnc_fastRope_ropeAttachedUnit;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_ropeAttachedUnit";

#define ATTACH_TO_DUMMY_COORDS [0, 0, -1.45]
#define ROPE_UNWIND_SPEED 6

private _DEFAULT_MAP = createHashMap;
params [
    ["_ropeInfoMap",_DEFAULT_MAP,[_DEFAULT_MAP]],
    ["_setAttachedUnit",nil,[objNull]]
];

private _ropeUnitAttachmentDummy = _ropeInfoMap getOrDefaultCall ["_unitAttachmentDummy", {objNull}];
private _detachUnit = isNil "_setAttachedUnit";
if (_detachUnit) exitWith {
    private _attachedUnit = _ropeInfoMap getOrDefaultCall ["_attachedUnit", {objNull}];
    private _currentPosition = getPosVisual _attachedUnit;
    detach _attachedUnit;
    _ropeInfoMap set ["_attachedUnit",nil];
    _ropeInfoMap set ["_isOccupied",false];

    if !(isNull _attachedUnit) then {
        // TODO: fix
        // if units are detached while on the rope, they
        // will not be sent to the rope origin instead of where they were
        if (
            ((_currentPosition select 2) > 0.5) AND 
            {!(isTouchingGround _attachedUnit)}
        ) then {
            _attachedUnit setPosASL (AGLToASL _currentPosition);
        };
        _attachedUnit setVariable ["KISKA_fastRope_attachedToRope",nil];

        private _hook = _ropeInfoMap getOrDefaultCall ["_hook", {objNull}];
        [
            "EndAttachmentDescentLoop",
            [_ropeUnitAttachmentDummy,getPosASLVisual _hook]
        ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];

        [
            "EndFastRopeAnimation",
            [_attachedUnit,_reachedGround]
        ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_attachedUnit];
    };

    nil
};


[
    "UpdateAttachmentDummyMass",
    [_ropeUnitAttachmentDummy,getPosASLVisual _hook]
] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];

[
    [_ropeInfoMap get "_ropeTop", _ropeInfoMap get "_ropeLength"],
    [_ropeInfoMap get "_ropeBottom", 0.5]
] apply {
    _x params ["_rope","_unwindLength"];
    [ [_rope, ROPE_UNWIND_SPEED, _unwindLength] ] remoteExec ["ropeUnwind",_rope];
};

[
    _ropeUnitAttachmentDummy,
    _setAttachedUnit
] remoteExec ["disableCollisionWith",[_ropeUnitAttachmentDummy,_setAttachedUnit]];

_ropeInfoMap set ["_attachedUnit",_setAttachedUnit];
_ropeInfoMap set ["_isOccupied",true];
_setAttachedUnit attachTo [_ropeInfoMap get "_unitAttachmentDummy", ATTACH_TO_DUMMY_COORDS];

[
    "StartFastRopeAnimation",
    _setAttachedUnit
] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_setAttachedUnit];

[
    "StartAttachmentDescentLoop",
    _ropeUnitAttachmentDummy
] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];

_setAttachedUnit setVariable ["KISKA_fastRope_attachedToRope",true];


_setAttachedUnit
