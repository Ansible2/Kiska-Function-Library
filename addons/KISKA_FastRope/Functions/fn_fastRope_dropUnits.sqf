// TODO: header comment
#define ROPE_IS_OCCUPIED_INDEX 5

params [
    ["_vehicle",objNull,[objNull]],
    ["_unitsToDeploy",[],[[]]]
];

if !(alive _vehicle) exitWith {};

(currentPilot _vehicle) disableAI "MOVE";

private _fn_dropUnitRecursive = {
    params ["_vehicle","_unoccupiedRopeInfo"];

    private _unit = _unitsToDeploy deleteAt 0;
    if ((alive _unit) AND {_unit in _vehicle}) then {
        unassignVehicle _unit;
        [_unit] allowGetIn false;

        // TODO: fastrope unit down rope
        // [_unit, _vehicle] call FUNC(fastRope);
    };

    private _ropes = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfo",[]];
    if (_unitsToDeploy isEqualTo []) exitWith {
        [
            {
                private _ropes = _this select 1;
                private _indexOfOccupiedRope = _ropes findIf {_x select ROPE_IS_OCCUPIED_INDEX};
                private _noRopesInOccupied = _indexOfOccupiedRope isEqualTo -1;
                _noRopesInOccupied
            },
            {
                params ["_vehicle"];
                // TODO:
                // cut ropes
                (currentPilot _vehicle) enableAI "MOVE";
                _vehicle setVariable ["KISKA_fastRope_unitsDroppedOff",true];
            },
            0.25,
            [_vehicle,_ropes]
        ] call KISKA_fnc_waitUntil;
    };

    [
        {
            private _ropes = _this select 1;
            private _indexOfUnoccupiedRope = _ropes findIf {!(_x select ROPE_IS_OCCUPIED_INDEX)};
            if (_indexOfUnoccupiedRope isEqualTo -1) exitWith { false };
            
            private _unoccupiedRopeInfo = _ropes select _indexOfUnoccupiedRope;
            _unoccupiedRopeInfo set [ROPE_IS_OCCUPIED_INDEX,true];
            private _vehicle = _this select 0;
            _vehicle setVariable ["KISKA_fastRope_unoccupiedRopeInfo",_unoccupiedRopeInfo];
            true
        },
        {
            params ["_vehicle","","_fn_dropUnitRecursive"];
            private _unoccupiedRopeInfo = _vehicle getVariable "KISKA_fastRope_unoccupiedRopeInfo";
            _vehicle setVariable ["KISKA_fastRope_unoccupiedRopeInfo",nil];
            [_vehicle,_unoccupiedRopeInfo] call _fn_dropUnitRecursive;
        },
        0.25,
        [_vehicle,_ropes,_fn_dropUnitRecursive]
    ] call KISKA_fnc_waitUntil;
};

private _ropes = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfo",[]];
[_vehicle, _ropes select 0] call _fn_dropUnitRecursive;


nil
