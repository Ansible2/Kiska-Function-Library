/* ----------------------------------------------------------------------------
Function: KISKA_fnc_changeAI

Description:
	Disable or enable an AI's behaviour based upon profiles

Parameters:
	0: _unit : <OBJECT> - The unit to adjust
	1: _profile : <STRING> - Thee profile name
	2: _enable : <BOOL> - enableAI (true) or disableAI (false)

Returns:
	BOOL

Examples:
    (begin example)

		[_unit, "canMove", true] call KISKA_fnc_changeAI;

    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */

params [
	["_unit",objNull,[objNull]],
	["_profile","all",[""]],
	["_enable",false,[true]]
];

if !(local _unit) exitWith {false};

/*
"TARGET";
"AUTOTARGET";
"MOVE";
"ANIM";
"TEAMSWITCH";
"FSM";
"WEAPONAIM";
"AIMINGERROR";
"SUPPRESSION";
"CHECKVISIBLE";
"COVER";
"AUTOCOMBAT";
"PATH";
"MINEDETECTION";
"NVG";
"LIGHTS";
"RADIOPROTOCOL";
*/

if (_profile == "canMove") exitWith {
	["TARGET","AUTOTARGET","ANIM","WEAPONAIM","FSM","AIMINGERROR","SUPPRESSION","CHECKVISIBLE","COVER","AUTOCOMBAT","NVG","LIGHTS","RADIOPROTOCOL","MINEDETECTION"] apply {
		if (_enable) then {
			_unit enableAI _x;
		} else {
			_unit disableAI _x; 
		};
	};

	true
};

if (_profile == "canAnimate") exitWith {
	["TARGET","AUTOTARGET","ANIM","WEAPONAIM","FSM","AIMINGERROR","SUPPRESSION","CHECKVISIBLE","COVER","AUTOCOMBAT","NVG","LIGHTS","RADIOPROTOCOL","MINEDETECTION","TEAMSWITCH","PATH"] apply {
		if (_enable) then {
			_unit enableAI _x;
		} else {
			_unit disableAI _x; 
		};
	};

	true
};

false