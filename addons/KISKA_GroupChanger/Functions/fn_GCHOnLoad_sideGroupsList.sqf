/* ----------------------------------------------------------------------------
Function: KISKA_fnc_GCHOnLoad_sideGroupsList

Description:
    Adds eventhandler to the listbox.

Parameters:
    0: _control <CONTROL> - The control for the list box

Returns:
    NOTHING

Examples:
    (begin example)
        [_control] call KISKA_fnc_GCHOnLoad_sideGroupsList;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
disableSerialization;
scriptName "KISKA_fnc_GCHOnLoad_sideGroupsList";

if !(hasInterface) exitWith {};

params ["_control"];

// add event handler
_control ctrlAddEventHandler ["LBSelChanged",{
    params ["_control", "_selectedIndex"];

    // get selected group
    private _sideGroups = localNamespace getVariable "KISKA_GCH_sideGroupsArray";
    private _sideGroupsIndex = _control lbValue _selectedIndex;
    private _selectedGroup = _sideGroups select _sideGroupsIndex;
    localNamespace setVariable ["KISKA_GCH_selectedGroup",_selectedGroup];

    [true,true,true,true,true] call KISKA_fnc_GCH_updateCurrentGroupSection;
}];


[true] call KISKA_fnc_GCH_updateSideGroupsList;


nil
