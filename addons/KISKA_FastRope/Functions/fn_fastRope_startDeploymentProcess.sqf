/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_startDeploymentProcess

Description:
    Begins the deployment process by waiting until the vehicle is allowed to deploy
     ropes (`KISKA_fnc_fastRope_canDeployRopes`) and then deploys those ropes 
     and initiates `KISKA_fnc_fastRope_dropUnits`.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from.
    1: _unitsToDeployIsCode <BOOL> - Whether or not the `_unitsToDeploy` parameter
        should be interpretted as code with `KISKA_fnc_callBack`.
    2: _unitsToDeploy <STRING | CODE | ARRAY | OBJECT[]> - Which units to deploy 
        or code that will return an OBJECT[] of units to deploy. See `KISKA_fnc_callBack`.
    3: _ropeOrigins <(STRING | PositionRelative[])[]> - An array of relative 
        (to the FRIES system or vehicle if no FRIES system is used) attachment points 
        for the ropes and/or memory points to `attachTo` the ropes to the vehicle.
    4: _hoverHeight <NUMBER> - The height the helicopter should hover above the 
        drop position while units are fastroping.

Returns:
    NOTHING

Examples:
    (begin example)
        SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_startDeploymentProcess";

[
    {
        params ["_vehicle"];
        
        !(alive _vehicle) OR 
        { [_vehicle] call KISKA_fnc_fastRope_canDeployRopes }
    },
    {
        params [
            ["_vehicle",objNull,[objNull]],
            ["_unitsToDeployIsCode",false,[true]],
            ["_unitsToDeploy",[],[[],{},""]],
            ["_ropeOrigins",[],[[]]],
            ["_hoverHeight",5,[123]]
        ];


        if !(alive _vehicle) exitWith {};
        
        private _ropes = [_vehicle,_ropeOrigins,_hoverHeight] call KISKA_fnc_fastRope_deployRopes;
        [
            {
                private _indexOfRopeNotUnwound = _this findIf { !(ropeUnwound _x) };
                _indexOfRopeNotUnwound isEqualTo -1 // all ropes unwound
            },
            [[_vehicle,_unitsToDeployIsCode,_unitsToDeploy], {
                _thisArgs params ["_vehicle","_unitsToDeployIsCode","_unitsToDeploy"];

                if (_unitsToDeployIsCode) then {
                    _unitsToDeploy = [[_vehicle],_unitsToDeploy] call KISKA_fnc_callBack;
                };
                
                [_vehicle,_unitsToDeploy] call KISKA_fnc_fastRope_dropUnits;
            }],
            0.25,
            _ropes
        ] call KISKA_fnc_waitUntil;
    },
    0.25,
    _this
] call KISKA_fnc_waitUntil;


nil
