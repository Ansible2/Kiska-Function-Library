// TODO: header comment

[
    {
        params ["_vehicle"];
        
        !(alive _vehicle) OR 
        { [_vehicle] call KISKA_fnc_fastRope_canDeployRopes }
    },
    {
        params [
            "_vehicle",
            "_unitsToDeployIsCode",
            "_unitsToDeploy",
            "_ropeOrigins",
            "_hoverHeight"
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
                
                private _ropes = _this;
                [_vehicle,_unitsToDeploy] call KISKA_fnc_fastRope_dropUnits;
            }],
            0.25,
            _ropes
        ] call KISKA_fnc_waitUntil;
    },
    0.25,
    _this
] call KISKA_fnc_waitUntil;