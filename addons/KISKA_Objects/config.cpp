class CfgPatches
{
    class kiska_objects
    {
        units[]={};
        weapons[]={};
        requiredVersion=0.1;
        requiredAddons[]={};
    };
};

class CfgVehicles
{
    class Land_VR_Block_01_F;
    class Land_VR_Block_06_F : Land_VR_Block_01_F
    {
        displayName = "VR Obstacle (20x10x8) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
    };
};
