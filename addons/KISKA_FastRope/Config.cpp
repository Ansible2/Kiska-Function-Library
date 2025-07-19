class CfgPatches
{
    class KISKA_FastRope
    {
        units[]={};
        weapons[]={};
        requiredVersion=0.1;
        requiredAddons[]={
            "KISKA_Functions"
        };
    };
};

class CfgFunctions
{
    class KISKA
    {
        class FastRope
        {

        };
    };
};

class CfgMovesBasic 
{
    class DefaultDie;
    class ManActions 
    {
        KISKA_FastRoping = "KISKA_FastRoping";
    };
};

class CfgMovesMaleSdr : CfgMovesBasic
{
    class States 
    {
        class Crew;
        class KISKA_FastRoping : Crew 
        {
            file = "\KISKA_Fastrope\animations\fastroping.rtm";
            interpolateTo[] = {"Unconscious", 1};
            disableWeapons = 1;
            disableWeaponsLong = 1;
            canReload = 0;
        };
    };
};

class CfgVehicles
{
    class Helicopter_Base_F;
    class KISKA_friesBase : Helicopter_Base_F // TODO: change classnames to be clearer (e.g. what is "fries")
    {
        destrType = "DestructNo";
    };
    class KISKA_friesAnchorBar : KISKA_friesBase 
    {
        author = "jokoho48";
        scope = 1;
        model = "\KISKA_Fastrope\Models\friesAnchorBar.p3d";
        animated = 1;
        class AnimationSources 
        {
            class extendHookRight 
            {
                source = "user";
                initPhase = 0;
                animPeriod = 1.5;
            };
            class extendHookLeft : extendHookRight
            {};
        };
    };
    class KISKA_friesGantry : KISKA_friesBase 
    {
        author = "jokoho48";
        scope = 1;
        model = "\KISKA_Fastrope\Models\friesGantry.p3d";
        animated = 1;
        class AnimationSources 
        {
            class adjustWidth 
            {
                source = "user";
                initPhase = 0.211;
                animPeriod = 0;
            };
            class rotateGantryLeft
            {
                source = "user";
                initPhase = 0;
                animPeriod = 0;
            };
            class rotateGantryRight : rotateGantryLeft
            {};
            class hideGantryLeft : rotateGantryLeft
            {};
            class hideGantryRight : rotateGantryLeft
            {};
        };
    };
    class KISKA_friesGantryReverse : KISKA_friesGantry 
    {
        class AnimationSources : AnimationSources 
        {
            class adjustWidth 
            {
                source = "user";
                initPhase = 0.213;
                animPeriod = 0;
            };
            class rotateGantryLeft 
            {
                source = "user";
                initPhase = 0.5;
                animPeriod = 0;
            };
            class rotateGantryRight 
            {
                source = "user";
                initPhase = 0.5;
                animPeriod = 0;
            };
        };
    };

};

class CfgSounds 
{
    class KISKA_fastrope_descending
    {
        name = "KISKA_fastrope_descending";
        sound[] = {"\KISKA_FastRope\sounds\fastroping_descending.ogg", 10, 1.0};
        titles[] = {};
    };
    class KISKA_fastrope_thud 
    {
        name = "KISKA_fastrope_thud";
        sound[] = {"\KISKA_FastRope\sounds\fastroping_thud.ogg", 10, 1.0};
        titles[] = {};
    };
};
