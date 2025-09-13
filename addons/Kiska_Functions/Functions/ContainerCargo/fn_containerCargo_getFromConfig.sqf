/* ----------------------------------------------------------------------------
Function: KISKA_fnc_containerCargo_getFromConfig

Description:
    Translates a config class into an array compatible with `KISKA_fnc_containerCargo_set`.

    Here is an example config layout:

    (begin config example)
        class Example
        {
            class weapons
            {
                class arifle_AK12_GL_F
                {
                    class profile_1 // name doesn't matter
                    {
                        count = 2; // there will be two weapons with these attachments in the container

                        primaryMagazine = "30Rnd_762x39_AK12_Mag_F";
                        primaryAmmo = 30;
                        secondaryAmmo = 1;
                        secondaryMagazine = "1Rnd_HE_Grenade_shell";
                        optic = "optic_Arco";
                        rail = "acc_flashlight";
                        muzzle = "muzzle_snds_B_khk_F";
                        bipod = "";
                    };
                };
            };

            // containers are items that can potentially store other items
            // such as uniforms, vests, and backpacks.
            // containers can infintely define all the same properties of the parent container
            // beneath them so you can store containers within sub containers for example
            class containers
            {
                class B_Bergen_dgtl_F
                {
                    class empty
                    {
                        count = 1;
                    };
                    class full
                    {
                        count = 2;
                        // items within the container
                        class weapons
                        {
                            class arifle_AK12_GL_F
                            {
                                class full
                                {
                                    count = 1;
                                    primaryMagazine = "30Rnd_762x39_AK12_Mag_F";
                                    primaryAmmo = 30;
                                    secondaryAmmo = 1;
                                    secondaryMagazine = "1Rnd_HE_Grenade_shell";
                                    optic = "optic_Arco";
                                    rail = "acc_flashlight";
                                    muzzle = "muzzle_snds_B_khk_F";
                                    bipod = "";
                                };
                            };
                        };

                        // containers within containers
                        class containers
                        {
                            class U_B_survival_uniform
                            {
                                class filled
                                {
                                    count = 1;
                                    class items
                                    {
                                        class H_Booniehat_mgrn
                                        {
                                            count = 1;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };

                class U_B_survival_uniform
                {
                    class empty
                    {
                        count = 1;
                    };

                    class filled
                    {
                        count = 2;
                        class items
                        {
                            class H_Booniehat_mgrn
                            {
                                count = 1;
                            };
                        };
                    };
                };
            };

            class magazines
            {
                class 30Rnd_762x39_AK12_Mag_F
                {
                    class full
                    {
                        count = 30;
                    };
                    class partial
                    {
                        count = 10;
                        ammo = 10;
                    };
                };
            };

            class items
            {
                class ItemRadio
                {
                    count = 1;
                };
            };
        };
    (end example)

Parameters:
    0: _config <CONFIG> - The config class where the manifest for the container
        is defined.

Returns:
    <ARRAY> - An array of cargo compatible with `KISKA_fnc_containerCargo_set`.

Examples:
    (begin example)
        private _configuredContainerCargo = [
            missionConfigFile >> "MyContainerCargo"
        ] call KISKA_fnc_containerCargo_getFromConfig;

        [MyContainer,_configuredContainerCargo] call KISKA_fnc_containerCargo_set;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_containerCargo_getFromConfig";

#define EMPTY_RETURN [[[],[]],[],[],[[],[]],[]]

params [
    ["_config",configNull,[configNull]]
];

if (isNull _config) exitWith { [] };

private _fn_getMaxMagazineRoundCount = {
    params ["_magazineClassname"];
    getNumber (configFile >> "CfgMagazines" >> _magazineClassname >> "count")
};
private _fn_getMagazineInfo = {
    params ["_attachmentsConfig","_ammoProperty","_magazinePropery"];
    private _magazineClassname = getText(_attachmentsConfig >> _magazinePropery);
    private _maxRounds = _magazineClassname call _fn_getMaxMagazineRoundCount;
    private _magazineRoundCount = _maxRounds;
    private _ammoConfig = _attachmentsConfig >> _ammoProperty;
    if (isNumber _ammoConfig) then {
        _magazineRoundCount = (getNumber _ammoConfig) min _maxRounds;
    };

    [_magazineClassname,_magazineRoundCount]
};


/* ----------------------------------------------------------------------------
    weapons
---------------------------------------------------------------------------- */
private _weaponConfigs = configProperties [_config >> "weapons", "isClass _x", true];
private _weaponsCargo = [];
_weaponConfigs apply {
    private _weaponClassname = configName _x;
    if !(isClass (configFile >> "CfgWeapons" >> _weaponClassname)) then {
        [
            [
                "Error, could not find ",
                _weaponClassname,
                " in configFile >> 'CfgWeapons'"
            ],
            true
        ] call KISKA_fnc_log;
        continue;
    };

    private _attachmentProfiles = configProperties [_x, "isClass _x", true];
    _attachmentProfiles apply {
        private _numberOfWeapons = (getNumber (_x >> "count")) max 1;
        _weaponsCargo pushBack [
            [
                _weaponClassname,
                getText(_x >> "muzzle"),
                getText(_x >> "rail"),
                getText(_x >> "optic"),
                [_x,"primaryAmmo","primaryMagazine"] call _fn_getMagazineInfo,
                [_x,"secondaryAmmo","secondaryMagazine"] call _fn_getMagazineInfo,
                getText(_x >> "bipod")
            ],
            _numberOfWeapons
        ];
    };
};

