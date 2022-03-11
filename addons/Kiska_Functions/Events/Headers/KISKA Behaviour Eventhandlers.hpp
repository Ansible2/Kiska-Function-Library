#define TRANSITION_CLASS(NAME) \
    class transition_to_##NAME \
    { \
        targetState = "KISKA_behaviourState_"#NAME""; \
        condition = "hint str _this; behaviour _this == "#NAME""; \
    };

#define BEHAVIOUR_STATE(NAME) KISKA_behaviourState_##NAME
#define BEHAVIOUR_EVENT KISKA_behaviourChangedEvent

#define INHERITED_STATE(NAME,FROM) \
    class BEHAVIOUR_STATE(NAME) : BEHAVIOUR_STATE(FROM) \
    { \
        ON_STATE_ENTERED(NAME,BEHAVIOUR_EVENT) \
        class transition_to_##FROM : transition_to_##FROM {}; \
        class transition_to_##NAME {}; \
    };


#define ON_STATE_ENTERED(NAME,EVENT) onStateEntered = "[_this,"#EVENT",[_this,"#NAME"],false] call BIS_fnc_callScriptedEventHandler";

class Behaviour
{
    eventName = BEHAVIOUR_EVENT;
    entityCondition = "(_this select 0) isEqualTypeAny [objNull, grpNull]";

    TRANSITION_CLASS(safe)
    TRANSITION_CLASS(careless)
    TRANSITION_CLASS(combat)
    TRANSITION_CLASS(aware)
    TRANSITION_CLASS(error)

    class stateMachine
    {
        name = "KISKA_stateMachine_behaviour";
        skipNull = 1;
        list = "[]";

        class BEHAVIOUR_STATE(careless)
        {
            ON_STATE_ENTERED(careless,KISKA_behaviourChangedEvent)

            class transition_to_careless {}; // no transition back to the current state
            class transition_to_safe : transition_to_safe {};
            class transition_to_error : transition_to_error {};
            class transition_to_combat : transition_to_combat {};
            class transition_to_aware : transition_to_aware {};
        };

        INHERITED_STATE(safe,careless)
        INHERITED_STATE(aware,careless)
        INHERITED_STATE(combat,careless)
        INHERITED_STATE(error,careless)
    };
};
