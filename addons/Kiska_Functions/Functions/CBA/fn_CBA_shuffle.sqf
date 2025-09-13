/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_shuffle

Description:
    Copied version of the CBA function `CBA_fnc_shuffle`.

    A function used to randomize a position around a given center.

Parameters:
    0: _array <ARRAY> - Array of values to shuffle.
    1: _inPlace <BOOL> Default: `false` - Alter `_array`, `false` will copy array.

Returns:
    <ARRAY> - The shuffled array.

Example:
    (begin example)
        private _result = [[1, 2, 3, 4, 5]] call KISKA_fnc_CBA_shuffle;
        // _result could be [4, 2, 5, 1, 3]
        
        _array = [1, 2, 3, 4, 5];
        [_array, true] call KISKA_fnc_CBA_shuffle;
        // _array could now be [4, 2, 5, 1, 3]
    (end)

Author(s):
    toadlife (version 1.01) http://toadlife.net
    rewritten by Spooner, Dorbedo,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_shuffle";

params [
    ["_array", [], [[]]], 
    ["_inPlace", false, [false]]
];

private _tempArray = + _array;

if (_inPlace) then {
    for "_size" from (count _tempArray) to 1 step -1 do {
        _array set [_size - 1, (_tempArray deleteAt (floor random _size))];
    };

    _array
} else {
    private _shuffledArray = [];

    for "_size" from (count _tempArray) to 1 step -1 do {
        _shuffledArray pushBack (_tempArray deleteAt (floor random _size));
    };

    _shuffledArray
};

