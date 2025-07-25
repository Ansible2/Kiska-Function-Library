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
			file = "KISKA_FastRope\Functions";
            
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

    class KISKA_FastRope_helper : KISKA_friesBase
    {
        author = "KoffeinFlummi";
        scope = 1;
        model = "\KISKA_Fastrope\Models\helper.p3d";
        class Turrets {};
        class TransportItems {};
    };


    class Helicopter_Base_H;
    class Heli_Light_02_base_F : Helicopter_Base_H 
    {
        class KISKA_FastRope
        {
            ropeOrigins[] = {
                {1.41, 1.38, 0}, 
                {-1.41, 1.38, 0}
            };
        };
    };

    class Heli_Attack_02_base_F : Helicopter_Base_F 
    {
        class KISKA_FastRope
        {
            ropeOrigins[] = {
                {1.25, 1.5, -0.6}, 
                {-1.1, 1.5, -0.6}
            };
        };
    };

    class Heli_Transport_01_base_F : Helicopter_Base_H 
    {
        // GVAR(enabled) = 2; // probably not needed
        class KISKA_FastRope
        {
            ropeOrigins[] = {"ropeOriginRight", "ropeOriginLeft"};
            friesType = "KISKA_friesAnchorBar";
            friesAttachmentPoint[] = {0.035, 2.2, -0.15};
        };
    };

    class Heli_Transport_02_base_F : Helicopter_Base_H 
    {

        // GVAR(enabled) = 1;
        class KISKA_FastRope
        {
            ropeOrigins[] = {
                {0.94, -4.82, -1.16}, 
                {-0.94, -4.82, -1.16}
            };
        };

        // TODO: don't know why this is needed(?)
        // class UserActions {
        //     class Ramp_Open;
        //     class Ramp_Close: Ramp_Open {
        //         condition = QUOTE([ARR_3(this,'CargoRamp_Open',[ARR_3([0],[1],[2])])] call FUNC(canCloseRamp));
        //     };
        // };
    };
    class Heli_Transport_03_base_F : Helicopter_Base_H 
    {
        // GVAR(enabled) = 1;
        class KISKA_FastRope
        {
            ropeOrigins[] = {
                {0.75, -5.29, -0.11}, 
                {-0.87, -5.29, -0.11}
            };
        };

        // TODO: don't know why this is needed(?)
        // class UserActions {
        //     class Ramp_Open;
        //     class Ramp_Close: Ramp_Open {
        //         condition = QUOTE([ARR_3(this,'Door_rear_source',[ARR_3([0],[3],[4])])] call FUNC(canCloseRamp));
        //     };
        // };
    };
    class Heli_light_03_base_F : Helicopter_Base_F 
    {
        // GVAR(enabled) = 2;
        class KISKA_FastRope
        {
            ropeOrigins[] = {"ropeOriginRight", "ropeOriginLeft"};
            friesType = "ACE_friesGantryReverse";
            friesAttachmentPoint[] = {-1.04, 2.5, -0.34};
        };
    };
    class Heli_light_03_unarmed_base_F : Heli_light_03_base_F 
    {
        // GVAR(enabled) = 2;
        class KISKA_FastRope
        {
            ropeOrigins[] = {"ropeOriginRight", "ropeOriginLeft"};
            friesType = "ACE_friesGantry";
            friesAttachmentPoint[] = {1.07, 2.5, -0.5};
        };
    };

    class O_Heli_Transport_04_bench_F : Helicopter_Base_H 
    {
        // GVAR(enabled) = 1;
        class KISKA_FastRope
        {
            ropeOrigins[] = {
                {1.03, 1.6, -0.23}, 
                {1.03, -1.36, -0.23}, 
                {-1.23, 1.6, -0.23},
                {-1.23, -1.36, -0.23}
            };
        };
    };
    class O_Heli_Transport_04_covered_F : Helicopter_Base_H 
    {
        // GVAR(enabled) = 1;
        class KISKA_FastRope
        {
            ropeOrigins[] = {
                {0.83, -4.7, -0.03}, 
                {-1.02, -4.7, -0.03}
            };
        };

        // TODO: why?
        // class UserActions: UserActions {
        //     class CloseDoor_6;
        //     class Ramp_Close: CloseDoor_6 {
        //         condition = QUOTE([ARR_3(this,'Door_6_source',[ARR_4([0],[1],[2],[3])])] call FUNC(canCloseRamp));
        //     };
        // };
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
