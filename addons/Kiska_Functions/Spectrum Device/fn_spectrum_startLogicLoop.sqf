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
		// This inits when the player has a spectrum device equipped
		// The display and its controls remain until mission end
		!(isNull (uiNamespace getVariable ["rscweaponspectrumanalyzergeneric",displayNull]))
	},
	{
		private _spectrumDisplay = uiNamespace getVariable ["rscweaponspectrumanalyzergeneric",displayNull];
		private _spectrumCtrl = _spectrumDisplay displayCtrl SPECTRUM_GENERAL_CTRL_IDC;
		private _spectrumGraphCtrl = _spectrumCtrl getVariable ["bin_focus",controlNull];

		_spectrumGraphCtrl ctrlAddEventHandler ["committed",{
			if (alive player) then {
				private _signalMap = call KISKA_fnc_spectrum_getSignalMap;
				private _generatedSignalValues = [];
				private _playerPositionASL = getPosASL player;
				private _minDecibels = call KISKA_fnc_spectrum_getMinDecibels;
				private _maxDecibels = call KISKA_fnc_spectrum_getMaxDecibels;
				private _decibelRange = (abs _maxDecibels) - (abs _minDecibels);
				
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

					private _baseSignalLevel = _y get DECIBEL_KEY;
					private _absoluteBaseSignalLevel = abs _baseSignalLevel; 
					private _baseSignalIsNegative = _baseSignalLevel isNotEqualTo _absoluteBaseSignalLevel;

					private _distancePercentageScale = (1 - (_playerDistanceToSource / _maxDistance)) * DISTANCE_RATIO;
					private _directionPercentageScale = (1 - (_relativeDirScale / 90)) * (1 - DISTANCE_RATIO);

					private _relativeSignalLevel = _absoluteBaseSignalLevel * (_distancePercentageScale + _directionPercentageScale);

					if (_baseSignalIsNegative) then {
						private _before = _relativeSignalLevel;
						_relativeSignalLevel = _minDecibels + _relativeSignalLevel;
						hint str [_absoluteBaseSignalLevel,_before,_relativeSignalLevel];
					};
					_generatedSignalValues pushBack _relativeSignalLevel;
				};

				missionNamespace setVariable ["#EM_Values", _generatedSignalValues];
			};
		}];
	},
	3
] call KISKA_fnc_waitUntil;


nil
