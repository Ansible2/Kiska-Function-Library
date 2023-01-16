/* ----------------------------------------------------------------------------
Function: KISKA_fnc_startConvoyFollow

Description:
    Creates a loop that is intedned to keep an AI convoy configured in the same fashion
     of KISKA_fnc_configureConvoy (group driver units) from being seperated by AI driving
     that encounters unknown obstacles.

Parameters:
    0: _convoyGroup <GROUP> - The convoy group which includes all drivers
    1: _convoyVehicles <OBJECT[]> - The vehicles in the convoy. This should be sorted in the order they will drive

Returns:
    NOTHING

Examples:
    (begin example)
        private _convoyInfo = [BLUFOR,[vic1,vic2]] call KISKA_fnc_configureConvoy;
        _convoyInfo spawn KISKA_fnc_startConvoyFollow;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_startConvoyFollow";

if (!canSuspend) exitWith {
    ["Function should be run in scheduled environment, exiting to scheduled...",false] call KISKA_fnc_log;
    _this spawn KISKA_fnc_startConvoyFollow;
};

params [
    ["_convoyGroup",grpNull,[grpNull]],
    ["_convoyVehicles",[],[[]]]
];


if (isNull _convoyGroup) exitWith {
    ["_convoyGroup was null",true] call KISKA_fnc_log;
    nil
};

if (_convoyVehicles isEqualTo []) exitWith {
    ["_convoyVehicles was empty array",true] call KISKA_fnc_log;
    nil
};

_convoyGroup setVariable ["KISKA_convoyDoBasicFollow",true];

while {_convoyGroup getVariable ["KISKA_convoyDoBasicFollow",false]} do {
    private _leader = leader _convoyGroup;
    private _followUpdates = [];
    // TODO make into perframe handler
    // TODO what happens when a vehicle is destroyed or disabled
    // TODO what happens when the leader is destroyed or disabled
    {
        private _driver = driver _x;
        if (_driver isEqualTo _leader) then {continue};

        private _vehicleAhead = _convoyVehicles param [_forEachIndex - 1, objNull];
        private _maxConvoySeperation = _convoyGroup getVariable ["KISKA_convoySeperation",30];

        private _distanceToVehicleAhead = _x distance _vehicleAhead;
        if (_distanceToVehicleAhead > _maxConvoySeperation) then {
            _followUpdates pushBack _driver;
            _x forceFollowRoad false;
            _x setVariable ["KISKA_convoy_toldToFollow",true];
            continue;
        };

        if (_x getVariable ["KISKA_convoy_toldToFollow",false] AND (isOnRoad _x)) then {
            _x setVariable ["KISKA_convoy_toldToFollow",false];
            _x forceFollowRoad true;
        };

    } forEach _convoyVehicles;

    if (_followUpdates isNotEqualTo []) then {
        _followUpdates doFollow _leader;
    };

    sleep 2;
};


nil
