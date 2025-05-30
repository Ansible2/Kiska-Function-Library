/* ----------------------------------------------------------------------------
Function: KISKA_fnc_convoy_handleVehicleCantMove_default

Description:
	The default behaviour that happens when a vehicle in the convoy is disabled.

Parameters:
    0: _disabledVehicle <OBJECT> - The vehicle that has been disabled
    1: _convoyHashMap <HASHMAP> - The hashmap used for the convoy
    2: _convoyLead <OBJECT> - The lead vehicle of the convoy

Returns:
    NOTHING

Examples:
    (begin example)
        // SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_convoy_handleVehicleCantMove_default";

#define X_AREA_BUFFER 5
#define Y_AREA_BUFFER 10
#define MOVING_POSITIONS_BUFFER 2
#define LEFT_AZIMUTH_RELATIVE_NORTH 270
#define RIGHT_AZIMUTH_RELATIVE_NORTH 90

if (!isServer) exitWith {
    ["Must be executed on the server!",true] call KISKA_fnc_log;
    nil
};

params [
    ["_disabledVehicle",objNull,[objNull]],
    ["_convoyHashmap",nil],
    ["_convoyLead",objNull,[objNull]]
];

[[_disabledVehicle," can't move handler called"]] call KISKA_fnc_log;

/* ----------------------------------------------------------------------------
	Parameter check
---------------------------------------------------------------------------- */
if (isNull _disabledVehicle) exitWith {
    [
        [
            "null _disabledVehicle was passed, _convoyHashMap is: ",
            _convoyHashMap
        ],
        true
    ] call KISKA_fnc_log;

    nil
};

if (isNil "_convoyHashMap") exitWith {
    [   
        [
            "nil _convoyHashMap was passed, _disabledVehicle is: ",
            _disabledVehicle
        ],
        true
    ] call KISKA_fnc_log;

    nil
};

if (isNull _convoyLead) exitWith {
    [   
        [
            "null _convoyLead was passed, _disabledVehicle is: ",
            _disabledVehicle,
			" and _convoyHashMap is: ",
			_convoyHashMap
        ],
        true
    ] call KISKA_fnc_log;

    nil
};


if (_disabledVehicle isEqualTo _convoyLead) exitWith {
    [_disabledVehicle] call KISKA_fnc_convoy_removeVehicle;
    
    private _newConvoyLead = [_convoyHashMap] call KISKA_fnc_convoy_getConvoyLeader;
    if (isNull _newConvoyLead) then {
        [_convoyHashMap] call KISKA_fnc_convoy_delete;

    } else {
        // There's no consistent way to know what the former lead's intended path is, so stop
	    [_newConvoyLead] call KISKA_fnc_convoy_stopVehicle; 

    };
};



/* ----------------------------------------------------------------------------
	Function Defintions
---------------------------------------------------------------------------- */
private _getBlockedPositions = {
    params ["_vehicleBehind_drivePath","_disabledVehicle"];

    private _disabledVehicle_dimensions = [_disabledVehicle] call KISKA_fnc_getBoundingBoxDimensions;
    _disabledVehicle_dimensions params ["_disabledVehicle_width","_disabledVehicle_length","_disabledVehicle_height"];
    // Adding buffers to X and Y because points that are too close to the _disabledVehicle
    // will result in _vehicleBehind crashing into it.
    private _areaX = (_disabledVehicle_width / 2) + X_AREA_BUFFER;
    private _areaY = (_disabledVehicle_length / 2) + Y_AREA_BUFFER;
    private _areaZ = _disabledVehicle_height / 2;

    private _areaCenter = ASLToAGL (getPosASLVisual _disabledVehicle);
    private _lastIndex = (count _vehicleBehind_drivePath) - 1;

    private _blockedPositions_ATL = [];
    private _lastBlockedIndex = _lastIndex;
    {
        if (_forEachIndex isEqualTo _lastIndex) then { break };

        private _nextPointInPath = _vehicleBehind_drivePath select (_forEachIndex + 1);
        private _azimuthToNextPoint = _x getDir _nextPointInPath;

        private _currentPointIsInArea = _x inArea [
            _areaCenter,
            _areaX,
            _areaY,
            _azimuthToNextPoint,
            true,
            _areaZ
        ];

        private _aBlockedPositionWasAlreadyFound = _blockedPositions_ATL isNotEqualTo [];
        if (_aBlockedPositionWasAlreadyFound AND (!_currentPointIsInArea)) then { break };

        if (_currentPointIsInArea) then {
            _blockedPositions_ATL pushBack _x;
            _lastBlockedIndex = _forEachIndex;
        };
    } forEach _vehicleBehind_drivePath;


    [_blockedPositions_ATL, _lastBlockedIndex]
};


