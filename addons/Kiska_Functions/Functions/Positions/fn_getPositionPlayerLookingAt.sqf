/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getPositionPlayerLookingAt

Description:
    Gets the ASL position that the player is currently looking at. Moves with a player's
    head position and collides with objects in the path of their vision. Works
    up to a maximum of 5000m given the limitations of `lineIntersectsSurfaces`, 
    however, will use the player's `viewDistance` if it is less than that.

Parameters:
    NONE

Returns:
    <PostionASL[]> - The position the player is currently looking

Examples:
    (begin example)
        private _position = call KISKA_fnc_getPositionPlayerLookingAt;
    (end)

Authors:
    Commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getPositionPlayerLookingAt";

#define MAX_LINE_INTERSECT_DISTANCE 5000

private _distance = viewDistance min MAX_LINE_INTERSECT_DISTANCE;
private _origin = AGLToASL (positionCameraToWorld [0, 0, 0]);
private _target = AGLToASL (positionCameraToWorld [0, 0, _distance]);

private _default = _origin vectorAdd (_origin vectorFromTo (_target vectorMultiply _distance));
private _intersects = lineIntersectsSurfaces [_origin, _target, cameraOn];

(_intersects param [0, [_default]]) select 0