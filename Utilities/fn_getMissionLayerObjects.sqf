/* ----------------------------------------------------------------------------
Function: KISKA_fnc_getMissionLayerObjects

Description:
	Simply returns the objects of a mission layer.

Parameters:
	0: _layer : <STRING or NUMBER> - The name or ID of the mission layer

Returns:
	<ARRAY> - The layer's objects

Examples:
    (begin example)
		_objects = ["myLayer"] call KISKA_fnc_getMissionLayerObjects;
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_getMissionLayerObjects";

params [
    ["_layer","",[123,""]]
];

private _entities = getMissionLayerEntities _layer;

if (_entities isEqualTo []) exitWith {[]};


_entities select 0
