/* ----------------------------------------------------------------------------
Function: KISKA_fnc_exportSpawnPositions

Description:
    Takes a layer of objects and produces an array of arrays that are their 3d
     ATL position and current direction ([0,0,0,0]).

    Can also convert the arrays to config compatible format.

    This will copy its output to the clipboard if run on the server;

Parameters:
    0: _layer <STRING or NUMBER> - The name of the layer or if in 3den, its layer id
    1: _convertToConfig <BOOL> - Change all square brackets ([]) to curly ({})

Returns:
    <STRING> - The converted Array

Examples:
    (begin example)
        ["someLayer",true] call KISKA_fnc_exportSpawnPositions;
    (end)

Authors:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_exportSpawnPositions";

params [
    ["_layer","",["",123]],
    ["_convertToConfig",true,[true]]
];

private _objects = [];
if (is3den) then {
    _objects = get3DENLayerEntities _layer;

} else {
    _objects = (getMissionLayerEntities _layer) select 0;

};


if (count _objects < 1) exitWith {
    [["No objects were found in layer: ",_layer],true] call KISKA_fnc_log;
    ""
};


private _returnArray = [];
_objects apply {
    private _objectArray = getPosATL _x;
    _objectArray pushBack (getDir _x);

    _returnArray pushBack _objectArray;
};

private _string = _returnArray joinString ("," + endl);
_string = _string trim [",",2];

if (_convertToConfig) then {
    _string = [_string,"[","{"] call CBA_fnc_replace;
    _string = [_string,"]","}"] call CBA_fnc_replace;
};
copyToClipboard _string;


_string
