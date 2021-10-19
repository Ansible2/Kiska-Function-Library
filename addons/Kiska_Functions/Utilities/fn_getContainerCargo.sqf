/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getContainerCargo

Description:
	Saves the cargo of a container in a formatterd array to be used with
	 KISKA_fnc_pasteContainerCargo for copying cargos of containers.

	Exact ammo counts will be preserved even inside of an item such as magazines
	 inside of a vest or backpack.

Parameters:
	0: _primaryContainer <OBJECT> - The container to save the cargo of

Returns:
	<ARRAY> - Formatted array of all items in cargo space of a container. Used with KISKA_fnc_setContainerCargo. Will return [] if no cargo is present

Examples:
    (begin example)
		[container] call KISKA_fnc_getContainerCargo;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getContainerCargo";

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

// sort through weapons
private _weaponsCargo = [];
private _weaponsInContainer = weaponsItemsCargo _primaryContainer;
if (_weaponsInContainer isNotEqualTo []) then {
	_weaponsInContainer apply {
		_weaponsCargo pushBack [_x,1];
	};
};

private _totalCargo = [

	getItemCargo _primaryContainer,

	magazinesAmmoCargo _primaryContainer,

	_weaponsCargo,

	getBackpackCargo _primaryContainer,
	// containers within containers
	_containersInfo
];

if (_totalCargo isEqualTo EMPTY_RETURN) exitWith {
	[["No cargo found in ",_primaryContainer],true] call KISKA_fnc_log;
	[]
};


_totalCargo
