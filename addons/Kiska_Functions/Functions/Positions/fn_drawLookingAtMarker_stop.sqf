/* ----------------------------------------------------------------------------
Function: KISKA_fnc_drawLookingAtMarker_stop

Description:
    Stops a marker being drawn that was started with `KISKA_fnc_drawLookingAtMarker_start`.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_drawLookingAtMarker_start;
        // some time later
        call KISKA_fnc_drawLookingAtMarker_stop;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_drawLookingAtMarker_stop";

private _eventId = localNamespace getVariable "KISKA_lookingAtMarker_eventId";
if !(isNil "_eventId") then {
    removeMissionEventHandler ["Draw3D",_eventId];
};

private _marker = localNamespace getVariable ["KISKA_lookingAtMarker_marker",objNull];
if !(isNull _marker) then {
    deleteVehicle _marker;
};


nil
