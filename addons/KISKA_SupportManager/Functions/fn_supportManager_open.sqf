/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supportManager_open

Description:
    Opens KISKA Support Manager dialog.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_supportManager_open;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_supportManager_open";

if !(hasInterface) exitWith {
    ["Attempting to open support manager with no interface"] call KISKA_fnc_log;
    nil
};

disableSerialization;

private _args = [
    localNamespace,
    "KISKA_supportManager_openArgs",
    {
        createHashMapFromArray [
            ["_storeId","kiska-support-manager"],
            ["_storeSelectedItemsTitle","Current Supports"],
            ["_storePoolTitle","Support Pool"],
            ["_storeTitle","Support Manager"],
            [
                "_fn_poolItemToListboxItem",
                {
                    params [
                        ["_poolItem",[],[[]]],
                        ["_index",-1,[123]]
                    ];

                    _poolItem params [
                        ["_config",configNull,[configNull]], 
                        ["_useCount",-1,[123]]
                    ];
                    
                    private _supportManagerDetails = _config >> "KISKA_supportManagerDetails";
                    if ((isNull _config) OR (isNull _supportManagerDetails) ) then {
                        [["_config at index ->",_index," is null"],true] call KISKA_fnc_log;
                        nil
                    };

                    [
                        getText(_supportManagerDetails >> "text"),
                        getText(_supportManagerDetails >> "picture"),
                        getArray(_supportManagerDetails >> "pictureColor"),
                        getArray(_supportManagerDetails >> "selectedPictureColor"),
                        getText(_supportManagerDetails >> "tooltip"),
                        getText(_supportManagerDetails >> "data")
                    ]
                }
            ],
            [
                "_fn_getSelectedItems",
                {
                    private _usedIconColor = missionNamespace getVariable ["KISKA_CBA_supportManager_usedIconColor",[0.75,0,0,1]];
                    private _items = [];
                    (call KISKA_fnc_supports_getMap) apply {
                        _y params [
                            ["_supportConfig",configNull,[configNull]],
                            ["_numberOfUsesLeft",-1,[123]]
                        ];
                        
                        private _supportManagerDetails = _supportConfig >> "KISKA_supportManagerDetails";
                        private _supportId = _x;
                        if (isNull _supportManagerDetails) then {
                            [["_supportManagerDetails for id -> ",_supportId," is null"],true] call KISKA_fnc_log;
                            continue;
                        };

                        private ["_pictureColor","_selectedPictureColor"];
                        private _configuredNumberOfUses = getNumber(_supportConfig >> "KISKA_supportDetails" >> "numberOfUses");
                        if (_numberOfUsesLeft isNotEqualTo _configuredNumberOfUses) then {
                            _pictureColor = _usedIconColor;
                        } else {
                            pictureColor = getArray(_supportManagerDetails >> "pictureColor");
                            _selectedPictureColor = getArray(_supportManagerDetails >> "selectedPictureColor");
                        };

                        private _data = _supportId;
                        _items pushBack [
                            getText(_supportManagerDetails >> "text"),
                            getText(_supportManagerDetails >> "picture"),
                            _pictureColor,
                            _selectedPictureColor,
                            getText(_supportManagerDetails >> "tooltip"),
                            _data
                        ];
                    };

                    _items
                }
            ],
            [
                "_fn_onTake",
                {
                    params ["_storeId","_index"];

                    private _maxAllowedSupports = missionNamespace getVariable ["KISKA_CBA_supportManager_maxSupports",10];
                    private _hasMaxSupports = count (call KISKA_fnc_supports_getMap) isEqualTo _maxAllowedSupports;
                    if (_hasMaxSupports) exitWith { 
                        ["You already have the max supports possible"] call KISKA_fnc_errorNotification;
                        nil
                    };

                    if (_index < 0) exitWith {
                        ["Could not find selected index in pool list",true] call KISKA_fnc_log;
                        nil
                    };

                    private _poolItems = [_storeId] call KISKA_fnc_simpleStore_getPoolItems;
                    private _supportData = _poolItems select _index;
                    _supportData params [
                        "_supportConfig",
                        ["_numberOfUsesLeft",-1]
                    ];

                    private _supportManagerDetails = _supportConfig >> "KISKA_supportManagerDetails";
                    private _condition = getText(_supportManagerDetails >> "managerCondition");
                    private _canTakeSupport = (_condition isEqualTo "") OR { [_supportConfig] call (compile _condition) };
                    if (_canTakeSupport) exitWith {
                        [_supportConfig,_numberOfUsesLeft] call KISKA_fnc_supports_add;
                        _this remoteExecCall ["KISKA_fnc_simpleStore_removeItemFromPool",0,true];
                        nil
                    };

                    private _conditionMessage = getText(_supportConfig >> "conditionMessage");
                    if (_conditionMessage isEqualTo "") then {
                        _conditionMessage = "You do not have permission for this support";
                    };

                    [_conditionMessage] call KISKA_fnc_errorNotification;
                }
            ],
            [
                "_fn_onStore",
                {
                    params ["","","_data"];
                    private _supportId = _data;
                    private _supportConfigAndUses = [_supportId] call KISKA_fnc_supports_remove;
                    _supportConfigAndUses call KISKA_fnc_supportManager_addToPool;
                }
            ]
        ]
    }
] call KISKA_fnc_getOrDefaultSet;
_args call KISKA_fnc_simpleStore_open;

// check if player wants map to close when openning the manager
if (missionNamespace getVariable ["KISKA_CBA_supportManager_closeMap",true]) then {
    openMap false;
};


nil
