scriptName "KISKA_fnc_trackArea_startLoop";

#define PER_FRAME_HANDLER_KEY "perFrameHandlerId"

params [
    ["_trackAreaId","",[""]]
];

private _containerMap = [
    localNamespace,
    "KISKA_trackArea_containerMap",
    {createHashMap}
] call KISKA_fnc_getOrDefaultSet;

private _trackAreaInfoMap = _containerMap get _trackAreaId;
if (isNil "_trackAreaInfoMap") exitWith {
    [["_trackAreaId ",_trackAreaId," does not exist"],true] call KISKA_fnc_log;
    nil
};

if (PER_FRAME_HANDLER_KEY in _trackAreaInfoMap) exitWith {
    [["_trackAreaId ",_trackAreaId," is already started"]] call KISKA_fnc_log;
    nil
};

private _perFrameHandlerId = [
    {
        params ["_args"];
        _args params ["_trackAreaId","_trackAreaInfoMap"];

        private _allTrackedObjects = _trackAreaInfoMap get "trackedObjects";
        if (_allTrackedObjects isEqualTo []) exitWith {};

        private _inAreaObjects = [];
        private _outOfBoundsObjects = _allTrackedObjects;
        (_trackAreaInfoMap get "areas") apply {
            if (_outOfBoundsObjects isEqualTo []) then { break };

            private _objectsInThisArea = _outOfBoundsObjects inAreaArray _x;
            _inAreaObjects append _objectsInThisArea;
            _outOfBoundsObjects = _outOfBoundsObjects - _inAreaObjects;
        };
        private _previouslyOutOfBoundsObjects = _trackAreaInfoMap getOrDefaultCall ["outOfBoundsObjects",{[]},true];
        private _objectsThatHaveLeft = _outOfBoundsObjects - _previouslyOutOfBoundsObjects;
        private _objectsThatHaveReturned = _inAreaObjects arrayIntersect _previouslyOutOfBoundsObjects;
        _trackAreaInfoMap set ["outOfBoundsObjects",_outOfBoundsObjects];

        if (_objectsThatHaveLeft isNotEqualTo []) then {
            private _onExited = _trackAreaInfoMap get "onExited";
            [[_objectsThatHaveLeft,_trackAreaId],_onExited] call KISKA_fnc_callBack;
        };

        if (_objectsThatHaveReturned isNotEqualTo []) then {
            private _onReturned = _trackAreaInfoMap get "onReturned";
            [[_objectsThatHaveReturned,_trackAreaId],_onReturned] call KISKA_fnc_callBack;
        };
    },
    _trackAreaInfoMap getOrDefaultCall ["checkFrequency",{0},true],
    [_trackAreaId,_trackAreaInfoMap]
] call KISKA_fnc_CBA_addPerFrameHandler;


nil