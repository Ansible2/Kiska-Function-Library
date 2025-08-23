/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_onInitiatedDefault

Description:
    The default behaviour for when a fastroping vehicle is initially determined
     to have passed parameter validation and told to go fastrope some troops somewhere.
    
    The default behaviour is to use `KISKA_fnc_fastRope_getConfigData` to create
     and attach a `"friesType"` to the `"friesAttachmentPoint"` of the vehicle.

Parameters:
    0: _vehicle <OBJECT> - The vehicle to fastrope from.

Returns:
    NOTHING

Examples:
    (begin example)
        _vehicle call KISKA_fnc_fastRopeEvent_onInitiatedDefault;
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_onInitiatedDefault";

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

private _vehicleConfig = configOf _vehicle;
private _friesType = [
    _vehicleConfig,
    "friesType"
] call KISKA_fnc_fastRope_getConfigData;
if (_friesType isEqualTo "") exitWith {};

private _friesAttachmentPoint = [
    _vehicleConfig,
    "friesAttachmentPoint"
] call KISKA_fnc_fastRope_getConfigData;

private _fries = _friesType createVehicle [0,0,0];
_fries attachTo [_vehicle,_friesAttachmentPoint];
[_vehicle,_fries] call KISKA_fnc_fastRope_fries;


nil
