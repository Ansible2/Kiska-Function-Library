/* ----------------------------------------------------------------------------
Function: KISKA_fnc_markPositions

Description:
    Simply creates a 3d object helper marker on provided postitions. 
    Works in 3den also.

Parameters:
    0: _positions <ARRAY> - An array of positions to place the markers on

Returns:
    _entities <ARRAY> - all created markers

Examples:
    (begin example)
        [[0,0,0],[0,0,0]] call KISKA_fnc_markPositions;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
params [
    ["_positions",[],[[]]]
];

if (_positions isEqualTo []) exitWith {
    []
};

private _entities = [];

if (is3DEN) then {
    _positions apply {
        private _entity = create3DENEntity ["OBJECT","Sign_Arrow_Large_F",_x];
        _entities pushBack _entity;
    };

} else {
    _positions apply {
        private _entity = "Sign_Arrow_Large_F" createVehicle _x;
        _entities pushBack _entity;
    };

};

_entities
