class CfgPatches {
	class KISKA_AmzSoundsPatch {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {
			"A3_Sounds_F",
			"A3_Sounds_F_exp",
			"A3_Weapons_F",
			"A3_Weapons_f_exp",
			"squad_tank_explosions" // name of patch
		};
		author = "Ansible2";
	};
};

// NOTES:
// copied from squad_expSounds addon config
// it seems like all the sounds in the range are being used and they shouldn't be
	// so dist, close, and med are all played no matter what
// This is still wip hence why all the volumes are 0.1
// Ideally the only thing that should need to change are the volumes in these classes
	// the rest can just be inheirited
	// This will require a bit of effort to balance these based on their original values (see reference to original config)


class cfgSoundShaders
{
	class Squad_AutoCannon_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_04.ogg",
				1
			}
		};
		volume=0.1;
		range=400;
		rangeCurve[]=
		{
			{0,1},
			{285,0.75},
			{400,0}
		};
	};
	class Squad_AutoCannon_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_05.ogg",
				1
			}
		};
		volume=0.1;
		range=2500;
		rangeCurve[]=
		{
			{0,0},
			{300,0},
			{2200,1},
			{2500,1}
		};
	};
	class Squad_MedEXP_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_05.ogg",
				1
			}
		};
		volume=0.1;
		range=450;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_MedEXP_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_01.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_02.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_03.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_04.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_05.ogg",
				1
			}
		};
		volume=0.1;
		range=1800;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_MedEXP_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_01.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_02.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_03.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_04.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_05.ogg",
				1
			}
		};
		volume=0.1;
		range=4200;
		rangeCurve[]=
		{
			{0,0},
			{500,0},
			{4000,1},
			{4200,1}
		};
	};
	class Squad_Launcher_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_05.ogg",
				1
			}
		};
		volume=0.1;
		range=450;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Launcher_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_05.ogg",
				1
			}
		};
		volume=0.1;
		range=3500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_SmokeLauncher_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_close_03.ogg",
				1
			}
		};
		volume=0.1;
		range=250;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_SmokeLauncher_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_mid_03.ogg",
				1
			}
		};
		volume=0.1;
		range=2000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mines_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_close_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_close_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_close_initial_03.ogg",
				1
			}
		};
		volume=0.1;
		range=110;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mines_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_05.ogg",
				1
			}
		};
		volume=0.1;
		range=4500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_IED_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_04.ogg",
				1
			}
		};
		volume=0.1;
		range=350;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_IED_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_04.ogg",
				1
			}
		};
		volume=0.1;
		range=2500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_IED_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_05.ogg",
				1
			}
		};
		volume=0.1;
		range=6000;
		rangeCurve[]=
		{
			{0,0},
			{600,0},
			{5800,1},
			{6000,1}
		};
	};
	class Squad_Mortar_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_05.ogg",
				1
			}
		};
		volume=0.1;
		range=500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mortar_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_04.ogg",
				1
			}
		};
		volume=0.1;
		range=2500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mortar_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_05.ogg",
				1
			}
		};
		volume=0.1;
		range=7000;
		rangeCurve[]=
		{
			{0,0},
			{2000,0},
			{6000,1},
			{7000,1}
		};
	};
	class Squad_Artillery_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_05.ogg",
				1
			}
		};
		volume=0.1;
		range=700;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Artillery_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_04.ogg",
				1
			}
		};
		volume=0.1;
		range=5000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Artillery_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_04.ogg",
				1
			}
		};
		volume=0.1;
		range=14000;
		rangeCurve[]=
		{
			{0,0},
			{4000,0},
			{12000,1},
			{14000,1}
		};
	};
	class Squad_Bombs_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_04.ogg",
				1
			}
			
		};
		volume=0.1;
		range=900;
		rangeCurve="CannonCloseShotCurve";
		
	};
	class Squad_Bombs_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_04.ogg",
				1
			}
		};
		volume=0.1;
		range=7500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_SmallVEC_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_10.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_11.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_12.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_13.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_14.ogg",
				1
			}
		};
		volume=0.1;
		range=800;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeloVEC_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\helismall\chopper_engine_boom_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\helismall\chopper_engine_boom_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\helismall\chopper_engine_boom_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\helismawll\chopper_engine_boom_close_04.ogg",
				1
			}
		};
		volume=0.1;
		range=700;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_05.ogg",
				1
			}
		};
		volume=0.1;
		range=700;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_03.ogg",
				1
			},
			 
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_04.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_05.ogg",
				1
			}
		};
		volume=0.1;
		range=3500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_03.ogg",
				1
			},
			 
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_04.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_05.ogg",
				1
			}
		};
		volume=0.1;
		range=10000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Pop_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_pops_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_pops_02.ogg",
				1
			}
		};
		volume=0.1;
		range=1000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Debris_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\veh_heavy_debris_destroyed_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\veh_heavy_debris_destroyed_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\veh_heavy_debris_destroyed_03.ogg",
				1
			}
		};
		volume=0.1;
		range=750;
		rangeCurve="CannonCloseShotCurve";
	};
};

