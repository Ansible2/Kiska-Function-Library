/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getVehicleInfo

Description:
	Gets global info for a vehicle (type)

	Format for index is:
		0: crate z offset
		1: Unload offset
		2: crate y offset
		3: max crates
		4: unload action distance

Parameters:

	0: _vehicle <OBJECT> - The vehicle to get info for
	1: _index <NUMBER> - The info requested (index number)

Returns:
	NUMBER

Examples:
    (begin example)

		_crateZOffset = [vehicle1,0] call KISKA_fnc_getVehicleInfo;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */

params ["_vehicle","_index"];

private _type = typeOf _vehicle;

// check if base type is in array if not specific vehicle type
if !(_type in DSO_vehicleTypes) then {
	private _baseType = configName (inheritsFrom (configFile >> "CfgVehicles" >> _type));

	private _vehicleParents = [configFile >> "CfgVehicles" >> _type, true] call BIS_fnc_returnParents;
	
	private _typeIndex = _vehicleParents findIf {_x in DSO_vehicleTypes};

	if (_typeindex isEqualTo -1) then {
		["Type %1 and base type %2 are not defined in DSO_vehicleTypes",[_type,_baseType]] call BIS_fnc_error;
	} else {
		_type = _vehicleParents select _typeIndex;
	};
};

private _info = missionNamespace getVariable ("DSOInfo_" + _type);

_info select _index