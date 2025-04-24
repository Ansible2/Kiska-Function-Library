/* ----------------------------------------------------------------------------
Function: KISKA_fnc_commMenu_openTree

Description:
    Opens a command menu tree dynamically instead of needing to define sub menus.

    Such as one built with `KISKA_fnc_commMenu_build`.

Parameters:
    0: _menuPath <ARRAY> - The menu global variable paths (in order)
    1: _endExpression <STRING, CODE, or ARRAY> - The code to be executed at the end of the path.
        It receives all menu parameters in _this. (see KISKA_fnc_callBack)
    2: _exitExpression <STRING, CODE, or ARRAY> - The code to be executed in the event that
        the menu is closed by the player. It gets all added params up to that point in _this.
        (see KISKA_fnc_callBack)
    3: _finally <STRING, CODE, or ARRAY> - Code that will be executed finally regardless
        of whether the `_endExpression` or `_exitExpression` is triggered.
        It receives all menu parameters in _this. (see KISKA_fnc_callBack)

Returns:
    NOTHING

Examples:
    (begin example)
        // TODO: update examples
        [
            ["#USER:myMenu_1","#USER:myMenu_2"],
            "hint str _this"
        ] spawn KISKA_fnc_commMenu_openTree
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commMenu_openTree";

if (!hasInterface) exitWith {
    ["Can only run on machines with interface",false] call KISKA_fnc_log;
    nil
};

if (!canSuspend) exitWith {
    ["Must be run in scheduled, exiting to scheduled",true] call KISKA_fnc_log;
    _this spawn KISKA_fnc_commMenu_openTree;
};

params [
    ["_menuPath",[],[[]]],
    ["_endExpression","",["",{},[]]],
    ["_exitExpression","",["",{},[]]],
    ["_finally","",["",{},[]]]
];

// create a container for holding params from menus
localNamespace setVariable ["KISKA_commMenuTree_selectedValues",[]];

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

        _x params ["_optionTitle","_optionValue"];
        switch (typeName _optionValue) do
        {
            case "CODE": {
                _optionValue = ["call",_optionValue] joinString " ";
            };
            case "STRING": {
                _optionValue = [_optionValue] call KISKA_fnc_str;
            };
        };

        private _onOptionSelected = format ["(localNamespace getVariable 'KISKA_commMenuTree_selectedValues') pushBack (%1); localNamespace setVariable ['KISKA_commMenuTree_proceedToNextMenu',true];",_optionValue]
        _commandingMenu pushBack [
            _optionTitle,
            [_keyCode],
            "", // submenu
            -5 // execute command
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
    localNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",false];

    private _menuVariableName = ["KISKA_commMenuTree_subMenu"] call KISKA_fnc_generateUniqueId;
    // command menus must be saved to missionNamespace
    missionNamespace setVariable [_menuVariableName,_commandingMenu];
    _menuVariables pushBack _menuVariableName;
    private _commandingMenuName = ["#USER:",_menuVariableName] joinString "";
    showCommandingMenu _commandingMenuName;
    
    // wait for player to select and option from the current menu or for them to close the menu
    waitUntil {
        sleep 0.1;
        if (localNamespace getVariable "KISKA_commMenuTree_proceedToNextMenu") exitWith {true};
        _menuWasClosed = commandingMenu isEqualTo "";
        _menuWasClosed
    };
    if (_menuWasClosed) then { break };
};

private _params = localNamespace getVariable "KISKA_commMenuTree_selectedValues";
private _expression = [_endExpression,_exitExpression] select _menuWasClosed;
[_params, _expression] call KISKA_fnc_callBack;
[_params, _finally] call KISKA_fnc_callBack;


_menuVariables apply { missionNamespace setVariable [_x,nil] };
localNamespace setVariable ["KISKA_commMenuTree_selectedValues",nil];
localNamespace setVariable ["KISKA_commMenuTree_proceedToNextMenu",nil];


nil
