/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_unconsciousIsCaptive

Description:
	Hooks into the ace_unconscious event

Parameters:
	NONE

Returns:
	NOTHING

Examples:
    (begin example)
		POST-INIT Function
    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_unconsciousIsCaptive";

if (!hasInterface) exitWith {};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};

if !(["ace_medical"] call KISKA_fnc_isPatchLoaded) exitWith {
	["ACE medical is not loaded, will not add event...",false] call KISKA_fnc_log;
	nil
};

if (missionNamespace getVariable ["KISKA_ACE_addedUnconsciousPlayerEvent",false]) exitWith {};

[
    "ace_unconscious",
    {
        params ["_unit","_unconscious"];
        if (_unit isEqualTo player) then {

            if (_unconscious) then {
                ["Player ace_unconscious event fired."] call KISKA_fnc_log;
                private _makeCaptive = missionNamespace getVariable ["KISKA_CBA_ACE_unconciousPlayerIsCaptive",true];
                private _wasCaptiveBefore = captive _unit;
                private _wasMadeCaptive =  false;

                if (!_wasCaptiveBefore AND {_makeCaptive}) then {
                    ["Player was not captive beforehand, will be made captive"] call KISKA_fnc_log;
                    _wasMadeCaptive = true;
                    _unit setCaptive true;
                };

                missionNamespace setVariable ["KISKA_ACE_wasMadeCaptive",_wasMadeCaptive];
                //missionNamespace setVariable ["KISKA_ACE_wasCaptiveBefore",_wasCaptiveBefore];

            } else { // if waking up
                ["Player is waking from unconscious state"] call KISKA_fnc_log;
                private _wasMadeCaptive = missionNamespace getVariable ["KISKA_ACE_wasMadeCaptive",false];
                if (captive _unit) then {
                    ["Player is a captive"] call KISKA_fnc_log;
                    if (_wasMadeCaptive) then {
                        ["Player was previosuly made captive, captive will be turned off..."] call KISKA_fnc_log;
                        _unit setCaptive false;
                    };
                };

                missionNamespace setVariable ["KISKA_ACE_wasMadeCaptive",false];

            };

        };
    }
] call CBA_fnc_addEventhandler;

missionNamespace setVariable ["KISKA_ACE_addedUnconsciousPlayerEvent",true];


nil
