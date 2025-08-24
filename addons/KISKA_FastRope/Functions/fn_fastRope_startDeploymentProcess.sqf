/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_startDeploymentProcess

Description:
    Begins the deployment process by waiting until the vehicle is allowed to deploy
     ropes and then deploys those ropes and initiates `KISKA_fnc_fastRope_dropUnits`.

Parameters:
    0: _fastRopeInfoMap <HASHMAP> - The hashmap that contains various pieces
        of information pertaining to the given fastrope instance.

Returns:
    NOTHING

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_startDeploymentProcess";

params ["_fastRopeInfoMap"];

[
    {
        !(alive (_this getOrDefaultCall ["_vehicle",{objNull}])) OR 
        { _this getOrDefaultCall ["_canDeployRopes",{true}] }
    },
    {
        private _vehicle = _this getOrDefaultCall ["_vehicle",{objNull}];
        if !(alive _vehicle) exitWith {};
        
        _this call KISKA_fnc_fastRope_deployRopes;
        [
            {
                // TODO: what if vehicle dies while deploying ropes
                private _ropeInfoMaps = _this get "_ropeInfoMaps";
                private _indexOfRopeNotUnwound = _ropeInfoMaps findIf { 
                    !(ropeUnwound (_x get "_ropeBottom"))
                };
                _indexOfRopeNotUnwound isEqualTo -1 // all ropes unwound
            },
            {
                if (_this getOrDefaultCall ["_unitsToDeployIsCode",{false}]) then {
                    private _unitsToDeploy = [
                        [_this getOrDefaultCall ["_vehicle",{objNull}]],
                        _this getOrDefaultCall ["_unitsToDeploy",{{}}]
                    ] call KISKA_fnc_callBack;
                    _this set ["_unitsToDeploy",_unitsToDeploy];
                };
                
                _this call KISKA_fnc_fastRope_dropUnits;
            },
            0.25,
            _this
        ] call KISKA_fnc_waitUntil;
    },
    0.25,
    _fastRopeInfoMap
] call KISKA_fnc_waitUntil;


nil
