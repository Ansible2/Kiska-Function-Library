/* ----------------------------------------------------------------------------
Function: KISKA_fnc_randomIndex

Description:
	Returns a random index of an array ~2x faster than BIS_fnc_randomIndex;

Parameters:
	0: _radio <ARRAY> - The array to find a random index of.

Returns:
	<NUMBER> - The random index

Examples:
    (begin example)
		private _randomIndex = [[1,2,3]] call KISKA_fnc_randomIndex;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_randomIndex";

params [
	["_array",[],[[]]]
];


floor (random (count _array))