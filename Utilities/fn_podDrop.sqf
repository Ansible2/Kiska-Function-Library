/* ----------------------------------------------------------------------------
Function: KISKA_fnc_podDrop

Description:
	Drops a number of "pods" from a given altitude

Parameters:

	0: _caller <OBJECT> - The requester of the drop
	1: _classname <STRING> - The className of the pod
	2: _altittude <NUMBER> - Drop start height
	3. _numberOfPods <NUMBER> - Number of pods to drop, if -1 (default) it will be computed based on the number of players on the side / 2

Returns:
	_pods <ARRAY> - The created pods

Examples:
    (begin example)

		[player,"someClass", 500, -1] remoteExecCall ["KISKA_fnc_podDrop",2];

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!isServer) then {
	["reccomend server exectution"] call BIS_fnc_error;
};

params [
	["_caller",objNull,[objNull]],
	["_classname","OPTRE_ammo_SupplyPod_Empty",[""]],
	["_altittude",500,[1]],
	["_numberOfPods",-1,[1]]
];

if (_className isEqualTo "") exitWith {
	["_classname is empty STRING"] call BIS_fnc_error;
};

if (isNull _caller) exitWith {
	["_caller is a null OBJECT"] call BIS_fnc_error;
};

if (_numberOfPods < -1 OR {_numberOfPods isEqualTo 0}) exitWith {
	["Zero pods or not -1 _numberOfPods requested"] call BIS_fnc_error;
};

// determine number of pods if not specified
if (_numberOfPods isEqualTo -1 AND {count allPlayers > 1}) then {
	private _callerSide = side _caller;
	_numberOfPods = playersNumber _callerSide / 2;
} else {
	_numberOfPods = 1;
};

// create the pods about the position
private _pods = [];

for "_i" from 1 to _numberOfPods do {
	private _spawnPosition = getPosATL _caller vectorAdd [random 3,random 3,_altittude]; 

	private _pod = createVehicle [_classname, _spawnPosition, [], 10, "CAN_COLLIDE"];

	_pods pushBack _pod;
};


// add an arsenal to the pods
[_pods] call KISKA_fnc_addArsenal;


// notify them about drop
private _stringDropPosition = ["Drop is inbound to GRID:",str (mapGridPosition _caller)] joinString " ";

[_stringDropPosition] remoteExec ["Kiska_fnc_DataLinkMsg",[0,-2] select isDedicated];


_pods