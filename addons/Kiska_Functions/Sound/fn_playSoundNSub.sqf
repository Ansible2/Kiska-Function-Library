params [
	["_speaker","",[""]],
	["_subs","",[""]],
	["_sound","",[""]],
	["_sleep",0.2,[1]]
];
[_speaker,_subs] spawn BIS_fnc_showSubtitle;
[
	{
		playSound [_this select 0, true];
	},
	[_sound],
	_sleep
] call CBA_fnc_waitAndExecute;