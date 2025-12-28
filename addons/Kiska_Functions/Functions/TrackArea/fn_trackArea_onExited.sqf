/* ----------------------------------------------------------------------------
Function: KISKA_fnc_trackArea_onExited

Description:
    Gets or sets the code that is executed when at least one tracked object leaves 
     the tracked area.

Parameters:
    0: _trackAreaId <STRING> - The area tracker ID.
    1: _onExited <CODE, STRING, [ANY,CODE], [ANY,STRING]> - Code that will be executed
        once it is discovered that one or more tracked objects has left the area.
        (see `KISKA_fnc_callBack` for type examples).

        Parameters:
        - 0: <OBJECT[]> - The objects that have left the area.
        - 1: <STRING> - The area tracker ID.

Returns:
    <CODE, STRING, [ANY,CODE], [ANY,STRING], or NIL> - The code to run for the event,
        or `nil` if the area tracker does not exist for the given id.

Examples:
    (begin example)
        private _newEventCode = [
            "KISKA_trackArea_uid_0_0",
            { 
                params ["_objectsThatHaveLeft","_trackerId"];
            }
        ] call KISKA_fnc_trackArea_onExited;
    (end)

    (begin example)
        private _currentEventCode = [
            "KISKA_trackArea_uid_0_0",
        ] call KISKA_fnc_trackArea_onExited;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_trackArea_onExited";

params [
    ["_trackAreaId","",[""]],
    ["_onExited",nil,[{},[],""]]
];

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;
private _trackAreaInfoMap = _containerMap get _trackAreaId;

if (isNil "_trackAreaInfoMap") exitWith {
    [["_trackAreaId ",_trackAreaId," does not exist"],true] call KISKA_fnc_log;
    nil
};
if (isNil "_onExited") exitWith { _trackAreaInfoMap get "onExited" };


_trackAreaInfoMap set ["onExited",_onExited];
_onExited
