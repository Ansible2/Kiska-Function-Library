/* ----------------------------------------------------------------------------
Function: KISKA_fnc_containerCargo_getContainerType

Description:
    Used to retrieve the type of container that a given class is.

    Will only return a value if the classname is that of a vest, uniform, or backpac.

Parameters:
    0: _classname <STRING> - The classname of the container to find the type of.

Returns:
    <STRING> - `"vest"`, `"uniform"`, or `"backpack"`. If the classname does not match
        any of these types, an empty string `""` will be returned.

Examples:
    (begin example)
        private _containerType = [
            "b_bergen_dgtl_f"
        ] call KISKA_fnc_containerCargo_getContainerType;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_containerCargo_getContainerType";

params [
    ["_classname","",[""]]
];

if (isclass (configfile >> "cfgweapons" >> _classname)) exitWith {
    private _weaponConfig = configfile >> "cfgweapons" >> _classname;
    private _simulation = getText(_weaponConfig >> "simulation");
    if (_simulation != "weapon") exitWith { "" };

    private "_typeId";
    private _weaponTypeConfig = _weaponConfig >> "type";
    if (isText(_weaponTypeConfig)) then {
        _typeId = _weaponTypeConfig call BIS_fnc_parseNumberSafe;
    } else {
        _typeId = getNumber _weaponTypeConfig;
    };

    if (_typeId isNotEqualTo 131072) exitWith { "" };
    private _infoType = getNumber (_weaponConfig >> "itemInfo" >> "type");

    if (_infoType isEqualTo 701) exitWith { "vest" };
    if (_infoType isEqualTo 801) exitWith { "uniform" };

    ""
};

if (isclass (configfile >> "cfgvehicles" >> _classname)) exitWith {
    private _isBackpack = getNumber(configfile >> "cfgvehicles" >> _classname >> "isBackpack");
    ["","backpack"] select (_isBackpack > 0)
};


""