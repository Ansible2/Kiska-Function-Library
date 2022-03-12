#define TRANSITION_CLASS(NAME) \
    class COMBAT_BEHAVIOUR_STATE(NAME) \
    { \
        condition = "combatBehaviour _this == "#NAME""; \
    };

#define COMBAT_BEHAVIOUR_STATE(NAME) KISKA_combatBehaviourState_##NAME
#define COMBAT_BEHAVIOUR_EVENT KISKA_combatBehaviourChangedEvent
#define ON_STATE_ENTERED(NAME,EVENT) onStateEntered = "[_this,"#EVENT",[_this,"#NAME"],false] call BIS_fnc_callScriptedEventHandler";

class CombatBehaviour
{
    eventName = COMBAT_BEHAVIOUR_EVENT;
    entityCondition = "(_this select 0) isEqualTypeAny [objNull,grpNull]";

    class stateMachine
    {
        name = "KISKA_stateMachine_combatBehaviour";
        skipNull = 1;

        class COMBAT_BEHAVIOUR_STATE(careless)
        {
            ON_STATE_ENTERED(careless,COMBAT_BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(combat)
            TRANSITION_CLASS(aware)
            TRANSITION_CLASS(error)
        };
        class COMBAT_BEHAVIOUR_STATE(safe)
        {
            ON_STATE_ENTERED(safe,COMBAT_BEHAVIOUR_EVENT)

            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(combat)
            TRANSITION_CLASS(aware)
            TRANSITION_CLASS(error)
        };
        class COMBAT_BEHAVIOUR_STATE(aware)
        {
            ON_STATE_ENTERED(aware,COMBAT_BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(combat)
            TRANSITION_CLASS(error)
        };
        class COMBAT_BEHAVIOUR_STATE(combat)
        {
            ON_STATE_ENTERED(combat,COMBAT_BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(aware)
            TRANSITION_CLASS(error)
        };
        class COMBAT_BEHAVIOUR_STATE(error)
        {
            ON_STATE_ENTERED(error,COMBAT_BEHAVIOUR_EVENT)

            TRANSITION_CLASS(safe)
            TRANSITION_CLASS(careless)
            TRANSITION_CLASS(combat)
            TRANSITION_CLASS(aware)
        };

    };
};
