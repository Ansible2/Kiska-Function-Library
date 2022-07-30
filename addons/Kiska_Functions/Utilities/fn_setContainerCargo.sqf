/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setContainerCargo

Description:
	Takes a cargo array formatted from KISKA_fnc_getContainerCargo and adds it to another container.
	Exact ammo counts will be preserved even inside of an item, such as magazines inside of a vest or backpack.

Parameters:
	0: _containerToLoad <OBJECT> - The container to add the cargo to.
	1: _cargo <ARRAY or OBJECT> - An array of various items, magazines, and weapons formatted from KISKA_fnc_getContainerCargo or the object to copy from

Returns:
	<BOOL> - True if cargo was coppied

Examples:
    (begin example)
		[container,otherContainer] call KISKA_fnc_setContainerCargo;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_pasteContainerCargo";

params [
	["_containerToLoad",objNull,[objNull]],
	["_cargo",[],[[],objNull]]
];

if (isNull _containerToLoad) exitWith {
	["_containerToLoad isNull",true] call KISKA_fnc_log;
	false
};

if (_cargo isEqualType objNull) then {
	_cargo = [_cargo] call KISKA_fnc_getContainerCargo;
};

if (_cargo isEqualTo []) exitWith {
	["_cargo is empty array '[]'",true] call KISKA_fnc_log;
	false
};


[_containerToLoad] call KISKA_fnc_clearCargoGlobal;


// items
private _items = _cargo select 0;
private _itemTypes = _items select 0;
private _itemTypeCounts = _items select 1;
if (_items isNotEqualTo [[],[]]) then {
	{
		_containerToLoad addItemCargoGlobal [_x,_itemTypeCounts select _forEachIndex];
	} forEach _itemTypes;
};


// magazines
private _magazines = _cargo select 1;
if (_magazines isNotEqualTo []) then {
	_magazines apply {
		_containerToLoad addMagazineAmmoCargo [_x select 0,1,_x select 1];
	};
};


// weapons
private _weapons = _cargo select 2;
if (_weapons isNotEqualTo []) then {
	_weapons apply {
		_containerToLoad addWeaponWithAttachmentsCargoGlobal _x;
	};
};


// backpacks
private _backpacks = _cargo select 3;
private _backpackTypes = _backpacks select 0;
private _backpackTypeCounts = _backpacks select 1;
if (_backpacks isNotEqualTo [[],[]]) then {
	{
		_containerToLoad addBackpackCargoGlobal [_x,_backpackTypeCounts select _forEachIndex];
	} forEach _backpackTypes;
};


// containers within the conatainer (vests, backpacks, etc.)
private _containers = _cargo select 4;
if (_containers isNotEqualTo []) then {

	private _containersIn_containerToLoad = everyContainer _containerToLoad;
	_containers apply {
		private _containerInfo = _x;
		private _containerClass = _containerInfo select 0;

		// find a contianer with the class
		private _index = _containersIn_containerToLoad findIf {(_x select 0) == _containerClass};
		private _containerWithinContainer = (_containersIn_containerToLoad deleteAt _index) select 1;

		[_containerWithinContainer,_containerInfo select 1] call KISKA_fnc_setContainerCargo;
	};
};


true
