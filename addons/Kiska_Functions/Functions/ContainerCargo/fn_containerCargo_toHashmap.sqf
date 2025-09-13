/* ----------------------------------------------------------------------------
Function: KISKA_fnc_containerCargo_toHashmap

Description:
    Converts an array of the shape returned from `KISKA_fnc_containerCargo_get`
     into a hashmap structure such that it can be exported to a class with
     `KISKA_fnc_hashmapToConfig`.

Parameters:
    0: _cargoList <ARRAY> - An array in the format of that returned from
        `KISKA_fnc_containerCargo_get`.

Returns:
    <HASHMAP> - A hashmap representation of the cargo.

Examples:
    (begin example)
        private _cargoMap = [
            [MyContainer] call KISKA_fnc_containerCargo_get
        ] call KISKA_fnc_containerCargo_toHashmap;

        private _cargoAsConfig = [_cargoMap] call KISKA_fnc_hashmapToConfig;
        copyToClipboard _cargoAsConfig;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_containerCargo_toHashmap";

params [
    ["_cargoList",[],[[]]]
];

_cargoList params [
    ["_itemCargo",[[],[]],[[]]],
    ["_magazineCargo",[],[[]]],
    ["_weaponsCargo",[],[[]]],
    ["_backpackCargo",[[],[]],[[]]],
    ["_containerCargo",[],[[]]]
];

private _classMap = createHashMapFromArray [
    ["containers",createHashMap],
    ["weapons",createHashMap],
    ["magazines",createHashMap],
    ["items",createHashMap]
];

/* ----------------------------------------------------------------------------
    containers
---------------------------------------------------------------------------- */
private _containerClassnameCounts = createHashMap;
if (_containerCargo isNotEqualTo []) then {
    private _containerCargoToCountMap = createHashMap;
    _containerCargo apply {
        private _countOfContainerCargo = _containerCargoToCountMap getOrDefaultCall [_x,{0}];
        _countOfContainerCargo = _countOfContainerCargo + 1;
        _containerCargoToCountMap set [_x,_countOfContainerCargo];
    };

    private _containersClassMap = _classMap get "containers";
    {
        _x params ["_containerClassname","_subContainerCargo"];
        _containerClassname = toLower _containerClassname;

        private _containerProfileMap = [_subContainerCargo] call containerCargoToHashmap;
        _containerProfileMap set ["count",_y];
        private _profileName = ["profile",_forEachIndex] joinString "_";
        private _mapForClassname = _containersClassMap getOrDefaultCall [
            _containerClassname,
            {createHashMap},
            true
        ];
        _mapForClassname set [_profileName,_containerProfileMap];


        // checking this because backpacks, uniforms, etc. will not appear 
        // only in the containers array. We need to know if empty containers need to be
        // added to the map later after checking items and backpacks.
        private _numberOfClassThatAreContainers = _containerClassnameCounts getOrDefaultCall [
            _containerClassname,
            {0},
            true
        ];
        _numberOfClassThatAreContainers = _y + _numberOfClassThatAreContainers;
        _containerClassnameCounts set [_containerClassname,_numberOfClassThatAreContainers];
    } forEach _containerCargoToCountMap;
};

/* ----------------------------------------------------------------------------
    items
---------------------------------------------------------------------------- */
_itemCargo params ["_itemClassnames","_itemCounts"];
private _itemsMap = _classMap get "items";
{
    private _classnameLowered = toLower _x;
    private _totalNumberOfItem = _itemCounts select _forEachIndex;
    if (_classnameLowered in _containerClassnameCounts) then {
        private _numberOfItemThatAreContainers = _containerClassnameCounts get _classnameLowered;
        if (_numberOfItemThatAreContainers isEqualTo _totalNumberOfItem) then { continue };

        private _containersClassMap = _classMap get "containers";
        private _containerClassProfilesMap = _containersClassMap get _classnameLowered;
        _containerClassProfilesMap set [
            "empty",
            createHashMapFromArray [
                ["count",_totalNumberOfItem - _numberOfItemThatAreContainers]
            ]
        ]
    } else {
        _itemsMap set [
            _x,
            createHashMapFromArray [
                ["count",_totalNumberOfItem]
            ]
        ]
    };
} forEach _itemClassnames;


