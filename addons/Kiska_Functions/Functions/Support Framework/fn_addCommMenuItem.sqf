/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addCommMenuItem

Description:
    This is an alias of sorts of Bohemia's BIS_fnc_addCommMenuItem.
    It is mostly made with the purpose of using default values and specifically
     passing a -1 by default to _expressionArguments.

    Also adds entries to the KISKA_playerSupportMap which is used for
     keeping track of the number of uses left on a support if they are passed between
     the Support Manager.
    
Parameters:
    0: _owner <OBJECT> - The person to add the support to
    1: _itemConfig <CONFIG> - The config as defined in the CfgCommunicationMenu
    2: _textArguements <ANY> - Any arguements to pass to the text displayed in the menu
    3: _expressionArguments <ANY> - Any arguements to pass to the expression
    4: _notification <STRING> - The class of notification to display when added
    5: _addToSupportMap <BOOL> - Add to KISKA_playerSupportMap

Returns:
    <NUMBER> - The comm menu ID

Examples:
    (begin example)
        _id = [player,"myClass"] call KISKA_fnc_addCommMenuItem;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_addCommMenuItem";

params [
    ["_owner",objNull,[objNull]],
    // TODO: ensure all calls pass item config instead of className
    ["_itemConfig",configNull,[configNull]],
    ["_textArguements",""],
    ["_expressionArguments",-1,[]],
    ["_notification","",[""]],
    ["_addToSupportMap",true,[true]]
];

private _id = [
    _owner,
    configName _itemConfig,
    _textArguements,
    _expressionArguments,
    _notification
] call BIS_fnc_addCommMenuItem;

if (!(isNil "_id") AND _addToSupportMap) then {
    private _supportMap = call KISKA_fnc_getPlayerSupportMap;
    _supportMap set [_id,[_itemConfig,_expressionArguments]];
};


_id
