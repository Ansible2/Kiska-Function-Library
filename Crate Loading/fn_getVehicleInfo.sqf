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