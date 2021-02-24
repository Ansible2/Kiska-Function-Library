/* ----------------------------------------------------------------------------
Function: KISKA_fnc_heliLand

Description:
	Makes a helicopter land at a given position.

Parameters:
	0: _unit <OBJECT> - The person calling the respawn update action
	1: _landingPosition <ARRAY or OBJECT> - Where to land. If object, position ATL is used.
	2: _landMode <STRING> - Options are "LAND", "GET IN", and "GET OUT"

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
#define SCRIPT_NAME "KISKA_fnc_heliLand"
scriptName SCRIPT_NAME;

params [
	["_unit",objNull,[objNull]],
	["_landingPosition",[],[[],objNull]],
	["_landMode","GET IN",[""]]
];

if (isNull _unit) exitWith {
	["_unit is a null object",true] call KISKA_fnc_log;
	false
};

// need to expand to VTOL
if (!(_unit isKindOf "Helicopter") AND {(_unit isKindOf "VTOL_Base_F")}) then {
	[[_unit," is not a helicopter or VTOL, exiting..."],true] call KISKA_fnc_log;
	false
};

_unit setVariable ["KISKA_heliLanded",false];

if (_landingPosition isEqualType objNull) then {
	_landingPosition = getPosATL _landingPosition;
};

[_unit,_landingPosition,_landMode] spawn {
	params ["_unit","_landingPosition","_landMode"];

	_unit move _landingPosition;

	private _landed = false;
	private _wasToldToLand = false;
	private "_unitAlt";
	waitUntil {
		sleep 0.25;
		if !(_wasToldToLand) then {
			// tell unit to land at position when ready
			if (unitReady _unit) then {
				_unit land _landMode;
				_wasToldToLand = true;
			};
		} else {
			_unitAlt = (getPosATL _unit) select 2;
			if (isTouchingGround _unit OR {_unitAlt < 0.1}) then {
				_landed = true;
				// reinforce land
				// sometimes, the helicopter will "land" but immediately take off again
				// this is why the thing is told to land again
				sleep 2;
				// keep engine running
				_unit engineon true;
				_unit land _landMode;
				//_unit flyInHeight 0;
			};
		};

		_landed
	};

	_unit setVariable ["KISKA_heliLanded",true];
};


true