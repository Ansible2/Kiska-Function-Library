/* ----------------------------------------------------------------------------
Function: KISKA_fnc_supplyDrop

Description:
	Spawns a supply drop near the requested position. Crates will parachute in.

Parameters:

	0: _classNames <ARRAY> - Classnames of boxes you want dropped. Also determines the number of crates
	1: _altittude <NUMBER> - Start height of drop
	2: _dropPosition <OBJECT, GROUP, ARRAY, LOCATION, TASK> - Position you want the drop to be near
	3. _radio <NUMBER> - This is used to get rid of the trigger if called from it as a limited support. 1 = ALPHA, 2 = BRAVO, etc. -1 for nothing

Returns:
	NOTHING

Examples:
    (begin example)

		[["className1","className2"]], 500, player, -1] call KISKA_fnc_supplyDrop;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!isServer) exitWith {};

params [
	["_classNames",[],[[]]],
	["_altittude",100,[1]],
    ["_dropPosition",objNull,[objNull,[],grpNull,locationNull,taskNull]],
	["_radio",-1,[1]]
];

if (_classNames isEqualTo []) exitWith {
	"No classnames passed!" call BIS_fnc_error;
};

if (_radio != -1) then {
	[_radio,"null"] remoteExec ["setRadioMsg",[0,-2] select isDedicated,true];
};

["Drop inbound."] remoteExec ["KISKA_fnc_dataLinkMsg",[0,-2] select isDedicated];



private _containersArray = [];
{
    // create Container
    private _container = createVehicle [_x,[0,0,0],[],0];
    _containersArray pushBack _container;

    // give the conatainer a random position above DZ
    private _dropZone = [_dropPosition,50] call CBA_fnc_randPos;
    _container setPosATL (_dropZone vectorAdd [random [-10,0,10],random [-10,0,10],_altittude]);
    
    // make it invincible
    [_container,false] remoteExec ["allowDamage",_container];

    // create it's parachutes
    private _chute = createVehicle ["b_parachute_02_F",[0,0,0]];
    _chute attachTo [_container,[0,0,0]];

    // then guide it to the ground with a velocity loop
    private _handle = [
        {
            private _container = (_this select 0) select 0;

            if !(attachedObjects _container isEqualTo []) then {
                private _velocitySpace = velocityModelSpace _container;
                _container setVelocityModelSpace [0,0,-25];
            };

            if ((getPosATLVisual _container select 2) < 20) then {
                detach ((_this select 0) select 1);
                [
                    {
                        params ["_container"];
                        [_container,true] remoteExec ["allowDamage",_container];
                        [_container,true] remoteExec ["enableDynamicSimulation",2];                        
                    },
                    [_container],
                    5  
                ] call CBA_fnc_waitAndExecute;

                [_this select 1] call CBA_fnc_removePerFrameHandler;
            };
        }, 
        1, 
        [_container,_chute]
    ] call CBA_fnc_addPerFrameHandler;

} forEach _classNames;

// add arsenals to crates
[_containersArray] call KISKA_fnc_addArsenal;

private _firstContainer = _containersArray select 0;
[
    2,
    {
        // create smoke and flare markers near DZ
        params ["_firstContainer"];

        private _position = [_firstContainer,10] call CBA_fnc_randPos;

        private _chemlight = createvehicle ["Chemlight_green_infinite",_position,[],0,"NONE"];
        private _smoke = createvehicle ["G_40mm_SmokeBlue_infinite",_position,[],0,"NONE"];
        private _flare = createvehicle ["F_40mm_Red",_position,[],0,"NONE"];
        
        // wait to delete markers
        [
            2,
            {
                private _chemlight = param [1];
                private _smoke = param [2];

                // delete markers, flare is temporary and therefore need not be deleteed
                [_chemlight,_smoke] apply {
                    if (!isNull _x) then {
                        deleteVehicle _x;
                    };
                };
                
            },
            {
                // waitUntil player is within 25m of the first container
                !(((call CBA_fnc_players) findIf {(_x distance2D (_this select 0)) < 25}) isEqualTo -1)
            },
            [_firstContainer,_chemlight,_smoke]
        ] call KISKA_fnc_waitUntil;
    },
    {(getPosATL (_this select 0)) select 2 < 2},
    [_firstContainer]
] call KISKA_fnc_waitUntil;