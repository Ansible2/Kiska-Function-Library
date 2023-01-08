/* ----------------------------------------------------------------------------
Function: KISKA_fnc_SR_startRecording

Description:
    Starts KISKA Speech recognition's extension's listening to the the user's
     microphone to complete a speech recognition event.

Parameters:
    0: _timelineId <NUMBER> - The id of the timeline to stop

Returns:
    <BOOL> - true if recording started, false if recording is currently happening

Examples:
    (begin example)
        private _started = call KISKA_fnc_SR_startRecording;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_SR_startRecording";

private _return = ["kiska_ext_sr_startrecording"] call KISKA_fnc_SR_callExtension;

if (_return == "true") exitWith {true};
false