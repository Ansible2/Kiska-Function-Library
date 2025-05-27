/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getPosRelativeASL

Description:
    Returns a position relative to another. Same as `getPos` alternative syntax
     but the returned position is in ASL format.

Parameters:
    0: _origin <OBJECT or Position> - The center position to find a relative position to.
    1: _distance <NUMBER> Default: `0` - The distance away from the `_origin` 
        to get the position.
    2: _bearing <NUMBER> Default: `0` - The direction relative to the `_origin` 
        to find the new position.
    3: _aglOffset <NUMBER> Default: `0` - An offset to add to the Z-axis above 
        ground level of the found position.

Returns:
    PositionASL[] - the new position

Examples:
    (begin example)
        private _positon = [
            player,
            100,
            180
        ] call KISKA_fnc_getPosRelativeASL;
    (end)

    (begin example)
        private _position = [
            player,
            100,
            180,
            10 // 10 meters above whatever AGL surface is at the 
        ] call KISKA_fnc_getPosRelativeASL;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getPosRelativeASL";

params [
    ["_origin",[],[objNull,[]],[2,3]],
    ["_distance",0,[123]],
    ["_bearing",0,[123]],
    ["_aglOffset",0,[123]]
];

private _relativePosition = _origin getPos [_distance,_bearing];
AGLToASL (_relativePosition vectorAdd [0,0,_aglOffset])
