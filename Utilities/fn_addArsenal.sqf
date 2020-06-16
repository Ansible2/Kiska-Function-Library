/* ----------------------------------------------------------------------------
Function: KISKA_fnc_addArsenal

Description:
	Adds both BIS and ACE arsenals to several or a single object

Parameters:

	0: _arsenals <ARRAY or OBJECT> - An array of objects to add arsenals to

Returns:
	NOTHING

Examples:
    (begin example)

		[[arsenal1, arsenal2]] call KISKA_fnc_addArsenal;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if !(isServer) exitWIth {};

params [
    ["_arsenals",[],[[],objNull]]
];

if (_arsenals isEqualTo [] OR {(_arsenals isEqualType objNull) AND {isNull _arsenals}}) exitWIth {};

if !(_arsenals isequalType []) then {
	_arsenals = [_arsenals];
};

private _aceLoaded = ["ace_arsenal"] call KISKA_fnc_isPatchLoaded;

_arsenals apply {
	
	if (_aceLoaded) then {
		[_x, true, true] call ace_Arsenal_FNC_InitBox;
		["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal;		
	} else {
		["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal;
	};

};