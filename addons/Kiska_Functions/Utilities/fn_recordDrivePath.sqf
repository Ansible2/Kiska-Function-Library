/* ----------------------------------------------------------------------------
Function: KISKA_fnc_recordDrivePath

Description:
	Records an array of positons and speeds for use with setDriveOnPath command.

Parameters:
	0: _unit <OBJECT> - The unit to record
    1: _frequency <NUMBER> - How often to record, 0 for every frame

Returns:
	NOTHING

Examples:
    (begin example)
		[

		] call KISKA_fnc_recordDrivePath
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_commandMenuTree";

params [
    ["_unit",objNull,[objNull]],
    ["_frequency",1,[123]]
];

private _path = [];
private _id = [
    {
        params [
            "_args",
            "_id"
        ];

        _args params [
            "_unit",
            "_path"
        ];

        if (
            !(isNull _unit) AND
            {_unit getVariable ["KISKA_fnc_recordDrivePath_" + str _id, true]}
        ) then {
            private _array = ASLToAGL (getPosASL _unit);
            _array pushBack ((speed _unit) / 3.6);
            _path pushBack _array;

        } else {
            copyToClipboard (str _path);
            [_id] call CBA_fnc_removePerFrameHandler;

        };
    },
    _frequency,
    [_unit,_path]
] call CBA_fnc_addPerFrameHandler;
["Started unit recording, press escape key to stop"] call KISKA_fnc_notification;

disableSerialization;
private _display = findDisplay 46;
// Stops Capture after pressing the ESC key
[
    _display,
    "KeyDown",
    {
        _thisArgs params [
            "_id",
            "_unit"
        ];

        if ((_this select 1) == 1) then {
            _unit setVariable ["KISKA_fnc_recordDrivePath_" + str _id, false];
            ["Stopped unit recording, data copied to clipboard"] call KISKA_fnc_notification;

            (_this select 0) displayRemoveEventHandler [_thisType, _thisID];
        };
    },
    [_id,_unit]
] call CBA_fnc_addBISEventHandler;


nil
