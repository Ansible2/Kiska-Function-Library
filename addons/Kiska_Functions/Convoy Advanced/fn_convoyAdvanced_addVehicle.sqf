/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convoyAdvanced_addVehicle

Description:
    Adds a given vehicle to a convoy.

Parameters:
    0: _convoyHashMap <HASHMAP> - The convoy hashmap to add to
    1: _vehicle <OBJECT> - The vehicle to add
    2: _insertIndex <NUMBER> - The index to insert the vehicle into the convoy at 
        (0 is lead vehicle, 1 is vehicle directly behind leader, etc.)

Returns:
    <NUMBER> - The index the vehicle was inserted into the convoy at

Examples:
    (begin example)
        private _convoyMap = [] call KISKA_fnc_convoyAdvanced_create;
        private _spotInConvoy = [
            _convoyMap
            vic
        ] call KISKA_fnc_convoyAdvanced_addVehicle;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convoyAdvanced_addVehicle";
// TODO: handle vehicle or convoy is moving when trying to add vehicle
#define MAX_ARRAY_LENGTH 1E7

params [
    "_convoyHashMap",
    ["_vehicle",objNull,[objNull]],
    ["_insertIndex",-1,[123]]
];


if (isNull _vehicle) exitWith {
    ["_vehicle is null",true] call KISKA_fnc_log;
    -1
};

private _driver = driver _vehicle;
if !(alive _driver) exitWith {
    [["_vehicle ",_vehicle," does not have an alive driver"],false] call KISKA_fnc_log;
    -1
};

private _convoyStatemachine = _convoyHashMap get "_stateMachine";
if (isNil "_convoyStatemachine") exitWith {
    [["_stateMachine is not defined in map: ",_convoyHashMap],true] call KISKA_fnc_log;
    -1
};


private _convoyVehicles = _convoyHashMap getOrDefault ["_convoyVehicles",[]];
if (_convoyVehicles isEqualTo []) then {
    _convoyHashMap set ["_convoyLead",_vehicle];
    _convoyHashMap set ["_convoyVehicles",_convoyVehicles];
};

if (_vehicle in _convoyVehicles) exitWith {
    [["_vehicle ",_vehicle," is already in _convoyHashMap ",_convoyHashMap],true] call KISKA_fnc_log;
    _vehicle getVariable ["KISKA_convoyAdvanced_index",-1]
};

private _convoyCount = count _convoyVehicles;
if (_insertIndex < 0) then {
    private _convoyIndex = _convoyVehicles pushBack _vehicle;
    _convoyHashMap set [_convoyIndex,_vehicle];

} else {
    private _vehiclesToChangeIndex = _convoyVehicles select [_insertIndex,MAX_ARRAY_LENGTH];
    
    _convoyVehicles resize _insertIndex;
    _convoyVehicles pushBack _vehicle;
    _convoyVehicles append _vehiclesToChangeIndex;
    
    _vehicle setVariable ["KISKA_convoyAdvanced_index",_insertIndex];
    _convoyHashMap set [_insertIndex,_vehicle];

    _vehiclesToChangeIndex apply {
        private _currentIndex = _x getVariable ["KISKA_convoyAdvanced_index",-1];
        if (_currentIndex isEqualTo -1) then {
            [["Could not find 'KISKA_convoyAdvanced_index' in namespace of ", _x," to change"],true] call KISKA_fnc_log;
            continue
        };

        private _newIndex = _currentIndex + 1;
        _convoyHashMap set [_newIndex,_x];
        _x setVariable ["KISKA_convoyAdvanced_index",_newIndex];
    };

};


_vehicle setVariable ["KISKA_convoyAdvanced_hashMap",_convoyHashMap];
_vehicle setVariable ["KISKA_convoyAdvanced_index",_convoyIndex];


_convoyIndex
