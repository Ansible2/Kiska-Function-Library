/* ----------------------------------------------------------------------------
Function: KISKA_fnc_containerCargo_get

Description:
    Saves the cargo of a container in a formatterd array to be used with
     `KISKA_fnc_containerCargo_set` for copying cargos of containers.

    Exact ammo counts will be preserved even inside of an item such as magazines
     inside of a vest or backpack.

Parameters:
    0: _primaryContainer <OBJECT> - The container to save the cargo of

Returns:
    <ARRAY> - Formatted array of all items in cargo space of a container.
        Used with `KISKA_fnc_containerCargo_set`. Will return `[]` if no cargo is present.

Examples:
    (begin example)
        private _cargo = [container] call KISKA_fnc_containerCargo_get;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_containerCargo_get";

#define EMPTY_RETURN [[[],[]],[],[],[[],[]],[]]

params [
    ["_primaryContainer",objNull,[objNull]]
];

if (isNull _primaryContainer) exitWith {
    ["_primaryContainer isNull",true] call KISKA_fnc_log;
    []
};

// for containers within the primary container (vests, backpacks, etc.)
private _containers = everyContainer _primaryContainer;
private _containersInfo = [];
if (_containers isNotEqualTo []) then {

    _containers apply {

        private _container = _x select 1;
        private _cargoInContainer = [_container] call KISKA_fnc_getContainerCargo;

        if (_cargoInContainer isNotEqualTo []) then {
            private _containerClass = _x select 0;
            _containersInfo pushBack [
                _containerClass,
                _cargoInContainer
            ];
        };

    };

};

private _weaponsInContainer = weaponsItemsCargo _primaryContainer;
private _weaponsCountMap = createHashMap;
_weaponsInContainer apply {
    private _currentWeaponCount = _weaponsCountMap getOrDefaultCall [_x,{0}];
    _currentWeaponCount = _currentWeaponCount + 1;
    _weaponsCountMap set [_x,_currentWeaponCount];
};
private _weaponsCargo = [];
_weaponsCountMap apply { _weaponsCargo pushBack [_x,_y] };


private _totalCargo = [

    getItemCargo _primaryContainer,

    magazinesAmmoCargo _primaryContainer,

    _weaponsCargo,

    getBackpackCargo _primaryContainer,
    // containers within containers
    _containersInfo
];

if (_totalCargo isEqualTo EMPTY_RETURN) exitWith { [] };


_totalCargo
