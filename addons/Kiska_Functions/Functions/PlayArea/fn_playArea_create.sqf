/* ----------------------------------------------------------------------------
Function: KISKA_fnc_playArea_create

Description:
    Defines a play area that the local player will have to remain in.

Parameters:
    0: _area <TRIGGER | LOCATION | MARKER | ARRAY> - See `inAreaArray` right arg.
    1: _onExited <CODE, STRING, [ANY,CODE], [ANY,STRING]> - Code that will be executed
        once it is discovered that the player has left the area.
        (see `KISKA_fnc_callBack` for type examples).

        Parameters:
        - 0: <NUMBER[]> - The indexes of positions or objects within the area.

    2: _onReturned <CODE, STRING, [ANY,CODE], [ANY,STRING]> - Code that will be 
        executed once it is discovered that the player has returned to the area.
        (see `KISKA_fnc_callBack` for type examples).

Returns:
    <STRING> - The ID of the given play area.

Examples:
    (begin example)

    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_playArea_create";

if !(hasInterface) exitWith { "" };

params [
    ["_area",[],[[],objNull,locationNull,""]],
    ["_onExited",{},[[],{},""]],
    ["_onReturned",{},[[],{},""]],
    ["_start",false,[true]]
];

private _overallMap = [
    localNamespace,
    "KISKA_playArea_areaMaps",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _id = ["KISKA_playArea"] call KISKA_fnc_generateUniqueId;
_overallMap set [
    _id,
    createHashMapFromArray [
        ["area",_area],
        ["onExited",_onExited],
        ["onReturned",_onReturned],
        ["inAreaIndexes"]
    ]
];


_id
