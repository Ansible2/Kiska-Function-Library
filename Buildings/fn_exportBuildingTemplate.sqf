params [
    ["_building",objNull,[objNull]],
    ["_objectCaptureRadius",0,[1]],
    ["_copyToClipboard",false,[true]]
];

if (_objectCaptureRadius <= 0) then {
    _objectCaptureRadius = ((0 boundingBoxReal _building) select 2);
};

private _terrainObjects = nearestTerrainObjects [_building,["object"],_objectCaptureRadius];

//systemChat str _terrainObjects;

private _capturedObjects = (_building nearObjects _objectCaptureRadius) select {
    !(_x in _terrainObjects) AND 
    {!(_x isEqualTo _building)} AND
    {(_x isKindOf "static") OR {_x isKindOf "staticWeapon"} OR {_x isKindOf "thing"}}
};

//systemChat str _capturedObjects;

private _offsetDump = [_capturedObjects,_building] call KISKA_fnc_getObjectOffsets;
if (_copyToClipboard) then {
    copyToClipboard str _offsetDump;
};

_offsetDump