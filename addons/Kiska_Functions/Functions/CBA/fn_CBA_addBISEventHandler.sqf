/* ----------------------------------------------------------------------------
Function: KISKA_fnc_CBA_addBISEventHandler

Description:
    Copied function `CBA_fnc_addBISEventHandler` from CBA3.

    Adds an event handler with arguments. Additional arguments are passed as 
     `_thisArgs`. The ID is passed as `_thisID`. There is a slight overhead
     on the event call using this function.

Parameters:
    0: _subject <OBJECT, CONTROL, DISPLAY, or missionNamespace> - Thing to attach 
        event handler to.
    1: _thisType <STRING> - Event handler type.
    2: _thisFnc <CODE> - Event handler code.
    3: _arguments <ANY> Default: `[]` - Arguments to pass to event handler.

Returns:
    <STRING> - The ID of the event handler. Same as `_thisID`.

Example:
    (begin example)
        // one time fired event handler that removes itself
        private _id = [
            player, 
            "fired", 
            {
                systemChat _thisArgs; 
                player removeEventHandler ["fired", _thisID]
            }, 
            "bananas"
        ] call KISKA_fnc_CBA_addBISEventHandler;
    (end)

Author(s):
    commy2,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_CBA_addBISEventHandler";

params [
    ["_subject", objNull, [objNull, displayNull, controlNull, missionNamespace]],
    ["_thisType", "", [""]],
    ["_thisFnc", {}, [{}]],
    ["_thisArgs", []]
];

private _argsId = "KISKA_CBA_addBISEventHandler_argId" call KISKA_fnc_generateUniqueId;
private _subjectInEvent = ["_this select 0","missionNamespace"] select (_subject isEqualTo missionNamespace);
private _eventFunction = format ["
    ((%2) getVariable '%1') params ['_thisFnc','_thisArgs','_thisType','_thisId'];
    call _thisFnc;
",_argsId,_subjectInEvent];

private _id = call {
    if (_subject isEqualType objNull) exitWith {
        _subject addEventHandler [_thisType, _eventFunction];
    };

    if (_subject isEqualType displayNull) exitWith {
        _subject displayAddEventHandler [_thisType, _eventFunction];
    };

    if (_subject isEqualType controlNull) exitWith {
        _subject ctrlAddEventHandler [_thisType, _eventFunction];
    };

    if (_subject isEqualTo missionNamespace) exitWith {
        addMissionEventHandler [_thisType, _eventFunction];
    };
    -1
};
if (_id >= 0) then {
    _subject setVariable [_argsId, [_thisFnc,_thisArgs,_thisType,_id]];
};


_id
