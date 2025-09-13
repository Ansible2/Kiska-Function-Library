/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_randPos

Description:
    Copied version of the CBA function `CBA_fnc_randPos`.

    A function used to randomize a position around a given center.

Parameters:
    0: _position <MARKER, OBJECT, LOCATION, GROUP, TASK or POSITION> - The area
        to find a position within.
    1: _radius <NUMBER> - Random radius.
    2: _direction <NUMBER> Default: `0` - Randomization direction.
    2: _angle <NUMBER> Default: `360` - the angle of the circular arc in which the random position will end up.

Returns:
    <PostionAGL[]> - The random position.

Example:
    (begin example)
        private _position = [position, radius] call KISKA_fnc_CBA_randPos
    (end)

Author(s):
    Rommel, commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_randPos";

params [
    ["_entity", objNull, [objNull, grpNull, "", locationNull, taskNull, []]],
    ["_radius", 0, [0]],
    ["_direction", 0, [0]],
    ["_angle", 360, [0]]
];

private _position = _entity call KISKA_fnc_CBA_getPos;
private _doResize = _position isEqualTypeArray [0,0];

_position = _position getPos [_radius * sqrt random 1, _direction - 0.5*_angle + random _angle];

if (_doResize) then {
    _position resize 2;
};

_position
