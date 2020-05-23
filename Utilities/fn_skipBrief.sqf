if (hasInterface) then {
    if (!isNumber (missionConfigFile >> "briefing")) exitWith {};
    if (getNumber (missionConfigFile >> "briefing") == 1) exitWith {};
    0 = [] spawn {
        waitUntil {
			private "_display";
			if (isDedicated) then {_display = 53} else {_display = 52};
            if (getClientState == "BRIEFING READ") exitWith {true};
            if (!isNull findDisplay _display) exitWith {
                ctrlActivate (findDisplay _display displayCtrl 1);
                findDisplay _display closeDisplay 1;
                true
            };
            false
        };
    };
};