/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ACE_unconsciousIsCaptive

Description:
    Adds a CBA event that hooks into when a player becomes unconcious, making them
     turn captive in order to keep the AI from shooting downed players.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        POST-INIT Function
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ACE_unconsciousIsCaptive";

if (!hasInterface) exitWith {};

if (!canSuspend) exitWith {
    [] spawn KISKA_fnc_ACE_unconsciousIsCaptive;
    nil
};

if (call KISKA_fnc_isMainMenu) exitWith {
    ["Main menu detected, will not init",false] call KISKA_fnc_log;
    nil
};


if !(["ace_medical"] call KISKA_fnc_isPatchLoaded) exitWith {
    ["ACE medical is not loaded, will not add event...",false] call KISKA_fnc_log;
    nil
};


if (localNamespace getVariable ["KISKA_ACE_addedUnconsciousPlayerEvent",false]) exitWith {};


[
    "ace_unconscious",
    {
        params ["_unit","_unconscious"];
        if (_unit isEqualTo player) then {

            if (_unconscious) then {
                ["Player ace_unconscious event fired."] call KISKA_fnc_log;
                private _makeCaptive = localNamespace getVariable ["KISKA_CBA_ACE_unconciousPlayerIsCaptive",true];
                private _wasCaptiveBefore = captive _unit;
                private _wasMadeCaptive =  false;

                if (!_wasCaptiveBefore AND {_makeCaptive}) then {
                    ["Player was not captive beforehand, will be made captive"] call KISKA_fnc_log;
                    _wasMadeCaptive = true;
                    _unit setCaptive true;
                };

                localNamespace setVariable ["KISKA_ACE_wasMadeCaptive",_wasMadeCaptive];

            } else { // if waking up
                ["Player is waking from unconscious state"] call KISKA_fnc_log;

                if (captive _unit) then {
                    ["Player is a captive"] call KISKA_fnc_log;

                    if (localNamespace getVariable ["KISKA_ACE_wasMadeCaptive",false]) then {
                        ["Player was previosuly made captive, captive will be turned off..."] call KISKA_fnc_log;
                        _unit setCaptive false;
                    };

                };

                localNamespace setVariable ["KISKA_ACE_wasMadeCaptive",false];

            };

        };
    }
] call CBA_fnc_addEventhandler;


waitUntil {
    sleep 1;
    !isNull player;
};


player addEventHandler ["Respawn",{
    params ["_unit"];
    
    if (captive _unit) then {
        [
            "Player is a captive",
            missionNamespace getVariable ["KISKA_CBA_logWithError",false],
            true,
            false,
            "KISKA_unconsciousACEEvent_respawnHandler"
        ] call KISKA_fnc_log;

        if (localNamespace getVariable ["KISKA_ACE_wasMadeCaptive",false]) then {
            [
                "Player was previosuly made captive, captive will be turned off...",
                missionNamespace getVariable ["KISKA_CBA_logWithError",false],
                true,
                false,
                "KISKA_unconsciousACEEvent_respawnHandler"
            ] call KISKA_fnc_log;

            _unit setCaptive false;
        };

    };

    localNamespace setVariable ["KISKA_ACE_wasMadeCaptive",false];
}];


localNamespace setVariable ["KISKA_ACE_addedUnconsciousPlayerEvent",true];


nil
