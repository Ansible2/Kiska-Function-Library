/* ----------------------------------------------------------------------------
Function: KISKA_fnc_generateUniqueId

Description:
    Creates a unique identifier with a given tag. 
    
    The id format is: *tag*_*clientOwner*_*increment* which as an example could be
     `KISKA_uid_0_0` as the first unique id made in a single player scenario.

Parameters:
    0: _tag <STRING> - The tag to assign to the uid

Returns:
    <STRING> - the unique identifier

Examples:
    (begin example)
        call KISKA_fnc_generateUniqueId;
        // KISKA_uid_0_0
    (end)
    
    (begin example)
        ["MYTAG"] call KISKA_fnc_generateUniqueId;
        // MYTAG_uid_0_0
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_generateUniqueId";

params [
    ["_tag","KISKA",[""]]
];

if (_tag isEqualTo "") then {
    _tag = "KISKA";
};

// in an effort to avoid confusion between when using KISKA_fnc_idCounter
// using the "uid" tagged on as the counter for consistent counts 
// in case someone uses that tag with KISKA_fnc_idCounter outside of this
// function
private _idPrepend = [_tag,"uid",clientOwner] joinString "_";
private _idNumber = [_idPrepend] call KISKA_fnc_idCounter;


[_idPrepend,_idNumber] joinString "_"
