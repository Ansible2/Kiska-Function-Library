params [
    "_vehicle",
    "_unitAttachmentDummy",
    "_hook"
];

// TODO: why is there a ropeTop and a ropeBottom and why do we need
// dummy objects? It seems like all you need is ropeBottom
private _ropeTop = ropeCreate [_unitAttachmentDummy, [0, 0, 0], _hook, [0, 0, 0], 0.5];
private _ropeBottom = ropeCreate [_unitAttachmentDummy, [0, 0, 0], 1];

[
    _ropeTop,
    "RopeBreak",
    {
        params ["_rope"];
        _thisArgs params ["_vehicle", "_unitAttachmentDummy"];
        private _brokenRopeInfo = [_rope,_vehicle] call KISKA_fnc_fastRopeEvent_onRopeBreak;

        if !(isNil "_brokenRopeInfo") then {
            // TODO: can probably just save a variable to the _unitAttachmentDummy namespace
            private _attachedObjects = attachedObjects _unitAttachmentDummy;
            private _indexOfUnitOnRope = _attachedObjects findIf {
                _x isKindOf "CAManBase"
            };
            detach (_attachedObjects select _indexOfUnitOnRope);
        };
    },
    [_vehicle,_unitAttachmentDummy]
] call CBA_fnc_addBISEventHandler;

[
    _ropeBottom,
    "RopeBreak",
    {
        params ["_rope"];
        _thisArgs params ["_vehicle"];
        [_rope,_vehicle] call KISKA_fnc_fastRopeEvent_onRopeBreak;
    },
    [_vehicle]
] call CBA_fnc_addBISEventHandler;


[_ropeTop,_ropeBottom]
