#define TRANSITION_CLASS(NAME) \
    class BEHAVIOUR_STATE(NAME) \
    { \
        condition = "behaviour _this == "#NAME""; \
    };

#define BEHAVIOUR_STATE(NAME) KISKA_behaviourState_##NAME
#define BEHAVIOUR_EVENT KISKA_behaviourChangedEvent
#define ON_STATE_ENTERED(NAME,EVENT) onStateEntered = "[_this,"#EVENT",[_this,"#NAME"],false] call BIS_fnc_callScriptedEventHandler";

class Behaviour
{
    eventName = BEHAVIOUR_EVENT;
    entityCondition = "(_this select 0) isEqualType objNull";

    class stateMachine
    {
        name = "KISKA_stateMachine_behaviour";
        skipNull = 1;

        class BEHAVIOUR_STATE(careless)
        {
            ON_STATE_ENTERED(careless,BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(combat)
            TRANSITION_CLASS(aware)
        };
        class BEHAVIOUR_STATE(safe)
        {
            ON_STATE_ENTERED(safe,BEHAVIOUR_EVENT)

            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(combat)
            TRANSITION_CLASS(aware)
        };
        class BEHAVIOUR_STATE(aware)
        {
            ON_STATE_ENTERED(aware,BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(combat)
        };
        class BEHAVIOUR_STATE(combat)
        {
            ON_STATE_ENTERED(combat,BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(aware)
        };

    };
};
