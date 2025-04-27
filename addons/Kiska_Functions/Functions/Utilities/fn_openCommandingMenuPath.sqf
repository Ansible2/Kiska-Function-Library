/* ----------------------------------------------------------------------------
Function: KISKA_fnc_openCommandingMenuPath

Description:
    Opens a command menu path dynamically instead of needing to define sub menus.

Parameters:
    0: _menuPath <ARRAY> - An array of menus to open in their given sequence

        A menu is an array of several components:
        - 0. _menuTitle : <STRING> - the title of the commanding menu (appears above the menu).
        - 1. _menuOptions : <[STRING,ANY][]> - an array of `[option label, value]` that will
            appear in this given order in the commanding menu. If the value is CODE, it will 
            be called if and when selecting the given option.

    1: _endExpression <STRING, CODE, or ARRAY> - The code to be executed at the end of the path.
        It receives all menu parameters in _this. (see `KISKA_fnc_callBack`)
    2: _exitExpression <STRING, CODE, or ARRAY> - The code to be executed in the event that
        the menu is closed by the player. It gets all added params up to that point in _this.
        (see `KISKA_fnc_callBack`)
    3: _finally <STRING, CODE, or ARRAY> - Code that will be executed finally regardless
        of whether the `_endExpression` or `_exitExpression` is triggered.
        It receives all menu parameters in _this. (see `KISKA_fnc_callBack`)

Returns:
    NOTHING

Examples:
    (begin example)
        [
            [
                [
                    "First Menu",
                    ["option 1","FirstMenu_1"],
                    ["option 2","FirstMenu_2"]
                ],
                [
                    "Second Menu",
                    ["option 1","SecondMenu_1"],
                    ["option 2","SecondMenu_2"]
                ]
            ],
            {
                hint str ["Reached end of menus with values",_this];
            },
            {
                hint str ["Exited menu prematurely with values",_this];
            }
        ] spawn KISKA_fnc_openCommandingMenuPath
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_openCommandingMenuPath";

#define MAX_KEYS 9

if (!hasInterface) exitWith {
    ["Can only run on machines with interface",false] call KISKA_fnc_log;
    nil
};

if (!canSuspend) exitWith {
    ["Must be run in scheduled, exiting to scheduled",true] call KISKA_fnc_log;
    _this spawn KISKA_fnc_openCommandingMenuPath;
};

params [
    ["_menuPath",[],[[]]],
    ["_endExpression",{},["",{},[]]],
    ["_exitExpression",{},["",{},[]]],
    ["_finally",{},["",{},[]]]
];

// create a container for holding params from menus
localNamespace setVariable ["KISKA_commandingMenu_selectedValues",[]];

private _menuWasClosed = false;
private _menuVariables = [];
_menuPath apply {
    _x params [
        ["_menuTitle","Undefined Title",[""]],
        ["_menuOptions",[],[[]]]
    ];

    private _commandingMenu = [
        [_menuTitle,false]
    ];
    {
        if (_forEachIndex <= MAX_KEYS) then {
            // key codes are offset by 2 (1 on the number bar is key code 2)
            _keyCode = _forEachIndex + 2;
        } else {
            _keyCode = 0;
        };

        _x params [
            ["_optionTitle","",[""]],
            "_optionValue"
        ];
        switch (typeName _optionValue) do
        {
            case "CODE": {
                _optionValue = ["call",_optionValue] joinString " ";
            };
            case "STRING": {
                _optionValue = [_optionValue] call KISKA_fnc_str;
            };
        };

        private _onOptionSelected = format ["(localNamespace getVariable 'KISKA_commandingMenu_selectedValues') pushBack (%1); localNamespace setVariable ['KISKA_commandingMenu_openNextMenu',true];",_optionValue];
        _commandingMenu pushBack [
            _optionTitle,
            [_keyCode],
            "", // submenu
            -5, // execute command
            [["expression", _onOptionSelected]],
            "1", // is active
            "1" // is visible
        ];
    } forEach _menuOptions;

    private _menuHasSingleOption = (count _commandingMenu) isEqualTo 2;
    if (_menuHasSingleOption) then {
        private _singleMenuOption = _menuOptions select 1;
        private _menuOptionExpression = _singleMenuOption select 4;
        private _expressionCode = (_menuOptionExpression select 0) select 1;
        [] call (compile _expressionCode);
        continue;
    };

    // keeps track of whether or not to open the next menu
    localNamespace setVariable ["KISKA_commandingMenu_openNextMenu",false];

    private _menuVariableName = ["KISKA_commandingMenu_subMenu"] call KISKA_fnc_generateUniqueId;
    // command menus must be saved to missionNamespace
    missionNamespace setVariable [_menuVariableName,_commandingMenu];
    _menuVariables pushBack _menuVariableName;
    private _commandingMenuName = ["#USER:",_menuVariableName] joinString "";
    showCommandingMenu _commandingMenuName;
    
    // wait for player to select and option from the current menu or for them to close the menu
    waitUntil {
        sleep 0.1;
        if (localNamespace getVariable "KISKA_commandingMenu_openNextMenu") exitWith {true};
        _menuWasClosed = commandingMenu isEqualTo "";
        _menuWasClosed
    };
    if (_menuWasClosed) then { break };
};

private _params = localNamespace getVariable "KISKA_commandingMenu_selectedValues";
private _expression = [_endExpression,_exitExpression] select _menuWasClosed;
[_params, _expression] call KISKA_fnc_callBack;
[_params, _finally] call KISKA_fnc_callBack;


_menuVariables apply { missionNamespace setVariable [_x,nil] };
localNamespace setVariable ["KISKA_commandingMenu_selectedValues",nil];
localNamespace setVariable ["KISKA_commandingMenu_openNextMenu",nil];


nil
