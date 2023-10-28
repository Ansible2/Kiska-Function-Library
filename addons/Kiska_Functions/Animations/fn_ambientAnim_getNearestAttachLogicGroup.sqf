/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_addAttachLogicGroup

Description:
    Finds the nearest attach logic group used for ambient animations.

Parameters:
    0: _position <OBJECT or Position-2D> - The position to check

Returns:
    <GROUP> - the nearest logic group used for ambient animations

Examples:
    (begin example)
        private _group = [player] call KISKA_fnc_ambientAnim_getNearestAttachLogicGroup;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_getNearestAttachLogicGroup";

#define RADIUS_TO_CHECK 100

params [
    ["_position",[],[objNull,[]],[2,3]]
];

if ((_position isEqualType objNull) AND {isNull _position}) exitWith {
    ["empty array provided",true] call KISKA_fnc_log;
    grpNull
};

if (_position isEqualTo []) exitWith {
    ["empty array provided",true] call KISKA_fnc_log;
    grpNull
};    


private _nearestDistance = -1;
private _nearest = grpNull;
// radius is 3d for nearEntities
(_position nearEntities ["Logic",RADIUS_TO_CHECK]) apply {
    if (_x isNil "KISKA_ambientAnimGroup_ID") then {continue};

    private _distance = _position distance2D _x;
    private _aNearestWasFound = !(isNull _nearest);
    if (_aNearestWasFound AND (_distance > _nearestDistance)) then {
        continue
    };

    _nearestDistance = _distance;
    _nearest = _x;
};


_nearest
