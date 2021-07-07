/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playSound2D

Description:
	Plays a 2D sound if a player is within a given area. 
	Used due to say2D's broken "maxTitlesDistance".

Parameters:
	0: _sound <STRING> - The sound name to play
	1: _center <OBJECT or ARRAY> - The center position of the radius to search around
	2: _radius <NUMBER> - How far can the player be from the _center and still "hear" the sound

Returns:
	NOTHING

Examples:
    (begin example)
		["alarm",player,20] call KISKA_fnc_playSound2D;
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {};

params [
	["_sound","alarm",[""]],
	["_center",player,[objNull,[]]],
	["_radius",10,[123]]
];

if (_center isEqualtype objNull AND {isNull _center}) exitWith {
	["Center object isNull",true] call KISKA_fnc_log;
};

if (_radius < 0) exitWith {
	["Raidus is: ",_radius," ...less then 0",true] call KISKA_fnc_log;
};

if ((_center distance2D player) <= _radius) then {
	playsound _sound;
};