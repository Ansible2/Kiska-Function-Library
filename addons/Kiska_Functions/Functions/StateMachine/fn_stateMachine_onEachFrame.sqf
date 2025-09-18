/* ----------------------------------------------------------------------------
Function: KISKA_fnc_stateMachine_onEachFrame

Description:
    Copied function `CBA_stateMachine_fnc_clockwork` from CBA.

    Loops through all stateMachines within in a given frame and executes their
     state.

Parameters:
    NONE

Returns:
    NOTHING

Example:
    (begin example)
        SHOULD NOT BE CALLED DIRECTLY
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_stateMachine_onEachFrame";

#define LOG_PERFORMANCE \
    private _perfRunTime = diag_tickTime - _perfStartTime; \
    (KISKA_stateMachine_performanceCounters get _guid) pushBack _perfRunTime;

KISKA_stateMachines apply {
    #ifdef STATEMACHINE_PERFORMANCE_COUNTERS
        private _perfStartTime = diag_tickTime;
    #endif

    private _stateMachineMap = _x;

    private _list = _stateMachineMap get "list";
    private _skipNull = _stateMachineMap get "skipNull";
    private _currentIndex = _stateMachineMap get "currentListIndex";
    private _listCount = count _list;
    if (_skipNull) then {
        while {
            (_currentIndex < _listCount) AND 
            { isNull (_list select _currentIndex) }
        } do {
            _currentIndex = _currentIndex + 1;
        };
    };

    // When the list was iterated through, jump back to start and update it
    if (_currentIndex >= _listCount) then {
        private _updateCode = _stateMachineMap get "updateCode";
        _currentIndex = 0;
        if (_updateCode isNotEqualTo {}) then {
            _list = [] call _updateCode;

            if (_skipNull) then {
                _list = _list select {!(isNull _x)};
            };

            _stateMachineMap set ["list", _list];
        };
    };

    private _guid = _stateMachineMap get "guid";
    if (_list isEqualTo []) then {
        #ifdef STATEMACHINE_PERFORMANCE_COUNTERS
            LOG_PERFORMANCE
        #endif
        continue;
    };

    _stateMachineMap set ["currentListIndex", _currentIndex + 1];

    private _currentListItem = _list select _currentIndex;
    private _currentItemStateVar = ["KISKA_stateMachine_state",_guid] joinString "-";
    private _thisState = _currentListItem getVariable _currentItemStateVar;

    if (isNil "_thisState") then {
        // Item is new and gets set to the intial state, onStateEntered
        // function of initial state gets executed as well.
        private _initialState = _stateMachineMap get "initialState";
        _currentListItem setVariable [_currentItemStateVar, _initialState];
        if (isNil "_initialState") then {
            #ifdef STATEMACHINE_PERFORMANCE_COUNTERS
                LOG_PERFORMANCE
            #endif
            continue;
        };

        _thisState = _initialState;
        _currentListItem call (_stateMachineMap get ([_thisState,"onStateEntered"] joinString "_"));
    };

    _currentListItem call (_stateMachineMap get ([_thisState,"whileStateActive"] joinString "_"));

    private _thisOrigin = _thisState; // the state we're coming from
    (_stateMachineMap get ([_thisState,"transitions"] joinString "_")) apply {
        _x params [
            "_thisTransition", // the current transition we're in
            "_condition", 
            "_thisTarget", // the state we're transitioning to
            "_onTransition"
        ];
        
        // Transition conditions, onTransition, onStateLeaving and
        // onStateEntered functions can use all _this* vars and _stateMachineMap

        // Note: onTransition and onStateLeaving functions can change
        //       the transition target by overwriting the passed
        //       _thisTarget variable.
        // Note: onStateEntered functions of initial states won't have
        //       some of these variables defined.

        if !(_currentListItem call _condition) then { continue };

        _currentListItem call (_stateMachineMap get ([_thisOrigin,"onStateLeaving"] joinString "_"));
        _currentListItem call _onTransition;
        _currentListItem setVariable [_currentItemStateVar, _thisTarget];
        _currentListItem call (_stateMachineMap get ([_thisTarget,"onStateEntered"] joinString "_"));
        break;
    };

    #ifdef STATEMACHINE_PERFORMANCE_COUNTERS
        LOG_PERFORMANCE
    #endif
};


nil