/* ----------------------------------------------------------------------------
    magazines
---------------------------------------------------------------------------- */
private _fn_getMaxMagazineRoundCount = {
    params ["_magazineClassname"];
    getNumber (configFile >> "CfgMagazines" >> _magazineClassname >> "count")
};

private _magazineCountMap = createHashMap;
_magazineCargo apply {
    private _currentNumberOfMag = _magazineCountMap getOrDefaultCall [_x,{0}];
    _currentNumberOfMag = _currentNumberOfMag + 1;
    _magazineCountMap set [_x,_currentNumberOfMag];
};

private _magazinesClassMap = _classMap get "magazines";
{
    _x params ["_magazineClassname","_ammoCount"];

    _magazineClassname = toLower _magazineClassname;
    private _mapForMagazine = _magazinesClassMap getOrDefaultCall [
        _magazineClassname,
        {createHashMap},
        true
    ];
    private _profileName = ["profile",_forEachIndex] joinString "_";
    private _profileMap =  createHashMapFromArray [["count",_y]];
    _mapForMagazine set [_profileName, _profileMap];

    private _maxRounds = [_magazineClassname] call _fn_getMaxMagazineRoundCount;
    if (_y isNotEqualTo _maxRounds) then {
        _profileMap set ["ammo",_y];
    };
} forEach _magazineCountMap;

/* ----------------------------------------------------------------------------
    weapons
---------------------------------------------------------------------------- */
private _weaponCountMap = createHashMap;
_weaponsCargo apply {
    _x params ["_weaponArray","_count"];
    private _currentWeaponCount = _weaponCountMap getOrDefaultCall [_weaponArray,{0}];
    _currentWeaponCount = _currentWeaponCount + _count;
    _weaponCountMap set [_weaponArray,_currentWeaponCount];
};

private _weaponsClassMap = _classMap get "weapons";
{
    _x params [
        "_className",
        "_muzzle",
        "_rail",
        "_optic",
        "_primaryMagazineInfo",
        "_secondaryMagazineInfo",
        "_bipod"
    ];

    private _weaponProfileMap = _weaponsClassMap getOrDefaultCall [_className,{createHashMap},true];
    private _profileName = ["profile",_forEachIndex] joinString "_";
    private _profileMap =  createHashMap;
    _weaponProfileMap set [_profileName, _profileMap];
    _primaryMagazineInfo params [
        ["_primaryMagazine",""],
        ["_primaryAmmo",-1]
    ];
    _secondaryMagazineInfo params [
        ["_secondaryMagazine",""],
        ["_secondaryAmmo",-1]
    ];

    [
        ["count",_y],
        ["muzzle",_muzzle],
        ["rail",_rail],
        ["optic",_optic],
        ["bipod",_bipod],
        ["primaryMagazine",_primaryMagazine],
        ["secondaryMagazine",_secondaryMagazine],
        ["primaryAmmo",_primaryAmmo],
        ["secondaryAmmo",_secondaryAmmo]
    ] apply {
        _x params ["_property","_value"];
        if (_value isEqualTo -1 or {_value isEqualto ""}) then {
            continue;
        };
        _profileMap set [_property,_value];
    };
} forEach _weaponCountMap;

/* ----------------------------------------------------------------------------
    Backpacks
---------------------------------------------------------------------------- */
_backpackCargo params ["_backpackClassnames","_backpackCounts"];
private _containersClassMap = _classMap get "containers";
{
    private _classnameLowered = toLower _x;
    private _totalNumberOfBackpack = _backpackCounts select _forEachIndex;
    private _numberOfEmptyBags = _totalNumberOfBackpack;
    if (_classnameLowered in _containerClassnameCounts) then {
        private _numberOfBackpackThatAreContainers = _containerClassnameCounts get _classnameLowered;
        if (_numberOfBackpackThatAreContainers isEqualTo _totalNumberOfBackpack) then { 
            continue 
        };
        _numberOfEmptyBags = _totalNumberOfBackpack - _numberOfBackpackThatAreContainers;
    };

    private _containerClassProfilesMap = _containersClassMap getOrDefaultCall [
        _classnameLowered,
        {createHashMap},
        true
    ];
    _containerClassProfilesMap set [
        "empty",
        createHashMapFromArray [
            ["count",_numberOfEmptyBags]
        ]
    ]
} forEach _backpackClassnames;


_classMap
