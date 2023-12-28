/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getLoadedModsInfo

Description:
    An alias for the command `getLoadedModsInfo` but with a caching layer in the
	 `uiNamespace`.

Parameters:
    NONE

Returns:
    <ARRAY> - see `getLoadedModsInfo`

Examples:
    (begin example)
        private _modsInfo = call KISKA_fnc_getLoadedModsInfo;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getLoadedModsInfo";

private _cachedInfo = uiNamespace getVariable "KISKA_loadedModsInfo";
if !(isNil "_cachedInfo") exitWith { _cachedInfo };

_cachedInfo = getLoadedModsInfo;
uiNamespace setVariable ["KISKA_loadedModsInfo",_cachedInfo];


_cachedInfo
