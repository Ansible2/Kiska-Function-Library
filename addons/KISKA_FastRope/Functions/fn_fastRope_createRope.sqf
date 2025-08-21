/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_createRope

Description:
    Creates the rope segments of what appears to be a single rope for a fast rope.

    Also assigns eventhandlers for ropes breaking and adds references to the
     `_ropeInfoMap` under `"_ropeTop"` and `"_ropeBottom"` keys.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from.
    1: _ropeInfoMap <HASMAP> - The info map for the specific rope that is being created.
    2: _bottomLength <NUMBER> - Default: `1` - The length of the bottom segment of
        the rope which is effectively the rope itself for most purposes.

Returns:
    <OBJECT[]> - The top and bottom rope segments.

Examples:
    (begin example)
        private _newRopeSegments = [
            _vehicle,
            _ropeInfoMap,
            18                    
        ] call KISKA_fnc_fastRope_createRope;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_createRope";

params [
    "_vehicle",
    "_ropeInfoMap",
    ["_bottomLength",1,[123]]
];

// TODO: why is there a ropeTop and a ropeBottom and why do we need
// dummy objects? It seems like all you need is ropeBottom
private _unitAttachmentDummy = _ropeInfoMap get "_unitAttachmentDummy";
private _ropeTop = ropeCreate [_unitAttachmentDummy, [0, 0, 0], _hook, [0, 0, 0], 0.5];
_ropeInfoMap set ["_ropeTop",_ropeTop];
private _ropeBottom = ropeCreate [_unitAttachmentDummy, [0, 0, 0], _bottomLength];
_ropeInfoMap set ["_ropeBottom",_ropeBottom];

[
    _ropeTop,
    "RopeBreak",
    {
        _thisArgs params ["_ropeInfoMap"];
        _ropeInfoMap set ["_isBroken",true];
        [_ropeInfoMap] call KISKA_fnc_fastRope_ropeAttachedUnit;
    },
    [_ropeInfoMap]
] call CBA_fnc_addBISEventHandler;

[
    _ropeBottom,
    "RopeBreak",
    {
        _thisArgs params ["_ropeInfoMap"];
        _ropeInfoMap set ["_isBroken",true];
    },
    [_ropeInfoMap]
] call CBA_fnc_addBISEventHandler;


[_ropeTop,_ropeBottom]
