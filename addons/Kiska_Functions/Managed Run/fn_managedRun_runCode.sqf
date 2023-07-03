/* ----------------------------------------------------------------------------
Function: KISKA_fnc_managedRun_runCode

Description:
    

Parameters:
    0: _nameOfCode : <STRING> - The name of the code to run previously added with
		KISKA_fnc_managedRun_updateCode
    1: _args : <ARRAY> - An array of arguments that will be `_this` within the
		code to run
    2: _idNamespace : <GROUP, OBJECT, LOCATION, NAMESPACE, CONTROL, DISPLAY, TASK, TEAM-MEMBER> - 
		The namespace to restrict the id to. This is used to manage runs on two different
		 objects for example
    3: _idToRunAgainst : <NUMBER> - The id the code is restricted to run against
    4: _isScheduled : <BOOL> - Whether the code will be executed in a scheduled environment

Returns:
    <NUMBER> - The id of the run made

Examples:
    (begin example)
        // add code for given id
		[
			"KISKA_manage_allowDamage",
			{
				params ["_unit","_isDamageAllowed"];
				_unit allowDamage _isDamageAllowed;
			}
		] call KISKA_fnc_managedRun_updateCode;

		// initial run
        private _idOfRun = [
			"KISKA_manage_allowDamage",
			[player, false],
			player
		] call KISKA_fnc_managedRun_runCode;

		// try to change in the future
		[_idOfRun] spawn {
			params ["_idOfRun"];
			sleep 3;
	        // does nothing because id was overwritten in the meantime
			[
				"KISKA_manage_allowDamage",
				[player, true],
				player
			] call KISKA_fnc_managedRun_runCode;

			hint str (isDamageAllowed player) // false
		};

        private _idOfADifferentRun = [
			"KISKA_manage_allowDamage",
			[player, false],
			player
		] call KISKA_fnc_managedRun_runCode;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_managedRun_runCode";

params [
    ["_nameOfCode","",[""]],
    ["_args",[],[[]]],
	["_idNamespace",localNamespace,[grpNull,objNull,locationNull,controlNull,displayNull,taskNull,teamMemberNull,localNamespace]],
    ["_idToRunAgainst",-1,[123]],
	["_isScheduled",false,[true]]
];

private _codeMap = localNamespace getVariable ["KISKA_managedRun_codeMap",-1];
if (_codeMap isEqualTo -1) exitWith { 
	[
		[
			"KISKA_managedRun_codeMap is not defined, did you add ",
			_nameOfCode,
			" with KISKA_fnc_managedRun_updateCode?"
		],
		true
	] call KISKA_fnc_log;
	-1 
};

if !(_nameOfCode in _codeMap) exitWith { 
	[
		[
			"KISKA_managedRun_codeMap does not contain key for ",
			_nameOfCode,
			". Did you add ",
			_nameOfCode,
			" with KISKA_fnc_managedRun_updateCode?"
		],
		true
	] call KISKA_fnc_log;
	-1 
};


private _isNewManagement = _idToRunAgainst isEqualTo -1;
private _currentAdjustmentId = _idNamespace getVariable ["KISKA_managedRun_latestId",-1];
private _idToAdjustIsCurrent = _currentAdjustmentId isEqualTo _idToRunAgainst;

if ((!_isNewManagement) AND (!_idToAdjustIsCurrent)) exitWith { -1 };

private _idOfRun = _idToRunAgainst;
if (!_idToAdjustIsCurrent) then {
    // assign new adjusment id as latest
    _idOfRun = ["KISKA_managedRun_latestId",_idNamespace] call KISKA_fnc_idCounter;
};

private _code = _codeMap get _nameOfCode;
[_args,_code,_isScheduled] call KISKA_fnc_callBack;


_idOfRun
