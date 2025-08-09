// TODO: header comment
#define ROPE_IS_OCCUPIED_INDEX 5
#define ROPE_IS_BROKEN_INDEX 6
#define ROPE_HOOK_INDEX 1

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
        _unoccupiedRopeInfo set [ROPE_IS_OCCUPIED_INDEX,true];
        unassignVehicle _unit;
        [_unit] allowGetIn false;
        [
            {
                params ["_args","_pfhHandle"];
                private _unit = _this select 0;
                // wait for unit to be outside of vehicle
                if (isNull (objectParent _unit)) exitWith {};
                
                private _ropeInfo = _this select 1;
                private _hook = _ropeInfo select ROPE_HOOK_INDEX;
                // TODO: check if rope cut
                // Prevent teleport if hook has been deleted due to rope cut
                if (isNull _hook) exitWith {
                    detach _unit; // Does not matter if unit was not attached yet
                    [_pfhHandle] call CBA_fnc_removePerFrameHandler;
                };

                private _rope = 
            }, 
            0, 
            [
                _unit,
                _unoccupiedRopeInfo
            ]
        ] call CBA_fnc_addPerFrameHandler;

        moveOut _unit;
        
        // [LINKFUNC(fastRopeLocalPFH), 0, [_unit, _vehicle, _usableRope, _usableRopeIndex, diag_tickTime]] call CBA_fnc_addPerFrameHandler;

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
            // TODO: handle all ropes broken
            // TODO: handle vehicle dead
            private _ropes = _this select 1;
            private _indexOfUnoccupiedRope = _ropes findIf {
                !(_x select ROPE_IS_OCCUPIED_INDEX) AND 
                { !(_x select ROPE_IS_BROKEN_INDEX) }
            };
            if (_indexOfUnoccupiedRope isEqualTo -1) exitWith { false };
            
            private _unoccupiedRopeInfo = _ropes select _indexOfUnoccupiedRope;
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
