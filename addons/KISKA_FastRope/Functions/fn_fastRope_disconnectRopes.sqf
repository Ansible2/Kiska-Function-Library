/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_disconnectRopes

Description:
    Disconnects ropes and deletes any helper objects used for the ropes.

Parameters:
    0: _ropeInfoMaps <HASHMAP[]> - The rope info maps of the ropes deployed
        from the vehicle.

Returns:
    NOTHING

Examples:
    (begin example)
        _ropeInfoMaps call KISKA_fnc_fastRope_disconnectRopes;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_disconnectRopes";

#define FALLING_ROPE_MASS 1000
#define TIME_UNTIL_ROPE_DELETION 20

params ["_ropeInfoMaps"];

_ropeInfoMaps apply {
    if (_x getOrDefaultCall ["_isDisconnected",{false}]) then { continue };

    [_x] call KISKA_fnc_fastRope_ropeAttachedUnit;
    // Delete hook and top so rope falls
    deleteVehicle [
        _x getOrDefaultCall ["_hook",{objNull}],
        _x getOrDefaultCall ["_ropeTop",{objNull}]
    ];
                    
    // Give rope some extra mass to fall quick
    private _unitAttachmentDummy = _x getOrDefaultCall ["_unitAttachmentDummy",{objNull}];
    [_unitAttachmentDummy, FALLING_ROPE_MASS] remoteExec ["setMass",_unitAttachmentDummy];

    [
        {deleteVehicle _this}, 
        [
            _x getOrDefaultCall ["_ropeBottom",{objNull}], 
            _unitAttachmentDummy
        ], 
        TIME_UNTIL_ROPE_DELETION
    ] call CBA_fnc_waitAndExecute;
    
    _x set ["_isDisconnected",true];
};


nil
