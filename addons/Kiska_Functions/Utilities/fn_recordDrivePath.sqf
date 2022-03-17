/* ----------------------------------------------------------------------------
Function: KISKA_fnc_recordDrivePath

Description:
	Records an array of positons and speeds for use with setDriveOnPath command.

Parameters:
	0: _unit <OBJECT> - The unit to record
    1: _frequency <NUMBER> - How often to record, 0 for every frame
    2: _recordSpeed <BOOL> - Should the speed of the _unit be recorded to

Returns:
	NOTHING

Examples:
    (begin example)
		[
            objectParent player,
            0.25
		] call KISKA_fnc_recordDrivePath
    (end)

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_recordDrivePath";

params [
    ["_unit",objNull,[objNull]],
    ["_frequency",0.5,[123]],
    ["_recordSpeed",true,[false]]
];

if (isNull _unit) exitWith {
    ["_unit is null!",true] call KISKA_fnc_log;
    nil
};

private _path = [];
private _id = [
    {
        params [
            "_args",
            "_id"
        ];

        _args params [
            "_unit",
            "_path",
            "_recordSpeed"
        ];
        if (isNull _unit) then {
            ["Recording failed, _unit is null"] call KISKA_fnc_errorNotification;
            [_id] call CBA_fnc_removePerFrameHandler;

            // remove display event
            private _keyDownEventId = localNamespace getVariable ["KISKA_drivePathRecordingDisplayEvent_id", -1];
            localNamespace setVariable ["KISKA_drivePathRecordingDisplayEvent_id", nil];
            (findDisplay 46) displayRemoveEventHandler ["KeyDown", _keyDownEventId];

        } else {
            if (_unit getVariable ["KISKA_fnc_recordDrivePath_" + str _id, true]) then {
                private _array = ASLToAGL (getPosASL _unit);

                if (_recordSpeed) then {
                    _array pushBack ((speed _unit) / 3.6);
                };

                _path pushBack _array;

            } else {
                copyToClipboard (str _path);
                [_id] call CBA_fnc_removePerFrameHandler;

            };
        };


    },
    _frequency,
    [_unit,_path,_recordSpeed]
] call CBA_fnc_addPerFrameHandler;
["Started unit recording, press escape key to stop"] call KISKA_fnc_notification;

disableSerialization;
private _display = findDisplay 46;
// Stops Capture after pressing the ESC key
private _displayId = [
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
localNamespace setVariable ["KISKA_drivePathRecordingDisplayEvent_id", _displayId];


nil
