
/* ----------------------------------------------------------------------------
Function: KISKA_fnc_assignUnitLoadout

Description:
    Searches a config class for an array that matches the units classname.
    This array is filled with potential loadout arrays for the unit.

Parameters:
    0: _config <CONFIG> - The config to search for the array of loadouts in
    1: _units <ARRAY, GROUP, or OBJECT> - The unit(s) to apply the function to

Returns:
    NOTHING

Examples:
    (begin example)
        [
            missionConfigFile >> "KISKA_loadouts" >> ONL,
            unit1
        ] call KISKA_fnc_assignUnitLoadout
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */

scriptName "KISKA_fnc_assignUnitLoadout";

params [
    ["_configPath",configNull,[configNull]],
    ["_units",[],[[],objNull,grpNull]]
];


// verify params
if (isNull _configPath) exitWith {
    ["A null config was passed",true] call KISKA_fnc_log;
    nil
};
if (_units isEqualTo []) exitWith {
    ["Empty array for _units",true] call KISKA_fnc_log;
    nil
};
if (_units isEqualTypeAny [objNull,grpNull] AND {isNull _units}) exitWith {
    ["_units is null",true] call KISKA_fnc_log;
    nil
};


// organize other data types into array
if (_units isEqualType objNull) then {
    _units = [_units];
};
if (_units isEqualType grpNull) then {
    _units = units _units;
};


// assign loadouts
private _loadoutHashmap = createHashMap;
_units apply {
    private _unit = _x;

    if (alive _unit AND {!isNull _unit}) then {

        private "_loadoutsForClass";
        private _unitClass = typeOf _unit;
        if (_unitClass in _loadoutHashmap) then {
            _loadoutsForClass = _loadoutHashmap get _unitClass;

        } else {
            _loadoutsForClass = getArray(_configPath >> _unitClass);
            _loadoutHashmap set [_unitClass,_loadoutsForClass];

        };


        if (_loadoutsForClass isEqualTo []) then {
            [["Class ", _unitClass, " does not have any configed loadouts in directory: ",_configPath],true] call KISKA_fnc_log;

        } else {
            private _newLoadout = selectRandom _loadoutsForClass;
            private _oldLoadout = getUnitLoadout _unit;
            // making sure changes took over network
            [
                {
                    params ["_unit","_newLoadout","_oldLoadout","","_loopCount"];

                    // units don't like being not simmed on dedicated servers while changing loadouts this, so do it temporarily if needed
                    if !(simulationEnabled _unit) then {
                        _this set [3,true];
                        [_unit,true] remoteExecCall ["enableSimulationGlobal",2];
                    };
                    
                    _unit setUnitLoadout _newLoadout;

                    if (_loopCount > 0 AND _loopCount < 3) then {
                        [["looping for ",_unit," _loopCount ",_loopCount]] call KISKA_fnc_log;
                        [["unit loadout: ",endl,getUnitLoadout _unit]] call KISKA_fnc_log;
                        [["_newLoadout: ",endl,_newLoadout]] call KISKA_fnc_log;
                    };

                    private _currentLoadout = getUnitLoadout _unit;
                    if (_currentLoadout isEqualTo _newLoadout) exitWith {true};

                    if (_currentLoadout isEqualTo _oldLoadout) exitWith {
                        _this set [4,_loopCount + 1];
                        false
                    };
                    
                    private _loadoutsMatch = true;
                    {
                        if (_forEachIndex > 5) then {break};

                        private _currentLoadoutClassToCompare = _x select 0;
                        private _newLoadoutClassToCompare = (_newLoadout select _foreachIndex) select 0;
                        if (_currentLoadoutClassToCompare != _newLoadoutClassToCompare) then {
                            _loadoutsMatch = false;
                            break
                        };
                    } forEach _currentLoadout;
                    
                    if (_loadoutsMatch) exitWith {
                        ["found match after deep compare"] call KISKA_fnc_log;
                        [["unit loadout: ",endl,getUnitLoadout _unit]] call KISKA_fnc_log;
                        [["_newLoadout: ",endl,_newLoadout]] call KISKA_fnc_log;
                        true
                    };

                    _this set [4,_loopCount + 1];

                    false
                },
                {
                    params ["_unit","_newLoadout","","_simulationWasDisabled"];
                    // return units to being unsimmed if they were before
                    if (_simulationWasDisabled) then {
                        [_unit,false] remoteExecCall ["enableSimulationGlobal",2];
                    };
                },
                0.5,
                [_unit,_newLoadout,_oldLoadout,false,0]
            ] call KISKA_fnc_waitUntil;

        };

    };
};


nil
