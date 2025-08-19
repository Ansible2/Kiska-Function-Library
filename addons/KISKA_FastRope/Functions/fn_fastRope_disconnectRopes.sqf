/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_disconnectRopes

Description:
    Disconnects ropes and deletes any helper objects used for the ropes.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from.

Returns:
    NOTHING

Examples:
    (begin example)
        [_vehicle] call KISKA_fnc_fastRope_disconnectRopes;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_disconnectRopes";

#define FALLING_ROPE_MASS 1000
#define TIME_UNTIL_ROPE_DELETION 20

params ["_vehicle"];

private _ropeInfoMaps = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfoMaps",[]];
_ropeInfoMaps apply {
    // Knock unit off rope if occupied
    private _unitAttachmentDummy = _x getOrDefaultCall ["_unitAttachmentDummy",objNull];
    if (
        (_x getOrDefaultCall ["_isOccupied",{false}]) OR
        {
            !(isNull ([_unitAttachmentDummy] call KISKA_fnc_fastRope_ropeAttachedUnit))
        }
    ) then {
        detach ([_unitAttachmentDummy] call KISKA_fnc_fastRope_ropeAttachedUnit);
    };

    // Delete hook and top so rope falls
    deleteVehicle [
        _x getOrDefaultCall ["_hook",{objNull}],
        _x getOrDefaultCall ["_ropeTop",{objNull}]
    ];
                    
    // Give rope some extra mass to fall quick
    [_unitAttachmentDummy, FALLING_ROPE_MASS] remoteExec ["setMass",_unitAttachmentDummy];

    [
        {deleteVehicle _this}, 
        [
            _x getOrDefaultCall ["_ropeBottom",{objNull}], 
            _unitAttachmentDummy
        ], 
        TIME_UNTIL_ROPE_DELETION
    ] call CBA_fnc_waitAndExecute;
};
_vehicle setVariable ["KISKA_fastRope_deployedRopeInfoMaps",nil];
_vehicle setVariable ["KISKA_fastRope_ropeLength", nil];


nil
