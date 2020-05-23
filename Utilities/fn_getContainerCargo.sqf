/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getContainerCargo

Description:
	Saves the cargo of a container in a formatterd array to be used with KISKA_fnc_addContainerCargo for copying cargos of containers.
	Exact ammo counts will be preserved even inside of an item such as magazines inside of a vest or backpack.

Parameters:

	0: _primaryContainer <OBJECT> - The container to save the cargo of

Returns:
	_totalCargo <ARRAY> - Formatted array of all items in cargo space of a container. Used with KISKA_fnc_addContainerCargo. Will return [] if no cargo is present

Examples:
    (begin example)

		[container] call KISKA_fnc_getContainerCargo;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
params [
	["_primaryContainer",objNull,[objNull]]
];

if (isNull _primaryContainer) exitWith {
	"_primaryContainer isNull" call BIS_fnc_error;
	[]	
};

// for containers within the primary container (vests, backpacks, etc.)
private _containers = everyContainer _primaryContainer;

private _containersInfo = [];
if !(_containers isEqualTo []) then {
	_containers apply {
		private _container = _x select 1;
		private _containerClass = _x select 0;

		private _weaponsCargo = [];
		private _weaponsInContainer = weaponsItemsCargo _container;
		if !(_weaponsInContainer isEqualTo []) then {
			_weaponsInContainer apply {
				_weaponsCargo pushBack [_x,1];
			};
		};

		_containersInfo pushBack [_containerClass,(getItemCargo _container),(magazinesAmmoCargo _container),_weaponsCargo,(getBackpackCargo _container)];
	};
};

// sort through weapons
private _weaponsCargo = [];
private _weaponsInContainer = weaponsItemsCargo _primaryContainer;
if !(_weaponsInContainer isEqualTo []) then {
	_weaponsInContainer apply {
		_weaponsCargo pushBack [_x,1];
	};
};

private _totalCargo = [
	// itemCargo
	getItemCargo _primaryContainer,
	// magazineCargo
	magazinesAmmoCargo _primaryContainer,
	// weaponCargo
	_weaponsCargo,
	// backpackCargo
	getBackpackCargo _primaryContainer,
	// containers
	_containersInfo
];

if (_totalCargo isEqualTo [[[],[]],[],[],[]]) exitWith {
	diag_log ("OPTRE_fnc_getContainerCargo: No cargo found in " + str _primaryContainer);
	[]
};

_totalCargo