private _findClearSide = {
    params ["_blockedPositions_ATL","_disabledVehicle","_requiredSpace"];

    private _firstBlockedPosition = _blockedPositions_ATL select 0;

    private _blockedPositionsCount = count _blockedPositions_ATL;
    private _middleIndex = (round (_blockedPositionsCount / 2)) - 1;
    private _middleBlockedPosition = _blockedPositions_ATL select _middleIndex;

    private _lastBlockedPosition = _blockedPositions_ATL select -1;

    private _disabledVehicle_dir = getDirVisual _disabledVehicle;
    private _leftAzimuth = LEFT_AZIMUTH_RELATIVE_NORTH + _disabledVehicle_dir;
    private _rightAzimuth = RIGHT_AZIMUTH_RELATIVE_NORTH + _disabledVehicle_dir;

    private _clearSide = -1;
    private _clearLeft = true;
    private _clearRight = true;

    [
        _firstBlockedPosition,
        _middleBlockedPosition,
        _lastBlockedPosition
    ] apply {
        
        private _positionASL = ATLToASL _x;

        if (_clearLeft) then {
            private _positionLeftASL = AGLToASL (_positionASL getPos [_requiredSpace, _leftAzimuth]);
            private _objectsToDisabledVehiclesLeft = lineIntersectsObjs [
                _positionASL, 
                _positionLeftASL, 
                _disabledVehicle,
                objNull,
                true,
                32
            ];
            private _objectsAreOnTheLeft = _objectsToDisabledVehiclesLeft isNotEqualTo [];

            if (_objectsAreOnTheLeft) then { _clearLeft = false };
        };

        if (_clearRight) then {
            private _positionRightASL = AGLToASL (_positionASL getPos [_requiredSpace, _rightAzimuth]);
            private _objectsToDisabledVehiclesRight = lineIntersectsObjs [
                _positionASL, 
                _positionRightASL, 
                _disabledVehicle,
                objNull,
                true,
                32
            ];
            private _objectsAreOnTheRight = _objectsToDisabledVehiclesRight isNotEqualTo [];
            
            if (_objectsAreOnTheRight) then { _clearRight = false };
        };

        if ((!_clearLeft) AND (!_clearRight)) then { break };
    };

    if (_clearLeft) then {
        _clearSide = 0;
    } else {
        if (_clearRight) then { _clearSide = 1; };
    };


    _clearSide
};



/* ----------------------------------------------------------------------------
	Drive around disabled vehicles
---------------------------------------------------------------------------- */
private _disabledVehicle_index = [_disabledVehicle] call KISKA_fnc_convoy_getVehicleIndex;
private _vehicleBehind_index = _disabledVehicle_index + 1;
private _vehicleBehind = [_convoyHashMap, _vehicleBehind_index] call KISKA_fnc_convoy_getVehicleAtIndex;


[_disabledVehicle] call KISKA_fnc_convoy_removeVehicle;
if (isNull _vehicleBehind) exitWith {
    [["No _vehicleBehind found at index: ",_vehicleBehind_index]] call KISKA_fnc_log;
    nil
};


[_convoyHashMap] call KISKA_fnc_convoy_syncLatestDrivePoint;

private _vehicleBehind_currentDrivePath = [_vehicleBehind] call KISKA_fnc_convoy_getVehicleDrivePath;
private _blockedPositionsResult = [
    _vehicleBehind_currentDrivePath,
    _disabledVehicle
] call _getBlockedPositions;


private _positionsBlockedByDisabledVehicle_ATL = _blockedPositionsResult select 0;
if (_positionsBlockedByDisabledVehicle_ATL isEqualTo []) exitWith {
    [[
        "Did not find any blocked drive path positions: _vehicleBehind: ",
        _vehicleBehind,
        " _disabledVehicle: ",
        _disabledVehicle
    ]] call KISKA_fnc_log;
    nil
};


private _vehicleBehind_dimensions = [_vehicleBehind] call KISKA_fnc_getBoundingBoxDimensions;
private _vehicleBehind_width = _vehicleBehind_dimensions select 0;

private _disabledVehicle_dimensions = [_disabledVehicle] call KISKA_fnc_getBoundingBoxDimensions;
private _disabledVehicle_width = _disabledVehicle_dimensions select 0;
private _disabledVehicle_halfWidth = _disabledVehicle_width / 2;

private _requiredSpace = _vehicleBehind_width + _disabledVehicle_halfWidth;
private _clearSide = [
    _positionsBlockedByDisabledVehicle_ATL,
    _disabledVehicle,
    _requiredSpace
] call _findClearSide;


private _noSideIsClear = _clearSide isEqualTo -1;
if (_noSideIsClear) exitWith {
    [_vehicleBehind] call KISKA_fnc_convoy_stopVehicle;
    [_vehicleBehind, false] call KISKA_fnc_convoy_setVehicleDriveOnPath;

    [[
        "Could not find clear side for: _vehicleBehind: ",
        _vehicleBehind,
        " _disabledVehicle: ",
        _disabledVehicle
    ]] call KISKA_fnc_log;


    nil
};


