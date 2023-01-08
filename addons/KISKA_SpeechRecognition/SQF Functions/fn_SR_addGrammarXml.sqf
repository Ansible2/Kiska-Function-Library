/* ----------------------------------------------------------------------------
Function: KISKA_fnc_SR_addGrammarXml

Description:
    Adds an xml grammar file to the speech recognizer.

Parameters:
    0: _name <STRING> - The name of the grammar to add
    1: _xml <STRING> - The xml in string format

Returns:
    <BOOL> - true if will be added, false if cannot be added

Examples:
    (begin example)
        ["name",loadFile "myXmlFile.xml"] call KISKA_fnc_SR_addGrammarXml;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_SR_addGrammarXml";

params [
    ["_name","",[""]],
    ["_xml","",[""]]
];

if (_name isEqualTo "") exitWith {
    ["Grammar must have a unique name!",true] call KISKA_fnc_log;
};
if (_xml isEqualTo "") exitWith {
    ["Invalid xml passed!",true] call KISKA_fnc_log;
};

private _return = ["kiska_ext_sr_addgrammarxml",_this] call KISKA_fnc_SR_callExtension;


if (_return == "true") exitWith {true};
false