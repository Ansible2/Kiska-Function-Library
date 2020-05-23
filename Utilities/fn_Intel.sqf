//missionNamespace setVariable [_IntelVar, _IntelTitle, _Desc, _Pic, true];
//		Put this in object init:  
//     		_0 = [this, "Intel Title", "Intel Description", "picture file path, omit if you want default"] execVM "intel.sqf";
params [
	["_IntelVar",objNull,[objNull]], 													// the object that is the intel to pickup
	["_IntelTitle","Intel Title",[]], 													// title of the intel in map
	["_Desc","This is intel", []], 														// intel description in map
	["_Pic","a3\structures_f_epc\Items\Documents\Data\document_secret_01_co.paa", []],	// picture in the intel
	["_mkr","",[""]]																	// a corresponding map marker to setalpha 1.0
];

[_IntelVar] call BIS_fnc_initIntelObject;

if (isServer) then {
	
	//Diary picture
	_IntelVar setVariable [
		"RscAttributeDiaryRecord_texture",
		//Path to picture
		_pic,
		true
	];
	
	//Diary Title and Description
	[
		_IntelVar,
		"RscAttributeDiaryRecord",
		[_IntelTitle,_Desc,""]
	] call BIS_fnc_setServerVariable;
	
	//Diary entry shared with. follows BIS_fnc_MP target rules
	_IntelVar setVariable ["recipients", west, true]; //In the future, you may want to create a Param for the recipients side
	
	//Sides that can interact with intelObject
	_IntelVar setVariable ["RscAttributeOwners", [west], true];

	if !(_mkr isEqualTo "") then {
		_mkr setMarkerAlpha 1.0;
	};

};