/* ----------------------------------------------------------------------------
    containers
---------------------------------------------------------------------------- */
private _containerCargo = [];
private _backpackCargo = [[], []];
_backpackCargo params ["_backpackClasses","_backpackCounts"];
private _itemCargo = [[], []];
_itemCargo params ["_itemClasses","_itemCounts"];

private _containerConfigs = configProperties [_config >> "containers", "isClass _x", true];
_containerConfigs apply {
    private _containerClassname = configName _x;
    private _containerType = _containerClassname call KISKA_fnc_containerCargo_getContainerType;
    if (_containerType isEqualTo "") then {
        [
            [
                "Container ",_containerClassname,
                " is not a vest, uniform, or backpack!"
            ],
            true
        ] call KISKA_fnc_log;
        continue;
    };

    private _containerProfiles = configProperties [_x, "isClass _x", true];
    private _totalNumberOfContainerType = 0;
    _containerProfiles apply {
        private _numberOfContainersForProfile = (getNumber (_x >> "count")) max 1;
        _totalNumberOfContainerType = _totalNumberOfContainerType + _numberOfContainersForProfile;

        private _subContainerCargo = _x call KISKA_fnc_containerCargo_getFromConfig;
        if (_subContainerCargo isNotEqualTo []) then {
            for "_i" from 1 to _numberOfContainersForProfile do { 
                _containerCargo pushBack [_containerClassname,_subContainerCargo];
            };
        };
    };

    if (_totalNumberOfContainerType <= 0) then { 
        [
            ["No containers found in config -> ",_x],
            true
        ] call KISKA_fnc_log;
        continue 
    };

    if (_containerType == "backpack") then {
        _backpackCounts pushBack _totalNumberOfContainerType;
        _backpackClasses pushBack _containerClassname;
    } else {
        _itemCounts pushBack _totalNumberOfContainerType;
        _itemClasses pushBack _containerClassname;
    };
};


/* ----------------------------------------------------------------------------
    items
---------------------------------------------------------------------------- */
private _itemConfigs = configProperties [_config >> "items", "isClass _x", true];
_itemConfigs apply {
    private _count = (getNumber (_x >> "count")) max 1;
    private _itemClassname = configName _x;
    _itemClasses pushBack _itemClassname;
    _itemCounts pushBack _count;
};


/* ----------------------------------------------------------------------------
    magazines
---------------------------------------------------------------------------- */
private _magazineCargo = [];
private _magazineConfigs = configProperties [_config >> "magazines", "isClass _x", true];
_magazineConfigs apply {
    private _magazineClassname = configName _x;
    private _maxRounds = [_magazineClassname] call _fn_getMaxMagazineRoundCount;
    private _magazineProfileConfigs = configProperties [_x, "isClass _x", true];
    _magazineProfileConfigs apply {
        private "_numberOfRounds";
        if (isNumber (_x >> "ammo")) then {
            _numberOfRounds = ((getNumber(_x >> "ammo")) min _maxRounds) max 0;
        } else {
            _numberOfRounds = _maxRounds;
        };

        private _numberOfMagazines = (getNumber(_x >> "count")) max 1;
        for "_i" from 1 to _numberOfMagazines do { 
            _magazineCargo pushBack [_magazineClassname,_numberOfRounds]
        };
    };
};


private _cargo = [
    _itemCargo,
    _magazineCargo,
    _weaponsCargo,
    _backpackCargo,
    _containerCargo
];

if (_cargo isEqualTo EMPTY_RETURN) exitWith { [] };


_cargo
