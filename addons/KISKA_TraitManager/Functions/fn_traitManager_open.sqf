/* ----------------------------------------------------------------------------
Function: KISKA_fnc_traitManager_open

Description:
    Opens KISKA Trait Manager dialog.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_traitManager_open;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_traitManager_open";

#define RESERVED_TRAITS ["MEDIC","ENGINEER","EXPLOSIVESPECIALIST","UAVHACKER"]
#define NUMBER_TRAITS ["LOADCOEF","AUDIBLECOEF","CAMOUFLAGECOEF"]


if !(hasInterface) exitWith {
    ["Attempting to open trait manager with no interface"] call KISKA_fnc_log;
    nil
};

disableSerialization;

private _args = [
    localNamespace,
    "KISKA_traitManager_openArgs",
    {
        createHashMapFromArray [
            ["_storeId","kiska-trait-manager"],
            ["_storeSelectedItemsTitle","Current Traits"],
            ["_storePoolTitle","Trait Pool"],
            ["_storeTitle","Trait Manager"],
            [
                "_fn_poolItemToListboxItem",
                {
                    params [
                        ["_traitConfig",configNull,[configNull]],
                        ["_index",-1,[123]]
                    ];
                   
                    private _traitManagerDetails = _traitConfig >> "KISKA_traitManagerDetails";
                    if (isNull _traitConfig) exitWith {
                        [["_traitConfig at index -> ",_index," is null"],true] call KISKA_fnc_log;
                        nil
                    };
                    if (isNull _traitManagerDetails) exitWith {
                        [["_traitConfig >> KISKA_traitManagerDetails at index -> ",_index," is null"],true] call KISKA_fnc_log;
                        nil
                    };

                    private _traitText = getText(_traitManagerDetails >> "text");
                    if (_traitText isEqualTo "") then {
                        _traitText = configName _traitConfig;
                    };

                    [
                        _traitText,
                        getText(_traitManagerDetails >> "picture"),
                        getArray(_traitManagerDetails >> "pictureColor"),
                        getArray(_traitManagerDetails >> "selectedPictureColor"),
                        getText(_traitManagerDetails >> "tooltip")
                    ]
                }
            ],
            [
                "_fn_getSelectedItems",
                {
                    private _items = [];
                    (getAllUnitTraits player) apply {
                        _x params ["_traitName","_traitValue"];

                        if ((toUpperANSI _traitName) in NUMBER_TRAITS) then {continue};

                        private _traitConfig = [["KISKA_Traits",_traitConfig]] call KISKA_fnc_findConfigAny;
                        if (isNull _traitConfig) then {
                            [["_traitName ", _traitName," is not configured in KISKA_Traits"],false] call KISKA_fnc_log;
                            continue;
                        };
                        
                        private _traitManagerDetails = _traitConfig >> "KISKA_traitManagerDetails";
                        if (isNull _traitManagerDetails) then {
                            [["_traitName ", _traitName," is missing a KISKA_traitManagerDetails class"],false] call KISKA_fnc_log;
                            continue;
                        };

                        private _traitText = getText(_traitManagerDetails >> "text");
                        if (_traitText isEqualTo "") then {
                            _traitText = configName _traitConfig;
                        };

                        _items pushBack [
                            _traitText,
                            getText(_traitManagerDetails >> "picture"),
                            getArray(_traitManagerDetails >> "pictureColor"),
                            getArray(_traitManagerDetails >> "selectedPictureColor"),
                            getText(_traitManagerDetails >> "tooltip"),
                            toUpperANSI (configName _traitConfig)
                        ];
                    };

                    _items
                }
            ],
            [
                "_fn_onTake",
                {
                    params ["_storeId","_traitConfig","_poolItemId"];

                    private _traitManagerDetailsConfig = _traitConfig >> "KISKA_traitManagerDetails";
                    private _condition = getText(_traitManagerDetailsConfig >> "condition");
                    private _canTakeTrait = (_condition isEqualTo "") OR { [_traitManagerDetailsConfig] call (compile _condition) };
                    if (_canTakeTrait) exitWith {
                        private _trait = toUpperANSI (configName _traitConfig);
                        private _isCustomTrait = !(_trait in RESERVED_TRAITS);
                        player setUnitTrait [_trait,true,_isCustomTrait];
                        [_poolItemId] call KISKA_fnc_traitManager_removeFromPool;
                        nil
                    };

                    private _conditionMessage = getText(_traitManagerDetailsConfig >> "conditionMessage");
                    if (_conditionMessage isEqualTo "") then {
                        _conditionMessage = "You do not have permission for this support";
                    };

                    [_conditionMessage] call KISKA_fnc_errorNotification;
                }
            ],
            [
                "_fn_onStore",
                {
                    params ["","_trait"];
                    
                    private _isCustomTrait = !(_trait in RESERVED_TRAITS);
                    player setUnitTrait [_trait,false,_isCustomTrait];
                    _trait call KISKA_fnc_traitManager_addToPool;
                }
            ]
        ]
    }
] call KISKA_fnc_getOrDefaultSet;
_args call KISKA_fnc_simpleStore_open;

// check if player wants map to close when openning the manager
if (missionNamespace getVariable ["KISKA_CBA_traitManager_closeMap",true]) then {
    openMap false;
};


nil
