/* ----------------------------------------------------------------------------
Function: KISKA_fnc_isEmptyCode

Description:
    Checks if the provided argument is an empty code block. Also handles the fact
     that a `compileFinal`'d block is not actually equal to `{}`.

Parameters:
    _this <ANY> - The value to check.

Returns:
    <BOOL> - Whether or not the given argument is equal to empty code.

Examples:
    (begin example)
        {} call KISKA_fnc_isEmptyCode; // true
        (compileFinal "") call KISKA_fnc_isEmptyCode; // true
        "" call KISKA_fnc_isEmptyCode; // false
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_isEmptyCode";


_this isEqualTo {} OR { _this isEqualTo (compileFinal "") }
