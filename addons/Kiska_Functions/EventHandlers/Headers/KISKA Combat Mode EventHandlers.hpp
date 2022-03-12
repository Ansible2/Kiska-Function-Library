#define TRANSITION_CLASS(NAME) \
    class COMBAT_MODE_STATE(NAME) \
    { \
        condition = "combatMode _this == "#NAME""; \
    };

#define COMBAT_MODE_STATE(NAME) KISKA_combatModeState_##NAME
#define COMBAT_MODE_EVENT KISKA_combatModeChangedEvent
#define ON_STATE_ENTERED(NAME,EVENT) onStateEntered = "[_this,"#EVENT",[_this,"#NAME"],false] call BIS_fnc_callScriptedEventHandler";

class CombatMode
{
    eventName = COMBAT_MODE_EVENT;
    entityCondition = "(_this select 0) isEqualType grpNull";

    class stateMachine
    {
        name = "KISKA_stateMachine_combatMode";
        skipNull = 1;

        class COMBAT_MODE_STATE(blue)
        {
            ON_STATE_ENTERED(blue,COMBAT_MODE_EVENT)

            TRANSITION_CLASS(white)
            TRANSITION_CLASS(red)
            TRANSITION_CLASS(yellow)
            TRANSITION_CLASS(green)
        };
        class COMBAT_MODE_STATE(white)
        {
            ON_STATE_ENTERED(white,COMBAT_MODE_EVENT)

            TRANSITION_CLASS(blue)
            TRANSITION_CLASS(red)
            TRANSITION_CLASS(yellow)
            TRANSITION_CLASS(green)
        };
        class COMBAT_MODE_STATE(yellow)
        {
            ON_STATE_ENTERED(yellow,COMBAT_MODE_EVENT)

            TRANSITION_CLASS(white)
            TRANSITION_CLASS(blue)
            TRANSITION_CLASS(red)
            TRANSITION_CLASS(green)
        };
        class COMBAT_MODE_STATE(red)
        {
            ON_STATE_ENTERED(red,COMBAT_MODE_EVENT)

            TRANSITION_CLASS(white)
            TRANSITION_CLASS(blue)
            TRANSITION_CLASS(yellow)
            TRANSITION_CLASS(green)
        };
        class COMBAT_MODE_STATE(green)
        {
            ON_STATE_ENTERED(green,COMBAT_MODE_EVENT)

            TRANSITION_CLASS(white)
            TRANSITION_CLASS(blue)
            TRANSITION_CLASS(red)
            TRANSITION_CLASS(yellow)
        };

    };
};
