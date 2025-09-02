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
    // keeping for backwards compatibility 
    class Land_VR_Block_06_F : Land_VR_Block_01_F
    {
        displayName = "VR Obstacle (20x10x8) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };
    class KISKA_Land_VR_Block_01_F_No_Shadow : Land_VR_Block_06_F
    {};

    class Land_VR_Slope_01_F;
    class KSIKA_Land_VR_Slope_01_F_No_Shadow : Land_VR_Slope_01_F
    {
        displayName = "VR Slope (10x5x4) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_Block_03_F;
    class KSIKA_Land_VR_Block_03_F_No_Shadow : Land_VR_Block_03_F
    {
        displayName = "VR Obstacle (12x7.5x6) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_Block_02_F;
    class KSIKA_Land_VR_Block_02_F_No_Shadow : Land_VR_Block_02_F
    {
        displayName = "VR Obstacle (12x12x4) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_Block_04_F;
    class KSIKA_Land_VR_Block_04_F_No_Shadow : Land_VR_Block_04_F
    {
        displayName = "VR Obstacle (10.5x10.5x9) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_Shape_01_cube_1m_F;
    class KSIKA_Land_VR_Shape_01_cube_1m_F_No_Shadow : Land_VR_Shape_01_cube_1m_F
    {
        displayName = "VR Game Block (Cube, 1m) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_CoverObject_01_kneelHigh_F;
    class KSIKA_Land_VR_CoverObject_01_kneelHigh_F_No_Shadow : Land_VR_CoverObject_01_kneelHigh_F
    {
        displayName = "VR Cover Object (High kneel) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_CoverObject_01_standHigh_F;
    class KSIKA_Land_VR_CoverObject_01_standHigh_F_No_Shadow : Land_VR_CoverObject_01_standHigh_F
    {
        displayName = "VR Cover Object (High stand) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_CoverObject_01_kneel_F;
    class KSIKA_Land_VR_CoverObject_01_kneel_F_No_Shadow : Land_VR_CoverObject_01_kneel_F
    {
        displayName = "VR Cover Object (Kneel) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_CoverObject_01_kneelLow_F;
    class KSIKA_Land_VR_CoverObject_01_kneelLow_F_No_Shadow : Land_VR_CoverObject_01_kneelLow_F
    {
        displayName = "VR Cover Object (Low kneel) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };

    class Land_VR_CoverObject_01_stand_F;
    class KSIKA_Land_VR_CoverObject_01_stand_F_No_Shadow : Land_VR_CoverObject_01_stand_F
    {
        displayName = "VR Cover Object (Stand) NO SHADOW";
        shadow = 0;
        author = "KISKA Factory";
        scope = 1;
    };
};
