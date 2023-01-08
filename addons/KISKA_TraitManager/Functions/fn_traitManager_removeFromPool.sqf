#include "..\Headers\Trait Manager Common Defines.hpp"
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_removeFromPool

Description:
    Removes the provided index from the pool.

Parameters:
    0: _index <NUMBER> - The selected index

Returns:
    NOTHING

Examples:
    (begin example)
        [0] call KISKA_fnc_traitManager_removeFromPool;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_removeFromPool";

if (!hasInterface) exitWith {};

params [
    ["_index",-1,[123]]
];

private _array = GET_TM_POOL;
if (_array isNotEqualTo []) then {
    _array deleteAt _index;
};

call KISKA_fnc_traitManager_updateCurrentList;
call KISKA_fnc_traitManager_updatePoolList;

nil
