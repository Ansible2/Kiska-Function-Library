/* ----------------------------------------------------------------------------
Function: KISKA_fnc_drawLookingAtMarker_start

Description:
    Draws a 3D marker to indicate where the player is currently looking.

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
scriptName "KISKA_fnc_drawLookingAtMarker_start";

#define MARKER_CLASS "Sign_Sphere200cm_F"

private _eventId = localNamespace getVariable "KISKA_lookingAtMarker_eventId";
if !(isNil "_eventId") then {
    call KISKA_fnc_drawLookingAtMarker_stop;
    nil
};

private _marker = MARKER_CLASS createVehicleLocal [0,0,0];
private _markerColor = missionNamespace getVariable ["KISKA_CBA_lookingAtMarker_color",[1,0.6,1,1]];
_markerColor params ["_r","_g","_b","_alpha"];
_marker setObjectTexture [0,format["#(rgb,8,8,3)color(%1,%2,%3,%4)",_r,_g,_b,_alpha]];
localNamespace setVariable ["KISKA_lookingAtMarker_marker",_marker];

_eventId = addMissionEventHandler ["Draw3D", {
    if (!(alive player) OR ((incapacitatedState player) == "INCAPACITATED")) then {
        call KISKA_fnc_drawLookingAtMarker_stop;
    } else {
        _thisArgs params ["_marker"];
        _marker setPosASL (call KISKA_fnc_getPositionPlayerLookingAt);
    };
},[_marker]]; 
localNamespace setVariable ["KISKA_lookingAtMarker_eventId",_eventId];


nil