#define FUNCTION_INDEX 0
#define DELAY_INDEX 1
#define ARGS_INDEX 4
#define HANDLE_INDEX 5

if (localNamespace getVariable ["KISKA_CBA_initializedPerFrameHandler",false]) exitWith {};

KISKA_CBA_perFrameHandlerArray = [];
KISKA_CBA_perFrameHandlersToRemove = [];
KISKA_CBA_lastTickTime = diag_tickTime;

KISKA_CBA_waitAndExecArray = [];
KISKA_CBA_waitAndExecArrayIsSorted = false;
KISKA_CBA_nextFrameNo = diag_frameNo + 1;
KISKA_CBA_nextFrameBufferA = [];
KISKA_CBA_nextFrameBufferB = [];
KISKA_CBA_waitUntilAndExecArray = [];


[
    "KISKA_fnc_CBA_onFrame", 
    {
        scriptName "KISKA_fnc_CBA_onFrame";

        private _tickTime = diag_tickTime;
        call KISKA_fnc_CBA_missionTimePFH;

        // frame number does not match expected; can happen between pre and postInit, save-game load and on closing map
        // need to manually set nextFrameNo, so new items get added to buffer B and are not executed this frame
        if (diag_frameNo != KISKA_CBA_nextFrameNo) then {
            KISKA_CBA_nextFrameNo = diag_frameNo;
        };

        // Execute per frame handlers
        KISKA_CBA_perFrameHandlerArray apply {
            private _delta = _x select 2;
            if (diag_tickTime > _delta) then {
                _x set [2, _delta + (_x select DELAY_INDEX)];
                [
                    (_x select ARGS_INDEX), 
                    (_x select HANDLE_INDEX)
                ] call (_x select FUNCTION_INDEX);
            };
        };


        // Execute wait and execute functions
        // Sort the queue if necessary
        if (!KISKA_CBA_waitAndExecArrayIsSorted) then {
            KISKA_CBA_waitAndExecArray sort true;
            KISKA_CBA_waitAndExecArrayIsSorted = true;
        };
        private _delete = false;
        {
            if (_x select 0 > KISKA_CBA_missionTime) exitWith {};

            (_x select 2) call (_x select 1);

            // Mark the element for deletion so it's not executed ever again
            KISKA_CBA_waitAndExecArray set [_forEachIndex, objNull];
            _delete = true;
        } forEach KISKA_CBA_waitAndExecArray;
        if (_delete) then {
            KISKA_CBA_waitAndExecArray = KISKA_CBA_waitAndExecArray - [objNull];
            _delete = false;
        };


        // Execute the exec next frame functions
        KISKA_CBA_nextFrameBufferA apply {
            (_x select 0) call (_x select 1);
        };
        // Swap double-buffer:
        KISKA_CBA_nextFrameBufferA = KISKA_CBA_nextFrameBufferB;
        KISKA_CBA_nextFrameBufferB = [];
        KISKA_CBA_nextFrameNo = diag_frameNo + 1;


        // Execute the waitUntilAndExec functions:
        {
            // if condition is satisfied call statement
            if ((_x select 2) call (_x select 0)) then {
                (_x select 2) call (_x select 1);

                // Mark the element for deletion so it's not executed ever again
                KISKA_CBA_waitUntilAndExecArray set [_forEachIndex, objNull];
                _delete = true;
            };
        } forEach KISKA_CBA_waitUntilAndExecArray;
        if (_delete) then {
            KISKA_CBA_waitUntilAndExecArray = KISKA_CBA_waitUntilAndExecArray - [objNull];
        };
    }
] call KISKA_fnc_CBA_compileFinal;

// fix for save games. subtract last tickTime from ETA of all PFHs after mission was loaded
addMissionEventHandler ["Loaded", {
    private _tickTime = diag_tickTime;

    KISKA_CBA_perFrameHandlerArray apply {
        _x set [2, (_x select 2) - KISKA_CBA_lastTickTime + _tickTime];
    };

    KISKA_CBA_lastTickTime = _tickTime;
}];

KISKA_CBA_missionTime = 0;
KISKA_CBA_lastTime = time;

// increase KISKA_CBA_missionTime variable every frame

if !(isMultiplayer) exitWith {
    [
        "KISKA_fnc_CBA_missionTimePFH", 
        {
            scriptName "KISKA_fnc_CBA_missionTimePFH_sp";
            if (time isNotEqualTo KISKA_CBA_lastTime) then {
                KISKA_CBA_missionTime = KISKA_CBA_missionTime + (_tickTime - KISKA_CBA_lastTickTime) * accTime;
                KISKA_CBA_lastTime = time; // used to detect paused game
            };

            KISKA_CBA_lastTickTime = _tickTime;
        }
    ] call KISKA_fnc_CBA_compileFinal;
};

// no accTime in MP
if (isServer) exitWith {
    [
        "KISKA_fnc_CBA_missionTimePFH", 
        {
            scriptName "KISKA_fnc_CBA_missionTimePFH_server";
            if (time isNotEqualTo KISKA_CBA_lastTime) then {
                KISKA_CBA_missionTime = KISKA_CBA_missionTime + (_tickTime - KISKA_CBA_lastTickTime);
                KISKA_CBA_lastTime = time; // used to detect paused game
            };

            KISKA_CBA_lastTickTime = _tickTime;
        }
    ] call KISKA_fnc_CBA_compileFinal;

    addMissionEventHandler ["PlayerConnected", {
        (_this select 4) publicVariableClient "KISKA_CBA_missionTime";
    }];
};


KISKA_CBA_missionTime = -1;
// multiplayer client
0 spawn {
    isNil {
        private _fnc_init = {
            KISKA_CBA_missionTime = _this select 1;

            KISKA_CBA_lastTickTime = diag_tickTime; // prevent time skip on clients

            ["KISKA_fnc_CBA_missionTimePFH", {
                scriptName "KISKA_fnc_CBA_missionTimePFH_client";
                if (time isNotEqualTo KISKA_CBA_lastTime) then {
                    KISKA_CBA_missionTime = KISKA_CBA_missionTime + (_tickTime - KISKA_CBA_lastTickTime);
                    KISKA_CBA_lastTime = time; // used to detect paused game
                };

                KISKA_CBA_lastTickTime = _tickTime;
            }] call KISKA_fnc_CBA_compileFinal;

        };

        "KISKA_CBA_missionTime" addPublicVariableEventHandler _fnc_init;

        if (KISKA_CBA_missionTime isNotEqualTo -1) then {
            // WARNING_1("KISKA_CBA_missionTime packet arrived prematurely. Installing update handler manually. Transferred value was %1.",KISKA_CBA_missionTime);
            [nil, KISKA_CBA_missionTime] call _fnc_init;
        };
    };
};

localNamespace setVariable ["KISKA_CBA_initializedPerFrameHandler",true];

nil
