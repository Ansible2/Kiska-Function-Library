private _timelineMap = localNamespace getVariable "KISKA_timelineInfoMap";
if (isNil "_timelineMap") then {
	_timelineMap = createHashMap;
	localNamespace setVariable ["KISKA_timelineInfoMap",_timelineMap];
};


_timelineMap