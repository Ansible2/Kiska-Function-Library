// TODO: header comment
scriptName "KISKA_fnc_fastRopeEvent_onHoverStartedDefault";

#define ACE_ON_PREPARE "ace_fastroping_onPrepare"
#define ANIMS_HOOK ["extendHookRight", "extendHookLeft"]
#define ANIMS_ANIMATEDOOR ["door_R", "door_L", "CargoRamp_Open", "Door_rear_source", "Door_6_source", "CargoDoorR", "CargoDoorL"]
#define ANIMS_ANIMATE ["dvere1_posunZ", "dvere2_posunZ", "doors"]

params ["_vehicle"];

if !(alive _vehicle) exitWith {};

// TODO: 

nil