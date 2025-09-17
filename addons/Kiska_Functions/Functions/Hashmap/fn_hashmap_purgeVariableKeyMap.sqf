/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmap_purgeVariableKeyMap

Description:
    Removes any hashmap entries in the `KISKA_fnc_hashmap_getVariableKeyMap` that
     have null values. Can be used if for whatever reason there is concern that 
     the map is filled with many unecessary values.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_hashmap_purgeVariableKeyMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmap_purgeVariableKeyMap";

private _variableKeyMap = call KISKA_fnc_hashmap_getVariableKeyMap;
private _keysToDelete = [];
_variableKeyMap apply {
    if (
        !(_y isEqualTypeAny [
            grpNull,
            objNull,
            locationNull,
            controlNull,
            displayNull,
            taskNull,
            teamMemberNull
        ]) 
        OR 
        { !(isNull _x) }
    ) then { continue };

    _keysToDelete pushBack _x;
};

_keysToDelete apply { _variableKeyMap deleteAt _x };

nil
