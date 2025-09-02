/* ----------------------------------------------------------------------------
Function: KISKA_fnc_invisibleWalls_replaceCommon

Description:
    Replaces several VR blocks with KISKA versions that do not have a shadow
    and will set them to be invisible. Should the KISKA versions without shadows
    be unavailable, the vanilla counterpart (with a shadow) will be used instead.

    When replacing an object, if the object to replace is only local to the machine
    then the created invisible wall will also be local and vice a versa.

    WARNING: This function runs several world sized nearObjects scans. It is recommended
        that this function be run ONCE and during initialization if possible.
        Any object replaced with an invisible wall will be DELETED.

Parameters:
    NONE

Returns:
    <[OBJECT[],OBJECT[]]> - The created invisible walls. Index 0 are global walls,
        index 1 are local only walls.

Examples:
    (begin example)
        private _invisibleWalls = call KISKA_fnc_invisibleWalls_replaceCommon;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_invisibleWalls_replaceCommon";

private _axis = worldSize / 2;
private _worldCenter = [_axis, _axis , 0];
private _worldRadius = (sqrt 2) * _axis;

private _localWalls = [];
private _globalWalls = [];
[
    ["Land_VR_Block_01_F","KISKA_Land_VR_Block_01_F_No_Shadow"],
    ["Land_VR_Slope_01_F","KSIKA_Land_VR_Slope_01_F_No_Shadow"],
    ["Land_VR_Block_03_F","KSIKA_Land_VR_Block_03_F_No_Shadow"],
    ["Land_VR_Block_02_F","KSIKA_Land_VR_Block_02_F_No_Shadow"],
    ["Land_VR_Block_04_F","KSIKA_Land_VR_Block_04_F_No_Shadow"],
    ["Land_VR_Shape_01_cube_1m_F","KSIKA_Land_VR_Shape_01_cube_1m_F_No_Shadow"],
    ["Land_VR_CoverObject_01_kneelHigh_F","KSIKA_Land_VR_CoverObject_01_kneelHigh_F_No_Shadow"],
    ["Land_VR_CoverObject_01_standHigh_F","KSIKA_Land_VR_CoverObject_01_standHigh_F_No_Shadow"],
    ["Land_VR_CoverObject_01_kneel_F","KSIKA_Land_VR_CoverObject_01_kneel_F_No_Shadow"],
    ["Land_VR_CoverObject_01_kneelLow_F","KSIKA_Land_VR_CoverObject_01_kneelLow_F_No_Shadow"],
    ["Land_VR_CoverObject_01_stand_F","KSIKA_Land_VR_CoverObject_01_stand_F_No_Shadow"]
] apply {
    _x params ["_vanillaObjectType","_replacementType"];

    private _objectsToReplace = _worldCenter nearObjects [_vanillaObjectType,_worldRadius];
    if (_objectsToReplace isEqualTo []) then { continue };

    if !(isClass (configFile >> "cfgVehicles" >> _replacementType)) then {
        _replacementType = _vanillaObjectType;
    };

    private _localObjects = [];
    private _globalObjects = [];
    _objectsToReplace apply {
        if (_x call KISKA_fnc_isLocalOnly) then {
            _localObjects pushBack _x;
            continue;
        };
        _globalObjects pushBack _x;
    };
    
    if (_globalObjects isNotEqualTo []) then {
        private _walls = [
            _replacementType,
            false,
            _globalObjects
        ] call KISKA_fnc_invisibleWalls_create;
        _globalWalls append _walls;
    };

    if (_localObjects isNotEqualTo []) then {
        private _walls = [
            _replacementType,
            true,
            _localObjects
        ] call KISKA_fnc_invisibleWalls_create;
        _localWalls append _walls;
    };

    deleteVehicle _objectsToReplace;
};


[_globalWalls,_localWalls]