private _distanceToMovePositions = _vehicleBehind_width + _disabledVehicle_halfWidth + MOVING_POSITIONS_BUFFER;
private _disabledVehicle_dir = getDirVisual _disabledVehicle;

private _movementDirectionBase = [LEFT_AZIMUTH_RELATIVE_NORTH, RIGHT_AZIMUTH_RELATIVE_NORTH] select _clearSide;
private _movePositionAzimuth = _movementDirectionBase + _disabledVehicle_dir;

private _firstPositionToMove = _positionsBlockedByDisabledVehicle_ATL select 0;
private _firstPositionAdjusted_AGL = _firstPositionToMove getPos [_distanceToMovePositions, _movePositionAzimuth];
private _firstPositionAdjusted_ATL = ASLToATL (AGLToASL _firstPositionAdjusted_AGL);
private _movedPositionVectorOffset = _firstPositionToMove vectorDiff _firstPositionAdjusted_ATL;

private _positionsBlockedByDisabledVehicle_ATL = _blockedPositionsResult select 0;
private _adjustedPositions = _positionsBlockedByDisabledVehicle_ATL apply {_x vectorDiff _movedPositionVectorOffset};

private _deletionRange = count _adjustedPositions;
private _vehicleBehind_lastIndexToBeAdjustedInPath = _blockedPositionsResult select 1;
private _lastIndexOffset = (count _vehicleBehind_currentDrivePath) - (_vehicleBehind_lastIndexToBeAdjustedInPath + 1);

private _convoyVehicles = [_convoyHashMap] call KISKA_fnc_convoy_getConvoyVehicles;
{
    // don't need to adjust convoy lead
    if (_forEachIndex isEqualTo 0) then { continue };

    private _vehiclesDrivePath = [_x] call KISKA_fnc_convoy_getVehicleDrivePath;
    private _vehiclesDrivePathCount = count _vehiclesDrivePath;
    private _lastIndexToModify = _vehiclesDrivePathCount - _lastIndexOffset;
    
    [
        _x,
        _lastIndexToModify,
        _adjustedPositions
    ] call KISKA_fnc_convoy_modifyVehicleDrivePath;
} forEach _convoyVehicles;



/* ----------------------------------------------------------------------------
	Handle units that dismount disabled vehicle

    // units may dismount in the path of the vehicle behind attempting to drive past
    // the driving AI will try to avoid driving over friendlies and will
    /// run into the back of the disabled vehicle in some cases
---------------------------------------------------------------------------- */
private _disabledVehicle_boundingBox = 0 boundingBoxReal _disabledVehicle;
private _disabledVehicle_boundingBoxMins = _disabledVehicle_boundingBox select 0;
private _disabledVehicle_boundingBoxMaxes = _disabledVehicle_boundingBox select 1;

private _rightSide = _disabledVehicle_boundingBoxMaxes select 0;
private _leftSide = _disabledVehicle_boundingBoxMins select 0;

// Want to put units on the NOT clear side because that is where the vehicle behind will not drive
private _xOffset = [
    _rightSide,
    _leftSide
] select _clearSide;

private _relativeDismountPosition = [
    _xOffset,
    _disabledVehicle_boundingBoxMins select 1,
    _disabledVehicle_boundingBoxMins select 2
];

[
    {
        params ["_disabledVehicle"];
        (speed _disabledVehicle) isEqualTo 0;
    },
    {
        params ["_disabledVehicle","_relativeDismountPosition"];

        if (isNull _disabledVehicle) exitWith {};

        private _unitsToAdjustDismountPosition = crew _disabledVehicle;
        private _timeVehicleWasDiscoveredDisabled = time;
        private _unitGetOutTimeHashMap = _disabledVehicle getVariable "KISKA_convoy_unitGetOutTimesHashMap";
        if !(isNil "_unitGetOutTimeHashMap") then {
            _unitGetOutTimeHashMap apply {  
                private _timeSinceUnitGotOut = _timeVehicleWasDiscoveredDisabled - _y;
                private _unitGotOutMoreThanASecondAgo = _timeSinceUnitGotOut >= 1;
                if (_unitGotOutMoreThanASecondAgo) then { continue };

                private _unit = [
                    _x
                ] call KISKA_fnc_hashmap_getObjectOrGroupFromRealKey;
                
                if !(alive _unit) then { continue };

                _unitsToAdjustDismountPosition pushBackUnique _unit;
            };
        };

        private _dismountPosition = _disabledVehicle modelToWorldVisualWorld _relativeDismountPosition;
        _unitsToAdjustDismountPosition apply {
            _x setPosWorld _dismountPosition
        };
    },
    [_disabledVehicle,_relativeDismountPosition],
    10
] call CBA_fnc_waitUntilAndExecute;


nil
