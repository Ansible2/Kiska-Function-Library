/* ----------------------------------------------------------------------------
Function: KISKA_fnc_compass_parseConfig

Description:
    Returns an array formatted for CBA settings menu lists.

Parameters:
	0: _config <CONFIG> - The config to parse
    1: _varName <STRING> - uiNamespace variable to save to and to check

Returns:
	<ARRAY> - An array formatted as [[title name strings],[image path strings],0]

Examples:
    (begin example)
		private _array = [
            configFile >> "KISKA_compass" >> "compass",
            "KISKA_compass_configs"
        ] call KISKA_fnc_compass_parseConfig;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_compass_parseConfig";

params ["_config","_varName"];

private _return = uiNamespace getVariable [_varName,nil];
if (!isNil "_return") exitWith {
    _return
};

if (isNull _config) exitWith {
    ["_config is null",true] call KISKA_fnc_log;
    nil
};


private _nameArray = [];
private _imagePathArray = [];
("true" configClasses _config) apply {
    private _title = getText(_x >> "title");
    private _imagePath = getText(_x >> "image");

    if ((_title isNotEqualTo "") AND (_imagePath isNotEqualTo "")) then {
        _nameArray pushBack _title;
        _imagePathArray pushBack _imagePath;
    };
};

_return = [_imagePathArray,_nameArray,0];
uiNamespace setVariable [_varName,_return];


_return
