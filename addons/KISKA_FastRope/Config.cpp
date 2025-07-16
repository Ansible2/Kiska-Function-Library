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
            file = "\KISKA_Fastrope\animations\fastroping.rtm"; // TODO: check absolute file path
            interpolateTo[] = {"Unconscious", 1};
            disableWeapons = 1;
            disableWeaponsLong = 1;
            canReload = 0;
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
