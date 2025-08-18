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

private _DEFAULT_MAP = createHashMap;
params [
    ["_ropeInfoMap",_DEFAULT_MAP,[_DEFAULT_MAP]],
    ["_setAttachedUnit",nil,[objNull]]
];

if (isNil "_setAttachedUnit") exitWith {
    private _attachedUnit = _ropeInfoMap getOrDefaultCall ["_attachedUnit",{objNull}];
    detach _attachedUnit;
    _ropeInfoMap set ["_attachedUnit",nil];
    _ropeInfoMap set ["_isOccupied",false];
};

_ropeInfoMap set ["_attachedUnit",_setAttachedUnit];
_setAttachedUnit attachTo [_ropeInfoMap get "_unitAttachmentDummy", ATTACH_TO_DUMMY_COORDS];
_ropeInfoMap set ["_isOccupied",true];


nil
