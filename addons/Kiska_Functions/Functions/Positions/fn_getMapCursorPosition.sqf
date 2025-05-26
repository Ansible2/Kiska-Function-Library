/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getMapCursorPosition

Description:
    Gets the ASL position that corresponds to the player's map cursor position.

Parameters:
    NONE

Returns:
    <PostionASL[] | NIL> - The position that the player's cursor is on the map.
        Will be `nil` in the event that the map is not open.

Examples:
    (begin example)
        private _position = call KISKA_fnc_getMapCursorPosition;
    (end)

Authors:
    Commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getMapCursorPosition";

if (!visibleMap) exitWith { nil };

private _display = findDisplay 12;
if (isNull _display) exitWith { nil };

private _ctrlMap = _display displayCtrl 51;
if (isNull _ctrlMap) exitWith { nil };

getMousePosition params ["_mouseX", "_mouseY"];
private _position = _ctrlMap ctrlMapScreenToWorld [_mouseX, _mouseY];
_position pushBack (abs (getTerrainHeight _position));


_position
