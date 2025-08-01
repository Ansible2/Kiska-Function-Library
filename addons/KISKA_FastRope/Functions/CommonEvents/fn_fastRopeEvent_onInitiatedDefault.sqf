// TODO: header comment
scriptName "KISKA_fnc_fastRopeEvent_onInitiatedDefault";

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

private _vehicleConfig = configOf _vehicle;
private _friesType = [
    _vehicleConfig,
    "friesType"
] call KISKA_fnc_fastRopeEvent_getConfigData;
if (_friesType isEqualTo "") exitWith {};

private _friesAttachmentPoint = [
    _vehicleConfig,
    "friesAttachmentPoint"
] call KISKA_fnc_fastRopeEvent_getConfigData;

private _fries = _friesType createVehicle [0,0,0];
_fries attachTo [_vehicle,_friesAttachmentPoint];
_vehicle setVariable ["KISKA_fastRope_fries",_fries];


nil
