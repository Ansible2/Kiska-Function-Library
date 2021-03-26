/* ----------------------------------------------------------------------------
Function: KISKA_fnc_heliLand

Description:
	Makes a helicopter land at a given position.

Parameters:
	0: _aircraft <OBJECT> - The helicopter
	1: _landingPosition <ARRAY or OBJECT> - Where to land. If object, position ATL is used.
	2: _landMode <STRING> - Options are "LAND", "GET IN", and "GET OUT"
	3: _createHelipad <BOOL> - If true, and invisible helipad will be created. Helipads strongly encourage where a unit will land.

Returns:
	<BOOL> - True if helicopter can attempt, false if problem

Examples:
    (begin example)
		[myHeli,position player] call KISKA_fnc_heliLand;
    (end)

Author:
	Karel Moricky,
	Modified By: Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_heliLand";


#define HELIPAD_BASE "Helipad_base_F"
#define INVISIBLE_PAD_TYPE "Land_HelipadEmpty_F"
#define LAND_EVENT "KISKA_landedEvent"


params [
	["_aircraft",objNull,[objNull]],
	["_landingPosition",[],[[],objNull]],
	["_landMode","GET IN",[""]],
	["_createHelipad",true,[true]]
];

if (isNull _aircraft) exitWith {
	["_aircraft is a null object",true] call KISKA_fnc_log;
	false
};

if (!(_aircraft isKindOf "Helicopter") AND {(_aircraft isKindOf "VTOL_Base_F")}) exitWith {
	[[_aircraft," is not a helicopter or VTOL, exiting..."],true] call KISKA_fnc_log;
	false
};


// move command only supports positions, not objects
if (_landingPosition isEqualType objNull) then {
	// if LZ is already a pad, don't create another one
	if (_createHelipad AND {_landingPosition isKindOf HELIPAD_BASE}) then {
		_createHelipad = false;
	};
	_landingPosition = getPosATL _landingPosition;
};

// helipads are where AI will primarly look to land
if (_createHelipad) then {
	INVISIBLE_PAD_TYPE createVehicle _landingPosition;
};

[_aircraft,_landingPosition,_landMode] spawn {
	params ["_aircraft","_landingPosition","_landMode"];

	_aircraft move _landingPosition;

	private _landed = false;
	private _wasToldToLand = false;
	private "_unitAlt";
	waitUntil {
		sleep 0.25;
		if (!alive _aircraft) exitWith {};
		if !(_wasToldToLand) then {
			// tell unit to land at position when ready
			if (unitReady _aircraft) then {
				_aircraft land _landMode;
				_wasToldToLand = true;
			};
		} else {
			_unitAlt = (getPosATL _aircraft) select 2;
			if (isTouchingGround _aircraft OR {_unitAlt < 0.1}) then {
				_landed = true;
				// reinforce land
				// sometimes, the helicopter will "land" but immediately take off again
				// this is why the thing is told to land again
				sleep 2;
				// keep engine running
				_aircraft engineon true;
				_aircraft land _landMode;
				//_aircraft flyInHeight 0;
			};
		};

		_landed
	};

	[_aircraft,LAND_EVENT,[_aircraft]] call BIS_fnc_callScriptedEventHandler;
};


true
