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


nil
