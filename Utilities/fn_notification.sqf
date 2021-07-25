/* ----------------------------------------------------------------------------
Function: KISKA_fnc_notification

Description:
	Prints a simple CBA Notify notification on screen.

Parameters:
	0: _message : <STRING or ARRAY> - The second line of the notification.
        Formatted the same as the parameters for CBA_fnc_notify:
            _lineN - N-th content line (may be passed directly if only 1 line is required). <ARRAY>
                _text  - Text to display or path to .paa or .jpg image (may be passed directly if only text is required). <STRING, NUMBER>
                _size  - Text or image size multiplier. (optional, default: 1) <NUMBER>
                _color - RGB or RGBA color (range 0-1). (optional, default: [1, 1, 1, 1]) <ARRAY>

Returns:
	NOTHING

Examples:
    (begin example)
        ["You made and error"] call KISKA_fnc_notification;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_notification";

params [
	["_message","",["",[]]]
];

[["Notification:",1.1,[0.21,0.71,0.21,1]],_message,false] call CBA_fnc_notify;


nil
