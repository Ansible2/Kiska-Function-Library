#define TRANSITION_CLASS(NAME) \
    class trasnition_to_##NAME \
    { \
        targetState = "KISKA_behaviourState_"#NAME; \
        condition = "behaviour _this == '"#NAME"'"; \
    };

#define INHERITED_STATE(NAME,FROM) \
    class KISKA_behaviourState_##NAME : KISKA_behaviourState_##FROM
    { \
        ON_STATE_ENTERED(NAME) \
        class transition_to_##FROM : transition_to_##FROM {}; \
        class transition_to_##NAME {}; \
    };

#define ON_STATE_ENTERED(NAME) onStateEntered = "[_this,'KISKA_behaviourChangedEvent',[_this,'"#NAME"'],false] call BIS_fnc_callScriptedEventHandler";

class Behaviour
{
    TRANSITION_CLASS(safe)
    TRANSITION_CLASS(careless)
    TRANSITION_CLASS(combat)
    TRANSITION_CLASS(aware)
    TRANSITION_CLASS(error)

    class stateMachine
    {
        skipNull = 1;

        class KISKA_behaviourState_careless
        {
            ON_STATE_ENTERED(careless)

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
