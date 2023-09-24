/* ----------------------------------------------------------------------------
Function: KISKA_fnc_spectrum_startLogicLoop

Description:
    Handles starting a (sort of infinite) loop that will update a player's
     spectrum device readings.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        call KISKA_fnc_spectrum_startLogicLoop;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_spectrum_startLogicLoop";

#define SPECTRUM_WEAPON_CLASS "hgun_esd_01"
#define SPECTRUM_GENERAL_CTRL_IDC 1999
#define FREQUENCY_KEY "_frequency"
#define ORIGIN_KEY "_origin"
#define DECIBEL_KEY "_decibels"
#define DISTANCE_KEY "_maxDistance"
#define DISTANCE_RATIO 0.75

// This function is less than ideal, but blame Bohemia's pretty abysmal implementation
//  of the scripting interfaces with the spectrum analyzer.
// And no, `destroy` and `unload` eventhandlers can not be used to mitigate this.

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
            {
                params ["","_perframeId"];
                if (!(alive player) OR !(SPECTRUM_WEAPON_CLASS in (toLowerANSI (currentWeapon player)))) exitWith {
                    [_perframeId] call CBA_fnc_removePerFrameHandler;
                    localNamespace setVariable ["KISKA_spectrum_updateLoopRunning",false];
                    call KISKA_fnc_spectrum_startLogicLoop;
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

// TODO: vertical direction?
// _vector = player weapondirection currentweapon player;
// _dirH = (_vector # 0) atan2 (_vector # 1);
// _dirV = asin (_vector # 2);

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
            0.25
        ] call CBA_fnc_addPerFrameHandler;

    },
    3
] call KISKA_fnc_waitUntil;


nil
