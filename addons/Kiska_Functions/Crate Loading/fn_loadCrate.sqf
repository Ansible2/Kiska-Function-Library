/* ----------------------------------------------------------------------------
Function: KISKA_fnc_loadCrate

Description:
	Searches area and automatically finds closest suitable vehicle to load upon execution of action

	Has lots of offset maths to it. Most of it was garbage guess work though...

Parameters:

	0: _crate <OBJECT> - The crate to load

Returns:
	BOOL

Examples:
    (begin example)

		[crate1] call KISKA_fnc_loadCrate;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */

params [
	["_crate",objNull,[objNull]]
];

if (isNull _crate) exitWith {
	"_crate isNull" call BIS_fnc_error;
	false
};

// find nearest vehicle of the types provided
private _vehicle = (nearestObjects [_crate,DSO_vehicleTypes,10]) select 0;

if (isNil "_vehicle") exitWith {
	hint "This vehicle can't be loaded";
	false
};

private _cratesLoaded = _vehicle getVariable ["DSO_loadedCrates",[]];
private _numCratesLoaded = count _cratesLoaded;

if (_numCratesLoaded isEqualTo ([_vehicle,3] call KISKA_fnc_getVehicleInfo)) exitWith {
	hint "Max crates loaded already";
	false
};

if !(isNil {player getVariable "DSO_dropCrateActionID"}) then {
	player removeAction (player getVariable "DSO_dropCrateActionID");
};

// if crate is picked up, set it to not be
if (_crate getVariable ["DSO_cratePickedUp",false]) then {
	_crate setVariable ["DSO_cratePickedUp",false,true];
};

if (isForcedWalk player) then {
	player forceWalk false;
};



if !(isNull attachedTo _crate) then {
	detach _crate;
};


// get crate dimensions
private _crateDimensions = 0 boundingBoxReal _crate;

private _crateMinDimensions = _crateDimensions select 0;
private _crateMaxDimensions = _crateDimensions select 1;

private _crateXValue = abs ((_crateMaxDimensions select 0) - (_crateMinDimensions select 0));
private _crateYValue = abs ((_crateMaxDimensions select 1) - (_crateMinDimensions select 1));

// get offsets
private _crateZValue = ((boundingCenter _crate) select 2) - ([_vehicle,0] call KISKA_fnc_getVehicleInfo);/*compat*/

private _crateOffset = [_vehicle,2] call KISKA_fnc_getVehicleInfo;

if (_numCratesLoaded > 0) then {
	_crateOffset = ((selectMin [-_crateYValue,-_crateXValue]) * _numCratesLoaded) + _crateOffset;
};

_crate attachTo [_vehicle,[0,_crateOffset,_crateZValue]]; /*compat*/



// set public vars
_crate setVariable ["DSO_crateLoaded",true,true];
// add crate to vehicles list
_cratesLoaded pushBack _crate;
_vehicle setVariable ["DSO_loadedCrates",_cratesLoaded,true];


// add unload action and event handler if first crate
if (_numCratesLoaded < 1) then {
	[_vehicle] remoteExecCall ["KISKA_fnc_addUnloadCratesAction",0,true];

	// add eventHandler
	private _handleID = _vehicle addMPEventHandler ["MPKilled",{

		params ["_vehicle"];

		if (isServer) then {
			if !(_vehicle getVariable ["DSO_loadedCrates",[]] isEqualTo []) then {
				[_vehicle] call KISKA_fnc_unloadCrates;
			};

			[_vehicle,["MPKilled",_thisEventHandler]] remoteExecCall ["removeMPEventHandler",_vehicle];
		};
	}];
};

true
