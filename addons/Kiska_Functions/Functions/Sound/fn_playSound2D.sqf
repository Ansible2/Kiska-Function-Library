/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playSound2D

Description:
    Plays a 2D sound if a player is within a given area.
    Used due to say2D's broken "maxTitlesDistance".

Parameters:
    0: _sound <STRING> - The sound name to play
    1: _center <OBJECT or ARRAY> - The center position of the radius to search around
    2: _radius <NUMBER> - How far can the player be from the _center and still "hear" the sound
    3: _threeDimensional <BOOL> - Whether to measure the distance to the player in 2d or 3d space

Returns:
    <BOOL> - True if played, false if did not

Examples:
    (begin example)
        ["alarm",player,20] call KISKA_fnc_playSound2D;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
if !(hasInterface) exitWith {false};

params [
    ["_sound","alarm",[""]],
    ["_center",player,[objNull,[]]],
    ["_radius",10,[123]],
    ["_threeDimensional",false,[true]]
];

if ((_center isEqualtype objNull) AND {isNull _center}) exitWith {
    ["Center object isNull",true] call KISKA_fnc_log;
    false
};

if (_radius isEqualTo 0) exitWith {
    playsound _sound;
    true
};

if (_radius < 0) exitWith {
    [["Raidus is: ",_radius," ...less then 0. Must be more then 0"],true] call KISKA_fnc_log;
    false
};

private "_distanceToPlayer";
if (_threeDimensional) then {
    _distanceToPlayer = _center distance player;
} else {
    _distanceToPlayer = _center distance2D player;
};

if (_distanceToPlayer <= _radius) then {
    playsound _sound;
    true

} else {
    false

};
