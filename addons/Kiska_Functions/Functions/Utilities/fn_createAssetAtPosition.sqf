/* ----------------------------------------------------------------------------
Function: KISKA_fnc_createAssetAtPosition

Description:
    Creates an asset using `createVehicle` command and places it at the given
    position, possibly for a temporary amount of time. Ideally used for something
    like smoke plumes of configured lights for example.

Parameters:
    0: _className <STRING> - A `createVehicle` compatible class name of the asset to create.
    1: _position <OBJECT or PositionASL[]> - The place to spawn the object.
    2: _lifetime <NUMBER> - Default: `-1` - How long in seconds until the created 
        object is deleted. A value below `0` indicates it will never be deleted.
    3: _local <NUMBER> - Default: `false` - Whether or not to create the object on the
        local machine only.

Returns:
    <OBJECT> - The created object

Examples:
    (begin example)
        private _smokeEmitter = [
            "G_40mm_SmokeBlue_infinite", // defined in CfgAmmo
            MyPosition,
            20
        ] call KISKA_fnc_createAssetAtPosition;
    (end)

    (begin example)
        private _chemLight = [
            "Chemlight_blue_Infinite",
            [0,0,0],
            -1,
            true
        ] call KISKA_fnc_createAssetAtPosition;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_createAssetAtPosition";

params [
    ["_className","",[""]],
    ["_position",objNull,[[],objNull],3],
    ["_lifetime",-1,[123]],
    ["_local",false,[true]]
];

private _positionIsAnObject = _position isEqualType objNull;
if (_positionIsAnObject AND {isNull _position}) exitWith {
    ["Null position provided"] call KISKA_fnc_log;
    objNull
};

if (_positionIsAnObject) then {
    _position = getPosASL _position;
};

private "_object";
if (!_local) then {
    _object = _className createVehicle _position;
} else {
    _object = _className createVehicleLocal _position;
};

_object setPosASL _position;

if (_lifetime >= 0) then {
    [
        {
            params ["_object"];
            [_object] remoteExecCall ["deleteVehicle",_object];
        },
        [_object],
        _lifetime
    ] call KISKA_fnc_CBA_waitAndExecute;
};


_object