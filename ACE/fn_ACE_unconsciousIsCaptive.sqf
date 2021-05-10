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
            private _makeCaptive = missionNamespace getVariable ["KISKA_CBA_ACE_unconciousPlayerIsCaptive",true];
            if (_unconscious) then {
                if (!(captive _unit) AND {_makeCaptive}) then {
                    _unit setCaptive true;
                };

            } else { // if waking up
                if (captive _unit AND {_makeCaptive}) then {
                    _unit setCaptive false;
                };

            };
        };
    }
] call CBA_fnc_addEventhandler;

missionNamespace setVariable ["KISKA_ACE_addedUnconsciousPlayerEvent",true];


nil
