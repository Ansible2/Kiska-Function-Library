/* ----------------------------------------------------------------------------
Function: KISKA_fnc_pasteContainerCargo

Description:
	Takes a cargo array formatted from KISKA_fnc_copyContainerCargo and adds it to another container.
	Exact ammo counts will be preserved even inside of an item, such as magazines inside of a vest or backpack.

Parameters:
	0: _containerToLoad <OBJECT> - The container to add the cargo to.
	1: _cargo <ARRAY> - An array of various items, magazines, and weapons formatted from KISKA_fnc_copyContainerCargo

Returns:
	BOOL

Examples:
    (begin example)
		[container,([otherContainer] call KISKA_fnc_copyContainerCargo)] call KISKA_fnc_pasteContainerCargo;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_pasteContainerCargo";

params [
	["_containerToLoad",objNull,[objNull]],
	["_cargo",[],[[]]]
];

if (isNull _containerToLoad) exitWith {
	["_containerToLoad isNull",true] call KISKA_fnc_log;
	false	
};

if (_cargo isEqualTo []) exitWith {
	["_cargo is empty array '[]'",true] call KISKA_fnc_log;
	false 
};

// items
private _items = _cargo select 0;
if !(_items isEqualTo [[],[]]) then {
	{
		_containerToLoad addItemCargoGlobal [_x,(_items select 1) select _forEachIndex];
	} forEach (_items select 0);
};

// magazines
private _magazines = _cargo select 1;
if !(_magazines isEqualTo []) then {
	_magazines apply {
		_containerToLoad addMagazineAmmoCargo [_x select 0,1,_x select 1];
	};
};

// weapons
private _weapons = _cargo select 2;
if !(_weapons isEqualTo []) then {
	_weapons apply {
		_containerToLoad addWeaponWithAttachmentsCargoGlobal _x;
	};
};

// backpacks
private _backpacks = _cargo select 3;
if (_backpacks isNotEqualTo [[],[]]) then {
	{
		_containerToLoad addBackpackCargoGlobal [_x,(_backpacks select 1) select _forEachIndex];
	} forEach (_backpacks select 0);
};

// containers within the conatainer (vests, backpacks, etc.)
private _containers = _cargo select 4;
if !(_containers isEqualTo []) then {

	private _containersIn_containerToLoad = everyContainer _containerToLoad;
	_containers apply {
		private _containerInfo = _x;
		private _containerClass = _containerInfo select 0;

		// find a contianer with the class
		private _index = _containersIn_containerToLoad findIf {(_x select 0) isEqualTo _containerClass};
		private _containerWithinContainer = (_containersIn_containerToLoad deleteAt _index) select 1;

		// make sure container is empty
		clearWeaponCargoGlobal _containerWithinContainer;
		clearMagazineCargoGlobal _containerWithinContainer;
		clearItemCargoGlobal _containerWithinContainer;
		clearBackpackCargoGlobal _containerWithinContainer;

		// items
		private _items = _containerInfo select 1;
		if !(_items isEqualTo [[],[]]) then {
			{
				_containerWithinContainer addItemCargoGlobal [_x,(_items select 1) select _forEachIndex];
			} forEach (_items select 0);
		};

		// magazines
		private _magazines = _containerInfo select 2;
		if !(_magazines isEqualTo []) then {
			_magazines apply {
				_containerWithinContainer addMagazineAmmoCargo [_x select 0,1,_x select 1];
			};
		};

		// weapons
		private _weapons = _containerInfo select 3;
		if !(_weapons isEqualTo []) then {
			_weapons apply {
				_containerWithinContainer addWeaponWithAttachmentsCargoGlobal _x;
			};
		};

		// backpacks
		private _backpacks = _containerInfo select 4;
		if !(_backpacks isEqualTo [[],[]]) then {
			{
				_containerWithinContainer addBackpackCargoGlobal [_x,(_backpacks select 1) select _forEachIndex];
			} forEach (_backpacks select 0);
		};
	};
};

true