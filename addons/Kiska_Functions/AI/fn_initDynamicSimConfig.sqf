/* ----------------------------------------------------------------------------
Function: KISKA_fnc_initDynamicSimConfig

Description:
	Initializes the dynamic simulation system with the given values based on
	 mission config values.

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
        POST-INIT Function
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_initDynamicSimConfig";

private _dynamicSimConfig = missionConfigFile >> "KISKA_dynamicSimulation";
if (isNull _dynamicSimConfig) exitWith {
	["_dynamicSimConfig at missionConfigFile >> 'KISKA_dynamicSimulation', is null",false] call KISKA_fnc_log;
	nil
};

private _enableSystem = [_dynamicSimConfig >> "enableDynamicSimulation"] call BIS_fnc_getCfgDataBool;
enableDynamicSimulationSystem _enableSystem;


private _coefConfig = _dynamicSimConfig >> "Coef";
private _coefProperties = ["IsMoving"];
_coefProperties apply {
	private _propertyConfig = _coefConfig >> _x;
	if !(isNumber _propertyConfig) then {
		[[_x," was not defined (as number) in the missionConfigFile >> KISKA_dynamicSimulation >> Coef class"],false] call KISKA_fnc_log;
		continue;
	};

	_x setDynamicSimulationDistanceCoef (getNumber _propertyConfig);
};


private _activationDistanceConfig = _dynamicSimConfig >> "ActivationDistance";
private _distanceProperties = ["Group","Vehicle","EmptyVehicle","Prop"];
_distanceProperties apply {
	private _propertyConfig = _activationDistanceConfig >> _x;
	if !(isNumber _propertyConfig) then {
		[[_x," was not defined (as number) in the missionConfigFile >> KISKA_dynamicSimulation >> ActivationDistance class"],false] call KISKA_fnc_log;
		continue;
	};

	_x setDynamicSimulationDistance (getNumber _propertyConfig);
};


nil