// Original config
/*
class cfgPatches
{
	class squad_explosion_soundmod
	{
		units[]={};
		weapons[]={};
		addonRootClass="a3_sounds_f_exp";
		requiredVersion=0;
		requiredaddons[]=
		{
			"a3_sounds_f",
			"a3_weapons_f",
			"a3_sounds_f_exp",
			"a3_weapons_f_exp"
		};
		authors[] = {"Squad", "amzingdogeyyyy"};
	};
};
class CfgSoundCurves
{
	class Squad_Normal
	{
		points[]=
		{
			{0,1},
			{0.0024999999,0.69999999},
			{0.00875,0.44999999},
			{0.02125,0.25},
			{0.035,0.15000001},
			{0.081249997,0.1},
			{0.175,0.075000003},
			{0.69999999,0.0099999998},
			{1,0}
		};
	};
	class Squad_TailCurve
	{
		points[]=
		{
			{0,1},
			{0.2,0.85000002},
			{0.5,0.40000001},
			{0.80000001,0.1},
			{1,0}
		};
	};
	class Squad_WeaponCurve
	{
		points[]=
		{
			{0,1},
			{0.001,0.92000002},
			{0.0049999999,0.88999999},
			{0.1,0.84750003},
			{0.2,0.8096},
			{0.40000001,0.75330001},
			{0.60000002,0.63150001},
			{0.80000001,0.49680001},
			{0.89999998,0.39680001},
			{1,0}
		};
	};
	class Squad_Fade
	{
		points[]=
		{
			{0,1},
			{1,0}
		};
	};

};
class CfgDistanceFilters
{
	class Squad_NormalDistanceFilter
	{
		type="lowPassFilter";
		minCutoffFrequency=150;
		qFactor=1;
		innerRange=400;
		range=2600;
		powerFactor=32;
	};
	class Squad_WeaponShotDistanceFilter
	{
		type="lowPassFilter";
		minCutoffFrequency=250;
		qFactor=1.3;
		innerRange=150;
		range=1800;
		powerFactor=32;
	};	
	class Squad_WeaponLRGDistanceFilter
	{
		type="lowPassFilter";
		minCutoffFrequency=150;
		qFactor=1;
		innerRange=350;
		range=1800;
		powerFactor=32;
	};

};
class CfgSound3DProcessors
{
};
class cfgSoundShaders
{
	class Squad_BulletSonicCrack_Shader
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_13.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_14.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_15.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_16.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_17.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_27.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_28.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_29.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_30.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_31.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_19.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_20.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_21.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_22.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_23.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_24.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_rifle_762_close_25.ogg",
				1
			}
		};
		volume = 1.3;
		range = 80;
		rangeCurve[] = {{0, 1},{5,1},{6,0},{50,0}};		
		limitation = 1;
	};
	
	class Squad_Bullet50CalSonicCrack_Shader
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_04.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_05.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_06.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_07.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_08.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_09.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_10.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_11.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_12.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_13.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_14.ogg",
				1
			},
			
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_15.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\crack_50cal_mid_new_16.ogg",
				1
			}
		};
		volume = 2;
		range = 50;
		rangeCurve[]=
		{
			{0,1},
			{5,1},
			{10,0.5}
		};		
		limitation = 1;
	};
	
	class Squad_HeavySonicCrack_Shader
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_05.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_06.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_07.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_08.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_09.ogg",
				1
			},
			
			{
				"squad_expSounds\bullets\sounds\projectile_30mm_AP_passby_close_10.ogg",
				1
			}
		};
		volume = 3;
		range = 200;
		rangeCurve[]=
		{
			{0,1},
			{65,1},
			{70,0.5}
		};		
		limitation = 1;
	};
	class Squad_RocketSonicCrack_Shader
	{
		samples[]=
		{
			
			{
				"squad_expSounds\rockets\sounds\rocket_small_woosh_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\rockets\sounds\rocket_small_woosh_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\rockets\sounds\rocket_small_woosh_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\rockets\sounds\rocket_small_woosh_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\rockets\sounds\rocket_small_woosh_close_05.ogg",
				1
			}
		};
		volume = 1.4;
		range = 120;
		rangeCurve[]=
		{
			{0,1},
			{30,1},
			{60,0.5}
		};		
		limitation = 1;
	};
	class Squad_ShellSonicCrack_Shader
	{
		samples[]=
		{
			
			{
				"squad_expSounds\shells\sounds\120mm_flyby_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\shells\sounds\120mm_flyby_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\shells\sounds\120mm_flyby_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\shells\sounds\120mm_flyby_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\shells\sounds\120mm_flyby_close_05.ogg",
				1
			}
		};
		volume = 3.5;
		range = 250;
		rangeCurve[]=
		{
			{0,1},
			{120,1},
			{250,0.7}
		};		
		limitation = 1;
	};
	class Squad_ArtilleryIncoming_Shader
	{
		samples[]=
		{
			
			{
				"squad_expSounds\incoming\artillery\sounds\Artillery_shell_incoming_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\incoming\artillery\sounds\Artillery_shell_incoming_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\incoming\artillery\sounds\Artillery_shell_incoming_close_03.ogg",
				1
			}
		};
		volume = 3;
		range = 120;
		rangeCurve[]=
		{
			{0,1},
			{30,1},
			{60,0.5}
		};		
		limitation = 1;
	};

	
	
	
	
	
	
	
	
	class Squad_Grenades_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_close_05.ogg",
				1
			}
		};
		volume=2;
		range=150;
		rangeCurve[]=
		{
			{0,1},
			{65,0.75},
			{150,0}
		};
	};
	class Squad_Grenades_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_mid_04.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\squad_grenade_imp_mid_05.ogg",
				1
			}
		};
		volume=3;
		range=600;
		rangeCurve[]=
		{
			{0,1},
			{20,1},
			{300,0},
			{600,0}
		};
	};
	class Squad_Grenades_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\grenade_impacts\sounds\imp_grenade_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\imp_grenade_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\imp_grenade_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\imp_grenade_far_04.ogg",
				1
			},
			
			{
				"squad_expSounds\grenade_impacts\sounds\imp_grenade_far_05.ogg",
				1
			}
		};
		volume=2;
		range=3000;
		rangeCurve[]=
		{
			{0,0},
			{80,0},
			{2500,1},
			{3000,1}
		};
	};
	
	
	class Squad_C4_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_close_05.ogg",
				1
			}
		};
		volume=3;
		range=200;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_C4_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_mid_04.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_mid_05.ogg",
				1
			}
		};
		volume=3.5;
		range=1500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_C4_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\c4\sounds\c4_exp_initial_far_04.ogg",
				1
			}
		};
		volume=3.5;
		range=4100;
		rangeCurve[]=
		{
			{0,0},
			{500,0},
			{3800,1},
			{4100,1}
		};
	};
	class Squad_AutoCannon_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\autocannon\sounds\destroyable_ammobox_intial_04.ogg",
				1
			}
		};
		volume=2.5;
		range=400;
		rangeCurve[]=
		{
			{0,1},
			{285,0.75},
			{400,0}
		};
	};
	class Squad_AutoCannon_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_05.ogg",
				1
			}
		};
		volume=5;
		range=2500;
		rangeCurve[]=
		{
			{0,0},
			{300,0},
			{2200,1},
			{2500,1}
		};
	};
	class Squad_MedEXP_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_close_05.ogg",
				1
			}
		};
		volume=3.5;
		range=450;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_MedEXP_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_01.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_02.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_03.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_04.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_medium_05.ogg",
				1
			}
		};
		volume=5.5;
		range=1800;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_MedEXP_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_01.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_02.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_03.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_04.ogg",
				1
			},
			
			{
				"squad_expSounds\med_explosion_sounds\weapon_cache_exp_distant_05.ogg",
				1
			}
		};
		volume=5;
		range=4200;
		rangeCurve[]=
		{
			{0,0},
			{500,0},
			{4000,1},
			{4200,1}
		};
	};
	class Squad_Launcher_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_mid_05.ogg",
				1
			}
		};
		volume=5;
		range=450;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Launcher_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Launcher\sounds\imp_rpgHeat_far_05.ogg",
				1
			}
		};
		volume=6;
		range=3500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_SmokeLauncher_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_close_03.ogg",
				1
			}
		};
		volume=3;
		range=250;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_SmokeLauncher_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Smoke\sounds\smoke_veh_exp_mid_03.ogg",
				1
			}
		};
		volume=4;
		range=2000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mines_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_close_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_close_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_close_initial_03.ogg",
				1
			}
		};
		volume=3;
		range=110;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mines_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Mines\sounds\mine_exp_mid_initial_05.ogg",
				1
			}
		};
		volume=3.5;
		range=4500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_IED_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_close_initial_04.ogg",
				1
			}
		};
		volume=3.5;
		range=350;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_IED_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_mid_initial_04.ogg",
				1
			}
		};
		volume=3.5;
		range=2500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_IED_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\ied\sounds\ied_exp_far_initial_05.ogg",
				1
			}
		};
		volume=5;
		range=6000;
		rangeCurve[]=
		{
			{0,0},
			{600,0},
			{5800,1},
			{6000,1}
		};
	};
	class Squad_Mortar_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_close_initial_05.ogg",
				1
			}
		};
		volume=3;
		range=500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mortar_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_mid_initial_04.ogg",
				1
			}
		};
		volume=3;
		range=2500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Mortar_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Mortar\sounds\81mm_mortar_exp_far_initial_05.ogg",
				1
			}
		};
		volume=5;
		range=7000;
		rangeCurve[]=
		{
			{0,0},
			{2000,0},
			{6000,1},
			{7000,1}
		};
	};
	class Squad_Artillery_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_close_05.ogg",
				1
			}
		};
		volume=3;
		range=700;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Artillery_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_mid_04.ogg",
				1
			}
		};
		volume=3;
		range=5000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Artillery_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\Artillery\sounds\artillery_impact_far_04.ogg",
				1
			}
		};
		volume=5;
		range=14000;
		rangeCurve[]=
		{
			{0,0},
			{4000,0},
			{12000,1},
			{14000,1}
		};
	};
	class Squad_Bombs_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_close_04.ogg",
				1
			}
			
		};
		volume=3.5;
		range=900;
		rangeCurve="CannonCloseShotCurve";
		
	};
	class Squad_Bombs_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_mid_04.ogg",
				1
			}
		};
		volume=4;
		range=7500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_Bombs_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_far_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_far_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_far_03.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\JDAM_impact_far_04.ogg",
				1
			}
		};
		volume=4;
		range=18000;
		rangeCurve[]=
		{
			{0,0},
			{2000,0},
			{16500,1},
			{18000,1}
		};
	};
	class Squad_SmallShockwave_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\Flak_explosion_shockwave_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\Flak_explosion_shockwave_02.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\Flak_explosion_shockwave_03.ogg",
				1
			}
		};
		volume=2;
		range=5000;
		rangeCurve[]=
		{
			{0,0},
			{500,0},
			{2000,1},
			{5000,1}
		};
	};
	class Squad_MedShockwave_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\ied_shockwave_whoosh_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\ied_shockwave_whoosh_02.ogg",
				1
			}
		};
		volume=2;
		range=8000;
		rangeCurve[]=
		{
			{0,0},
			{2000,0},
			{4500,1},
			{8000,1}
		};
	};
	class Squad_BigShockwave_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\bombs\sounds\ied_shockwave_whoosh_01.ogg",
				1
			},
			
			{
				"squad_expSounds\bombs\sounds\ied_shockwave_whoosh_02.ogg",
				1
			}
		};
		volume=2;
		range=18000;
		rangeCurve[]=
		{
			{0,0},
			{2000,0},
			{16500,1},
			{18000,1}
		};
	};
	class Squad_SmallVEC_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_10.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_11.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_12.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_13.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\small\ammo_boom_exp_close_14.ogg",
				1
			}
		};
		volume=5;
		range=800;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeloVEC_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\helismall\chopper_engine_boom_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\helismall\chopper_engine_boom_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\helismall\chopper_engine_boom_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\helismawll\chopper_engine_boom_close_04.ogg",
				1
			}
		};
		volume=2;
		range=700;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Close_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_03.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_04.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_close_05.ogg",
				1
			}
		};
		volume=2;
		range=700;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Mid_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_03.ogg",
				1
			},
			 
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_04.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_initial_mid_05.ogg",
				1
			}
		};
		volume=5;
		range=3500;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Dist_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_03.ogg",
				1
			},
			 
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_04.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\vehicle_boom_large_distant_05.ogg",
				1
			}
		};
		volume=6.5;
		range=10000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Pop_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_pops_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\engine_boom_apc_pops_02.ogg",
				1
			}
		};
		volume=3;
		range=1000;
		rangeCurve="CannonCloseShotCurve";
	};
	class Squad_HeavyVEC_Debris_Explosions
	{
		samples[]=
		{
			
			{
				"squad_expSounds\vehicles\tank\veh_heavy_debris_destroyed_01.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\veh_heavy_debris_destroyed_02.ogg",
				1
			},
			
			{
				"squad_expSounds\vehicles\tank\veh_heavy_debris_destroyed_03.ogg",
				1
			}
		};
		volume=1;
		range=750;
		rangeCurve="CannonCloseShotCurve";
	};
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
};
class CfgSoundSets
{
	
	class Squad_BulletSonicCrack_Sets {
		soundShaders[] = {"Squad_BulletSonicCrack_Shader"};
		volumeFactor = 1.1;
		occlusionFactor = 0.35;
		obstructionFactor = 0.85;
		volumeCurve = "LinearCurve";
		spatial = 1;
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "WeaponLightShot3DProcessingType";		
		SoundShadersLimit = 2;
		stereoRadius = 1;		
		frequencyRandomizer = 2;
		frequencyRandomizerMin = 0.89;
				
	};
	class Squad_Bullet50CalSonicCrack_Sets {
		soundShaders[] = {"Squad_Bullet50CalSonicCrack_Shader"};
		volumeFactor = 1.3;
		occlusionFactor = 0.35;
		obstructionFactor = 0.85;
		volumeCurve = "LinearCurve";
		spatial = 1;
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "WeaponMediumShot3DProcessingType";		
		SoundShadersLimit = 2;
		stereoRadius = 1;		
		frequencyRandomizer = 2;
		frequencyRandomizerMin = 0.89;
				
	};
	class Squad_HeavySonicCrack_Sets {
		soundShaders[] = {"Squad_HeavySonicCrack_Shader"};
		volumeFactor = 1.5;
		occlusionFactor = 0.35;
		obstructionFactor = 0.85;
		volumeCurve = "LinearCurve";
		spatial = 1;
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "WeaponMediumShot3DProcessingType";	
		SoundShadersLimit = 2;
		stereoRadius = 1;		
		frequencyRandomizer = 2;
		frequencyRandomizerMin = 0.89;
			
	};
	class Squad_RocketSonicCrack_Sets {
		soundShaders[] = {"Squad_RocketSonicCrack_Shader"};
		volumeFactor = 1.5;
		occlusionFactor = 0.35;
		obstructionFactor = 0.85;
		volumeCurve = "LinearCurve";
		spatial = 1;
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "WeaponLightShot3DProcessingType";	
		SoundShadersLimit = 2;
		stereoRadius = 1;		
		frequencyRandomizer = 2;
		frequencyRandomizerMin = 0.89;
			
	};
	class Squad_ShellSonicCrack_Sets {
		soundShaders[] = {"Squad_ShellSonicCrack_Shader"};
		volumeFactor = 2;
		occlusionFactor = 0.35;
		obstructionFactor = 0.85;
		volumeCurve = "LinearCurve";
		spatial = 1;
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "WeaponHeavyShot3DProcessingType";	
		SoundShadersLimit = 6;
		stereoRadius = 1;		
		frequencyRandomizer = 2;
		frequencyRandomizerMin = 0.89;
			
	};
	class Squad_BulletSonicCrackTail_Sets
	{
		soundShaders[]=
		{
			"BulletSonicCrack_tailMeadow_SoundShader",
			"BulletSonicCrack_tailForest_SoundShader",
			"BulletSonicCrack_tailTrees_SoundShader",
			"BulletSonicCrack_tailHouses_SoundShader"
		};
		volumeFactor=0.2;
		volumeCurve="InverseSquare3Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		sound3DProcessingType="SonicCrackTail3DProcessingType";
	};
	class Squad_ArtilleryIncoming_Sets {
		soundShaders[] = {"Squad_ArtilleryIncoming_Shader"};
		volumeFactor = 2;
		occlusionFactor = 0.35;
		obstructionFactor = 0.85;
		volumeCurve = "LinearCurve";
		spatial = 1;
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "WeaponHeavyShot3DProcessingType";	
		SoundShadersLimit = 6;
		stereoRadius = 1;		
		frequencyRandomizer = 2;
		frequencyRandomizerMin = 0.89;
			
	};
	
	
	class Squad_TankShell_SonicCrack_Sets
	{
		soundShaders[]=
		{
			"Squad_Close_TankShellSonic",
			"Squad_Mid_TankShellSonic"
		};
		volumeFactor=1.1;
		volumeCurve="InverseSquare3Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="WeaponLightShot3DProcessingType";
	};
	class Squad_RocketSmall_SonicCrack_Sets
	{
		soundShaders[]=
		{
			"Squad_Close_RocketSmallSonic"
		};
		volumeFactor=1.1;
		volumeCurve="InverseSquare3Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="WeaponLightShot3DProcessingType";
	};
	class Squad_Rocket_SonicCrack_Sets
	{
		soundShaders[]=
		{
			"Squad_Close_RocketSonic"
		};
		volumeFactor=1.1;
		volumeCurve="InverseSquare3Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="WeaponLightShot3DProcessingType";
	};
	
	
	
	class Squad_Grenades_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_Grenades_Close_Explosions",
			"Squad_Grenades_Mid_Explosions",
			"Squad_Grenades_Dist_Explosions"
		};
		volumeFactor=4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionLight3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_C4_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_C4_Close_Explosions",
			"Squad_C4_Mid_Explosions",
			"Squad_C4_Dist_Explosions",
			"Squad_MedShockwave_Explosions"
		};
		volumeFactor=4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_AutoCannon_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_AutoCannon_Close_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionLight3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_AutoCannon_Explosions_2_Set
	{
		soundShaders[]=
		{
			
			"Squad_AutoCannon_Dist_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionLight3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_SmokeLauncher_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_SmokeLauncher_Close_Explosions",
			"Squad_SmokeLauncher_Mid_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Launcher_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_Launcher_Close_Explosions",
			"Squad_Launcher_Mid_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_MEDEXP_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_MEDEXP_Close_Explosions"
		};
		volumeFactor=5.5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_MEDEXP_Explosions_2_Set
	{
		soundShaders[]=
		{
			
			"Squad_MEDEXP_Mid_Explosions",
			"Squad_MEDEXP_Dist_Explosions"
		};
		volumeFactor=5.5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Mines_Explosions_Set
	{
		soundShaders[]=
		{
			
			"Squad_Mines_Mid_Explosions"
	
		};
		volumeFactor=4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Mines_Explosions_2_Set
	{
		soundShaders[]=
		{
			"Squad_Mines_Close_Explosions"
		};
		volumeFactor=4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_IED_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_IED_Close_Explosions",
			"Squad_IED_Mid_Explosions",
			"Squad_IED_Dist_Explosions",
			"Squad_MedShockwave_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionHeavy3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_Mortar_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_Mortar_Close_Explosions",
			"Squad_Mortar_Mid_Explosions",
			"Squad_Mortar_Dist_Explosions",
			"Squad_MedShockwave_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionHeavy3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_Artillery_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_Artillery_Close_Explosions",
			"Squad_Artillery_Mid_Explosions",
			"Squad_Artillery_Dist_Explosions",
			"Squad_BigShockwave_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionHeavy3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_Bombs_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_Bombs_Close_Explosions",
			"Squad_Bombs_Mid_Explosions",
			"Squad_Bombs_Dist_Explosions",
			"Squad_BigShockwave_Explosions"
		};
		volumeFactor=5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionHeavy3DProcessingType";
		distanceFilter="explosionDistanceFreqAttenuationFilter";
	};
	class Squad_SmallVEC_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_SmallVEC_Close_Explosions"
			
		};
		volumeFactor=2;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_SmallVEC_Explosions_2_Set
	{
		soundShaders[]=
		{
			"Squad_MEDEXP_Mid_Explosions",
			"Squad_MEDEXP_Dist_Explosions"
		};
		volumeFactor=2;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_HeavyVEC_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_HeavyVEC_Close_Explosions"
		};
		volumeFactor=3;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_HeloVEC_Explosions_Set
	{
		soundShaders[]=
		{
			"Squad_HeloVEC_Close_Explosions"
		};
		volumeFactor=3;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_HeavyVEC_Explosions_2_Set
	{
		soundShaders[]=
		{
			
			"Squad_HeavyVEC_Mid_Explosions",
			"Squad_IED_Mid_Explosions",
			"Squad_HeavyVEC_Pop_Explosions",
			"Squad_HeavyVEC_Debris_Explosions",
			"Squad_HeavyVEC_Dist_Explosions",
			"Squad_BigShockwave_Explosions",
		};
		volumeFactor=4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	
	
	
	
	
	
	
	
	
	class Squad_Grenades_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"GrenadeHe_tailForest_SoundShader",
			"GrenadeHe_tailMeadows_SoundShader",
			"GrenadeHe_tailHouses_SoundShader"
		};
		volumeFactor=0.4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionLightTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_C4_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"ExplosiveCharge_tailForest_SoundShader",
			"ExplosiveCharge_tailMeadows_SoundShader",
			"ExplosiveCharge_tailHouses_SoundShader"
		};
		volumeFactor=0.4;
		volumeCurve="LinearCurve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_AutoCannon_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"Shell30mm40mm_tailForest_SoundShader",
			"Shell30mm40mm_tailMeadows_SoundShader",
			"Shell30mm40mm_tailHouses_SoundShader"
		};
		volumeFactor=0.5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionLightTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_MEDEXP_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"ExplosiveCharge_tailForest_SoundShader",
			"ExplosiveCharge_tailMeadows_SoundShader",
			"ExplosiveCharge_tailHouses_SoundShader"
		};
		volumeFactor=0.4;
		volumeCurve="LinearCurve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Launcher_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"RocketsLight_tailForest_SoundShader",
			"RocketsLight_tailMeadows_SoundShader",
			"RocketsLight_tailHouses_SoundShader"
		};
		volumeFactor=0.4;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionLightTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Mines_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"APmine_tailForest_SoundShader",
			"APmine_tailMeadows_SoundShader",
			"APmine_tailHouses_SoundShader"
		};
		volumeFactor=0.4;
		volumeCurve="LinearCurve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_IED_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"BigIED_tailForest_SoundShader",
			"BigIED_tailMeadows_SoundShader",
			"BigIED_tailHouses_SoundShader"
		};
		volumeFactor=0.5;
		volumeCurve="LinearCurve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionHeavyTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Mortar_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"Mortar_tailForest_SoundShader",
			"Mortar_tailMeadows_SoundShader",
			"Mortar_tailHouses_SoundShader"
		};
		volumeFactor=0.5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionMediumTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Artillery_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"Shell155mm_tailForest_SoundShader",
			"Shell155mm_tailMeadows_SoundShader",
			"Shell155mm_tailHouses_SoundShader"
		};
		volumeFactor=0.5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionHeavyTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	class Squad_Bombs_Tail_Explosions_Set
	{
		soundShaders[]=
		{
			"BombsHeavy_tailForest_SoundShader",
			"BombsHeavy_tailMeadows_SoundShader",
			"BombsHeavy_tailHouses_SoundShader"
		};
		volumeFactor=0.5;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=0;
		loop=0;
		soundShadersLimit=2;
		frequencyRandomizer=0.050000001;
		sound3DProcessingType="ExplosionHeavyTail3DProcessingType";
		distanceFilter="explosionTailDistanceFreqAttenuationFilter";
	};
	
};
*/