if (localNamespace getVariable ["KISKA_CBA_initializedPerFrameHandlerEvent",false]) exitWith {};

addMissionEventHandler ["EachFrame", KISKA_fnc_CBA_onFrame];

localNamespace setVariable ["KISKA_CBA_initializedPerFrameHandlerEvent",true];
