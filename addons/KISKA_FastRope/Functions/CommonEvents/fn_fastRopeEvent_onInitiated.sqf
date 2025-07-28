scriptName "KISKA_fnc_fastRopeEvent_onInitiated";

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

private _vehicleConfig = configOf _vehicle;

// TODO:
// create FRIES from type if available
// attach fries to vehicle
// Save reference to vehicle