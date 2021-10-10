params [
	["_caller",objNull,[objNull]],
	["_cooldown",30,[1]]
];

private _lase = laserTarget _caller;

// Check if MAC is online
if (!(missionNamespace getVariable ["kiska_MAC_online",false])) exitWith {["MAC Strike is OFFLINE"] call Kiska_fnc_DataLinkMsg};

// Check lasing target
if (isNull _lase) exitWith {"Must Lase Target" remoteExec ["hint", _caller];};

// Check if gun is ready
if (!(missionNamespace getVariable ["kiska_MAC_Ready",true])) exitWith {["Reloading"] call Kiska_fnc_DataLinkMsg};

// Gun is not ready anymore
missionNamespace setVariable ["kiska_MAC_Ready", false, true];

[(getPosASL _lase) vectorAdd [50,500,2000],"ammo_Missile_Cruise_01",_lase,300,true,[0,0,0.25],5,"",true,100] spawn Kiska_fnc_Homing;
		
["Shot Out"] call Kiska_fnc_DataLinkMsg;

[
	{
		// Check if MAC is online, tell caller if it's not
		private _caller = _this select 0;
		
		if (!(missionNamespace getVariable ["kiska_MAC_online",false])) exitWith {
			
			["MAC Strike is OFFLINE."] call Kiska_fnc_DataLinkMsg;

			private _objectsAssignedMAC = missionNamespace getVariable ["KISKA_assigned_MACAction",[]];

			if !(_objectsAssignedMAC isEqualTo []) then {
				_objectsAssignedMAC apply {
					private _object = _x;
					[_object] remoteExecCall ["Kiska_fnc_MACStrike_REM",_object];
				};
			};
			
		};
	}, 
	[_caller], 
	10
] call CBA_fnc_waitAndExecute;



[format ["Next round ETA %1%2",_cooldown,"s"],11] call Kiska_fnc_DataLinkMsg;

[
	{	
		["Gun Ready"] call Kiska_fnc_DataLinkMsg;
		missionNamespace setVariable ["kiska_MAC_Ready", true, true];
	}, 
	[], 
	(_cooldown + 10)
] call CBA_fnc_waitAndExecute;
		
