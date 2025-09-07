/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_startSignalLoop

Description:
    Handles starting a (sort of infinite) loop that will update a player's
     spectrum device readings.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_spectrum_startSignalLoop;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_startSignalLoop";

#define SPECTRUM_WEAPON_CLASS "hgun_esd_01"
#define SPECTRUM_GENERAL_CTRL_IDC 1999
#define FREQUENCY_KEY "_frequency"
#define ORIGIN_KEY "_origin"
#define DECIBEL_KEY "_decibels"
#define DISTANCE_KEY "_maxDistance"
#define DISTANCE_RATIO 0.65
#define LOOP_TIME_WHEN_SEARCHING_FOR_DEVICE 3
#define UPDATE_SIGNAL_EVERY 0.25

// This function is less than ideal, but blame Bohemia's pretty abysmal implementation
//  of the scripting interfaces with the spectrum analyzer.
// And no, `destroy` and `unload` eventhandlers can not be used to mitigate this on the controls/displays for the thing.

if (
    !(hasInterface) OR 
    (localNamespace getVariable ["KISKA_spectrum_updateLoopRunning",false])
) exitWith {};

localNamespace setVariable ["KISKA_spectrum_updateLoopRunning",true];

[
    {
        SPECTRUM_WEAPON_CLASS in (toLowerANSI (currentWeapon player))
    },
    {	


        [
            ["KISKA_spectrum_staged_transmit",KISKA_fnc_spectrum_setTransmitting],
            ["KISKA_spectrum_staged_selectionWidth",KISKA_fnc_spectrum_setSelectionWidth],
            ["KISKA_spectrum_staged_minFreq",KISKA_fnc_spectrum_setMinFrequency],
            ["KISKA_spectrum_staged_minDecibels",KISKA_fnc_spectrum_setMinDecibels],
            ["KISKA_spectrum_staged_maxFreq",KISKA_fnc_spectrum_setMaxFrequency],
            ["KISKA_spectrum_staged_maxDecibels",KISKA_fnc_spectrum_setMaxDecibels]
        ] apply {
            _x params ["_varName","_setter"];
            private _stagedValue = localNamespace getVariable [_varName,""];
            if (_stagedValue isEqualTo "") then { continue };

            localNamespace setVariable [_varName,nil];
            [_stagedValue] call _setter;
        };
 

        [
            {
                private _hasSpectrumDeviceEquipped = SPECTRUM_WEAPON_CLASS in (toLowerANSI (currentWeapon player));
                if (!(alive player) OR !_hasSpectrumDeviceEquipped) exitWith {
                    private _perframeId = _this select 1;
                    [_perframeId] call KISKA_fnc_CBA_removePerFrameHandler;
                    localNamespace setVariable ["KISKA_spectrum_updateLoopRunning",false];
                    call KISKA_fnc_spectrum_startSignalLoop;
                };
                
                private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
                private _generatedSignalValues = [];
                private _playerPositionASL = getPosASL player;
                private _minDecibels = call KISKA_fnc_spectrum_getMinDecibels;
                private _maxDecibels = call KISKA_fnc_spectrum_getMaxDecibels;
                private _overallSignalRatioForDirection = 1 - DISTANCE_RATIO;
                
                _signalMap apply {
                    private _maxDistance = _y get DISTANCE_KEY;
                    private _origin = _y get ORIGIN_KEY;
                    private _playerDistanceToSource = _playerPositionASL vectorDistance _origin;
                    if (_playerDistanceToSource > _maxDistance) then {
                        continue;
                    };

                    private _relativeDir = player getRelDir _origin;
                    if ((_relativeDir > 90) AND (_relativeDir < 270)) then { continue };
                    
                    private "_relativeDirScale";
                    if (_relativeDir <= 90) then {
                        _relativeDirScale = _relativeDir
                    } else {
                        _relativeDirScale = 360 - _relativeDir;
                    };

                    private _frequency = _y get FREQUENCY_KEY;
                    _generatedSignalValues pushBack _frequency;

                    // Get the signal percentage of max based upon player's relative direction and distance
                    private _percentageOfDistance = (1 - (_playerDistanceToSource / _maxDistance));
                    private _percentageOfDirection = (1 - (_relativeDirScale / 90));
                    
                    private _percentageOfDistanceRatioed = _percentageOfDistance * DISTANCE_RATIO;
                    private _percentageOfDirectionRatioed = _percentageOfDirection * _overallSignalRatioForDirection;

                    private _currentSignalPercentage = _percentageOfDistanceRatioed + _percentageOfDirectionRatioed;
                    
                    private _baseSignalLevel = _y get DECIBEL_KEY;
                    private _signalDecibelRange = _baseSignalLevel - _minDecibels;
                    private _relativeSignalLevel = (_signalDecibelRange * _currentSignalPercentage) + _minDecibels;

                    _generatedSignalValues pushBack _relativeSignalLevel;
                };

                missionNamespace setVariable ["#EM_Values", _generatedSignalValues];
            },
            UPDATE_SIGNAL_EVERY
        ] call CBA_fnc_addPerFrameHandler;
    },
    LOOP_TIME_WHEN_SEARCHING_FOR_DEVICE
] call KISKA_fnc_waitUntil;


nil


