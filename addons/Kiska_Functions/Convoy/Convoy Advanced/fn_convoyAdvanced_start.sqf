params [
	["_vics",[],[]],

];

if (_vics isEqualTo []) exitWith {
    ["_vics is empty array",true] call KISKA_fnc_log;
    nil
};

private _stateMachine = [
    _vics,
    true
] call CBA_stateMachine_fnc_create;


private _convoyHashMap = createHashMap;
_convoyHashMap set ["_stateMachine",_stateMachine];
_convoyHashMap set ["_convoyLead",_vics select 0];
_convoyHashMap set ["_convoyVehicles",_vics];
_convoyHashMap set ["_debug",false];
_convoyHashMap set ["_minBufferBetweenPoints",1];


{
    _x setVariable ["KISKA_convoyAdvanced_hashMap",_convoyHashMap];
    if (_forEachIndex isEqualTo 0) then { continue };

	_convoyHashMap set [_forEachIndex,_x];
    _x setVariable ["KISKA_convoyAdvanced_index",_forEachIndex];
} forEach _vics;



private _onEachFrame = {
    private _currentVehicle = _this;
    private _convoyHashMap = _currentVehicle getVariable "KISKA_convoyAdvanced_hashMap";
    private _debug = _convoyHashMap get "_debug";
    private _convoyLead = _convoyHashMap get "_convoyLead";
    // private _stateMachine = _convoyHashMap get "_stateMachine";

    if (_currentVehicle isEqualTo _convoyLead) exitWith {};

	/* ----------------------------------------------------------------------------
        Setup
    ---------------------------------------------------------------------------- */
    private "_currentVehicleDrivePath_debug";
    if (_debug) then {
        _currentVehicleDrivePath_debug = _currentVehicle getVariable "KISKA_convoyDrivePath_debug";
    };

    private _currentVehicleDrivePath = _currentVehicle getVariable "KISKA_convoyDrivePath";
    if (isNil "_currentVehicleDrivePath") then {
        _currentVehicleDrivePath = [];
        _currentVehicle setVariable ["KISKA_convoyDrivePath",_currentVehicleDrivePath];

        if (_debug) then {
            _currentVehicleDrivePath_debug = [];
            _currentVehicle setVariable ["KISKA_convoyDrivePath_debug",_currentVehicleDrivePath_debug];
        };
    };
};




_convoyHashMap
