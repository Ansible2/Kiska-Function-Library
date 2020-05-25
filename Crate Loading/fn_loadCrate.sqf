params [
	["_crate",objNull,[objNull]]
];

private _vehicle = (nearestObjects [_crate,DSO_vehicleTypes,10]) select 0;

if (_vehicle getVariable ["DSO_NumCratesLoaded",0] isEqualTo ([_vehicle,3] call KISKA_fnc_getVehicleInfo)) exitWith {
	hint "Max crates loaded already"
};

if !(isNil {player getVariable "DSO_dropCrateActionID"}) then {
	player removeAction (player getVariable "DSO_dropCrateActionID");
};

if (_crate getVariable ["DSO_cratePickedUp",false]) then {
	_crate setVariable ["DSO_cratePickedUp",false];
};

if (isForcedWalk player) then {
	player forceWalk false;
};

private _cratesLoaded = _vehicle getVariable ["DSO_numCratesLoaded",0];

if !(isNull attachedTo _crate) then {
	detach _crate;
};

private _crateDimensions = 0 boundingBoxReal _crate;

private _crateMinDimensions = _crateDimensions select 0;
private _crateMaxDimensions = _crateDimensions select 1;

private _crateXValue = abs ((_crateMaxDimensions select 0) - (_crateMinDimensions select 0));
private _crateYValue = abs ((_crateMaxDimensions select 1) - (_crateMinDimensions select 1));


private _crateZValue = ((boundingCenter _crate) select 2) - ([_vehicle,0] call KISKA_fnc_getVehicleInfo);/*compat*/

private _crateOffset = [_vehicle,2] call KISKA_fnc_getVehicleInfo;

if (_cratesLoaded > 0) then {
	_crateOffset = ((selectMin [-_crateYValue,-_crateXValue]) * _cratesLoaded) + _crateOffset;
};

_crate attachTo [_vehicle,[0,_crateOffset,_crateZValue]]; /*compat*/

_crate setVariable ["DSO_crateLoaded",true,true];

_vehicle setVariable ["DSO_numCratesLoaded",_cratesLoaded + 1,true];

if (_cratesLoaded < 1) then {
	[_vehicle] remoteExecCall ["fn_addUnloadAction",call CBA_fnc_players,true];
};

true