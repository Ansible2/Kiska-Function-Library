/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim

Description:
    Provides an updated version of BIS_fnc_ambientAnim in a tighter package that
     allows for more customization.

Parameters:
    0: _units <OBJECT[] or OBJECT> - An array of units or a single unit to animate
    1: _animationParams <HASHMAP, STRING[], (STRING,NUMBER)[], or STRING> - This can be three things:
        
        - If a string, a single animation set that is located in the _animationMap
        - If an array, you can have weighted or unweighted array of strings that are random animation sets to select from
        - lastly, you can have a HASHMAP setup for snap to animations:
         
            - _animSet <STRING[], (STRING,NUMBER)[], or STRING> - A single snapto animation set or weighted/unweighted array to randomly select from.
            - _snapToRange <NUMBER> - This is how far will be searched around the unit to find an object to "snap" onto. Cannot be more then 10m.
            - _backupAnims <STRING[], (STRING,NUMBER)[], or STRING> - Same as _snapToAnimationSet but for animations to use in the even that 
            ALL of the _snapToAnimationSet animations fail to be used due to valid objects not being within range.
            - _fallbackFunction <CODE, ARRAY, or STRING> - (See KISKA_fnc_callBack) In the event that
            a unit is not able to find an object to snap to AND1 no _backupAnims are present, this function will be called with the
            following params. If you still want the unit to be animated in this case, pass {}, "", or []
                
                - 0: _unit <OBJECT> - The unit
                - 1: _unitInfoMap <HASHMAP> - The current state of the _unitInfoMap which stores animation info for the system
                The rest of these params are exactly as passed to the initial KISKA_fnc_ambientAnim call
                - 2: _animationParams <ARRAY, STRING[], (STRING,NUMBER)[], or STRING>
                - 3: _exitOnCombat <BOOL>
                - 4: _equipmentLevel <ARRAY or STRING>
                - 5: _animationMap <HASHMAP or CONFIG>

    2: _exitOnCombat <BOOL> - True for unit to return to the state it was in prior to
        KISKA_fnc_ambientAnim being called when they are enter combat behaviour.
    3: _equipmentLevel <STRING> - A quick means of temporarily adjusting a unit's equipment to match a scene. Options:
        
        - "": no changes
        - "NONE": no goggles, headgear, vest, weapon, nvgs, backpack
        - "LIGHT": no goggles, headgear, vest, backpack
        - "MEDIUM": no goggles, headgear
        - "FULL": no goggles

    4: _animationMap <HASHMAP or CONFIG> - See KISKA_fnc_ambientAnim_createMapFromConfig
        This is a hashmap that will searched for information for a specific _animSet
        A config can be passed and will be parsed/cached.

Returns:
    NOTHING

Examples:
    (begin example)
        // exits on combat
        [
            someUnit,
            "SIT_GROUND_ARMED",
            true
        ] call KISKA_fnc_ambientAnim;
    (end)

    (begin example)
        [
            someUnit,
            "SIT_GROUND_UNARMED"
        ] call KISKA_fnc_ambientAnim;
    (end)

    (begin example)
        // snap to object valid chair, if not use STAND_ARMED_1
        [
            someUnit,
            [
                ["SIT_CHAIR_ARMED_1",1],
                10,
                "STAND_ARMED_1"
            ]
        ] call KISKA_fnc_ambientAnim_test;
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim";
// TODO: handle remote units being passed
// TODO: Add supplemental animation sets by using polpox animation viewer
// TODO: Add LEAN_ON_TABLE animation set

#define DEFAULT_ANIMATION_MAP (configFile >> "KISKA_AmbientAnimations" >> "DefaultAnimationMap")

private _comparisonMap = createHashMap;
params [
    ["_units",objNull,[[],objNull]],
    ["_animationParams","",["",[],_comparisonMap]],
    ["_exitOnCombat",false,[true]],
    ["_equipmentLevel","",["",[]]],
    ["_animationMap",DEFAULT_ANIMATION_MAP,[createHashMap,configNull]]
];


private ["_fallbackFunction","_snapToRange","_animSet","_backupAnims"];
private _fallbackFunctionIsPresent = false;
private _isSnapAnimations = _animationParams isEqualType _comparisonMap;
private _parsedSnapToMapErrors = [];

if !(_isSnapAnimations) then {
    _animSet = _animationParams;

} else {
    _animSet = _animationParams getOrDefault ["_animSet",""];
    if !(_animSet isEqualTypeAny ["",[]]) then {
        _parsedSnapToMapErrors pushBack ((str _animSet) + " is not a valid type for _animSet (STRING or ARRAY)");
    };

    _snapToRange = _animationParams getOrDefault ["_snapToRange",5];
    if !(_snapToRange isEqualType 123) then {
        _parsedSnapToMapErrors pushBack ((str _snapToRange) + " is not a valid type for _snapToRange (NUMBER)");
    };

    _backupAnims = _animationParams getOrDefault ["_backupAnims",""];
    if !(_backupAnims isEqualTypeAny ["",[]]) then {
        _parsedSnapToMapErrors pushBack ((str _backupAnims) + " is not a valid type for _backupAnims (STRING or ARRAY)");
    };

    _fallbackFunction = _animationParams getOrDefault ["_fallbackFunction",{}];
    if !(_fallbackFunction isEqualTypeAny ["",{},[]]) then {
        _parsedSnapToMapErrors pushBack ((str _fallbackFunction) + " is not a valid type for _fallbackFunction (STRING, CODE, or ARRAY)");
    };



    if (_parsedSnapToMapErrors isNotEqualTo []) exitWith {};
    
    if (_snapToRange > 10) then { _snapToRange = 10 };
    _fallbackFunctionIsPresent = _fallbackFunction isNotEqualTo {} AND
        _fallbackFunction isNotEqualTo [] AND
        _fallbackFunction isNotEqualTo "";
};


/* ----------------------------------------------------------------------------

    Verify params

---------------------------------------------------------------------------- */
if (_parsedSnapToMapErrors isNotEqualTo []) exitWith {
    [["Errors with snap animation map:",_parsedSnapToMapErrors]] call KISKA_fnc_log;
    nil
};

if (_units isEqualTo []) exitWith {
    ["Empty _units array passed!", true] call KISKA_fnc_log;
    nil
};

private _isObject = _units isEqualType objNull;
if (_isObject AND {isNull _units}) exitWith {
    ["Null unit passed", true] call KISKA_fnc_log;
    nil
};

if (_isObject) then {
    _units = [_units];
};

private _animationMapIsConfig = _animationMap isEqualType configNull;
if (_animationMapIsConfig AND {isNull _animationMap}) exitWith {
    ["_animationMap is null config!", true] call KISKA_fnc_log;
    nil
};

if (_animationMapIsConfig) then {
    _animationMap = [_animationMap] call KISKA_fnc_ambientAnim_createMapFromConfig;
};


private _setsToVerify = _animSet;
private _isWeightedAnimSet = _animSet isEqualTypeParams ["",123];
if !(_animSet isEqualType []) then {
    _setsToVerify = [_animSet];
    if (_isSnapAnimations) then {
        _animSet = _setsToVerify;
    };
};

private _invalidSets = [];
{
    if (_isWeightedAnimSet) then {
        private _isWeightIndex = (_forEachIndex mod 2) isNotEqualTo 0;
        if ((_x isEqualType 123) AND _isWeightIndex) then {continue};
    };

    private _animationSetInfo = _animationMap getOrDefault [_x,[]] ;
    if (_animationSetInfo isEqualTo []) then {
        _invalidSets pushBack _x;
        continue;
    };

    if (!_isSnapAnimations) then {continue};

    if (_animationSetInfo getOrDefault ["snapToObjectsMap",[]] isEqualTo []) then {
        _invalidSets pushBack (_x + ":snapToObjectsMap_empty");
    };
} forEach _setsToVerify;

if (count _invalidSets > 0) exitWith {
    [["Invalid animation set(s) passed: ",_invalidSets],true] call KISKA_fnc_log;
    nil
};



/* ----------------------------------------------------------------------------

    Helper functions

---------------------------------------------------------------------------- */
private _fn_setupAnimation = {
    params ["_unitInfoMap","_animsToSelectFrom"];

    private _animSetSelection = _animsToSelectFrom;
    if (_animsToSelectFrom isEqualType []) then {
        _animSetSelection = [_animsToSelectFrom,""] call KISKA_fnc_selectRandom;
    };

    private _animationSetInfo = _animationMap getOrDefault [_animSetSelection,[]];
    _unitInfoMap set ["_animationSetInfo",_animationSetInfo];
};

private _fn_findObjectToSnapTo = {
    params ["_snapToObjectsMap","_objectsToCheck"];
    
    private _snapToObjectTypes = keys _snapToObjectsMap;
    private _snapToObjectInfo = [];
    _objectsToCheck apply {
        private _objectType = toLowerANSI (typeOf _x);
        private _objectInUse = !(isNull (_x getVariable ["KISKA_ambientAnim_objectUsedBy",objNull]));
        if (_objectInUse) then { continue };

        if (_objectType in _snapToObjectTypes) then { 
            _objectToSnapTo = _x;

        } else {
            private _parentTypeIndex = _snapToObjectTypes findIf {
                _objectType isKindOf _x;
            };
            private _objectNotSupportedForAnimationSet = _parentTypeIndex isEqualTo -1;
            if (_objectNotSupportedForAnimationSet) then { continue };
            
            _objectType = _snapToObjectTypes select _parentTypeIndex;
            _objectToSnapTo = _x;

        };


        private _vehicleConfigSnapAllowance = configFile >> "CfgVehicles" >> _objectType >> "KISKA_AmbientAnimations" >> "snapAllowance";
        private _configedSnapAllowance = getNumber(_vehicleConfigSnapAllowance);
        private _allowanceNotConfigedInMainConfig = _configedSnapAllowance isEqualTo 0;

        if (_allowanceNotConfigedInMainConfig) then {
            private _objectKiskaAnimationConfig = [
                ["KISKA_AmbientAnimations","ObjectSpecifics",_objectType]
            ] call KISKA_fnc_findConfigAny;
            if (isNull _objectKiskaAnimationConfig) exitWith {};

            _configedSnapAllowance = getNumber(_objectKiskaAnimationConfig >> "snapAllowance");
        };

        private _hasSnapAllowance = _configedSnapAllowance > 1;
        private _snapAllowanceInfo = [];

        if (_hasSnapAllowance) then {
            private _usedSnapIds = _x getVariable ["KISKA_ambientAnim_usedSnapIds",[]];
            if ((count _usedSnapIds) >= _configedSnapAllowance) then { 
                [[
                    "_usedSnapIds has been used up for object: ",_x,
                    " current is ",_usedSnapIds,
                    " and config is ",_configedSnapAllowance
                ]] call KISKA_fnc_log;

                continue; 
            };

            private _objectSnapPointsHashMap = _snapToObjectsMap get _x;
            {
                if (_x in _usedSnapIds) then { continue };

                if (_x isEqualType []) then { 
                    private _someIdsAlreadyBeingUsed = (_x arrayIntersect _usedSnapIds) isNotEqualTo [];
                    if (_someIdsAlreadyBeingUsed) then { continue };
                };

                _snapAllowanceInfo pushBack _x;
                _snapAllowanceInfo pushBack _y;
            } forEach _objectSnapPointsHashMap;

        };
        
        _snapToObjectInfo pushBack _objectType;
        _snapToObjectInfo pushBack _objectToSnapTo;
        if (_snapAllowanceInfo isNotEqualTo []) then {
            _snapToObjectInfo pushBack _snapAllowanceInfo;
        };

    };


    _snapToObjectInfo
};

private _fn_handleNoSnap = {
    params ["_unit","_unitInfoMap"];

    if (_backupAnims isNotEqualTo []) exitWith {
        [_unitInfoMap,_backupAnims] call _fn_setupAnimation;
    };

    
    if (!_fallbackFunctionIsPresent) exitWith {};
    [
        [
            _unit, _unitInfoMap,
            _animationParams,
            _exitOnCombat,
            _equipmentLevel,
            _animationMap
        ],
        _fallbackFunction
    ] call KISKA_fnc_callBack;
};


// accept that only one set can be be tried from the primary
// Try extremely hard to dynamically exclude sets from the array (the array can be weighted)
// shuffle the entire array each time and loop through every set (this would also be hard with weighted arrays)
// delete one random entry at a time and eventually make the array anew
private _fn_setupAnimationWithSnap = {
    params ["_unit","_unitInfoMap"];

    // using nearObjects to support snapping to simple objects
    private _nearObjects = _unit nearObjects _snapToRange;
    if (_nearObjects isEqualTo []) exitWith {
        [["No near objects to snap to ",_unit]] call KISKA_fnc_log;
        [_unit, _unitInfoMap] call _fn_handleNoSnap;
    };  


    private ["_animSetSelection","_snapToObjectsMap"];
    private _snapToObjectInfo = [];
    private _checkedAnimSets = [];
    private _step = [1,2] select _isWeightedAnimSet;
    for "_i" from 1 to (count _animSet) step _step do { 
        if (_isWeightedAnimSet) then {
            [["_animSet is: ",_animSet]] call KISKA_fnc_log;
            _animSetSelection = [_animSet,""] call KISKA_fnc_selectRandom;
            private _indexOfSelectedAnim = _animSet find _animSetSelection;
            _animSet deleteAt _indexOfSelectedAnim;
            _checkedAnimSets pushBack _animSetSelection;
            
            // previous deleteAt will shift the weight into the anim's former index
            private _animWeight = _animSet deleteAt _indexOfSelectedAnim;
            _checkedAnimSets pushBack _animWeight;

        } else {
            _animSetSelection = [_animSet] call KISKA_fnc_deleteRandomIndex;
            _checkedAnimSets pushBack _animSetSelection;

        };

        private _animationSetInfo = _animationMap get _animSetSelection;
        _snapToObjectsMap = _animationSetInfo get "snapToObjectsMap";        
        // loop
        _snapToObjectInfo = [_snapToObjectsMap, _nearObjects] call _fn_findObjectToSnapTo;

        if (_snapToObjectInfo isNotEqualTo []) then {
            _unitInfoMap set ["_animationSetInfo",_animationSetInfo];
            break;
        };
    };
    // _animSet array may be used by other units, so "restore" it
    _animSet append _checkedAnimSets;



    if (_snapToObjectInfo isEqualTo []) exitWith {
        [_unit, _unitInfoMap] call _fn_handleNoSnap;
    };
    


    _snapToObjectInfo params ["_objectType","_objectToSnapTo","_snapAllowanceInfo"];

    _unitInfoMap set ["_snapToObject",_objectToSnapTo];
    [_unit,_objectToSnapTo] remoteExecCall ["disableCollisionWith",_unit];
    [_objectToSnapTo,_unit] remoteExecCall ["disableCollisionWith",_objectToSnapTo];

    if (isNil "_snapAllowanceInfo") then {
        _objectToSnapTo setVariable ["KISKA_ambientAnim_objectUsedBy",_unit];
        private _relativeObjectInfo = _snapToObjectsMap get _objectType;
        [_objectToSnapTo,_unit,_relativeObjectInfo] call KISKA_fnc_setRelativeVectorAndPos;

    } else {
        private _usedSnapIds = _objectToSnapTo getVariable "KISKA_ambientAnim_usedSnapIds";
        if (isNil "_usedSnapIds") then {
            _usedSnapIds = [];
            _objectToSnapTo setVariable ["KISKA_ambientAnim_usedSnapIds",_usedSnapIds];
        };

        _snapAllowanceInfo params ["_snapIdsToUse","_relativeObjectInfo"];
        if (_snapIdsToUse isEqualType 123) then {
            _usedSnapIds pushBack _snapIdsToUse;
        } else {
            _usedSnapIds append _snapIdsToUse;
        };
        [_objectToSnapTo,_unit,_relativeObjectInfo] call KISKA_fnc_setRelativeVectorAndPos;
        
        _unitInfoMap set ["_usedSnapIds",_snapIdsToUse];
    };

};



/* ----------------------------------------------------------------------------

    Apply Animations

---------------------------------------------------------------------------- */
private _randomEquipmentLevel = _equipmentLevel isEqualType [];
_units apply {
    private _unit = _x;
    if !(alive _unit) then {
        continue;
    };

    private _unitIsAnimated = !(isNil {_unit getVariable "KISKA_ambientAnimMap"});
    if (_unitIsAnimated) then {
        [_unit] call KISKA_fnc_ambientAnim_stop;
    };

    private _unitInfoMap = createHashmap;
    detach _unit;
 
    if (_isSnapAnimations) then {
        [_unit,_unitInfoMap] call _fn_setupAnimationWithSnap;

    } else {
        [_unitInfoMap,_animSet] call _fn_setupAnimation;

    };
    
    private _animationSetInfo = _unitInfoMap get "_animationSetInfo";

    /* --------------------------------------
        Handle AttachTo Logic
        // some animations (STAND_ARMED_1)
        // will wind up stuttering if not attached to a logic.
        // this also happens with BIS_fnc_ambientAnim.
        // unknown why.

        // This does also benefit some seated animations if required.
    -------------------------------------- */
    if (_animationSetInfo getOrDefault ["attachToLogic",false]) then {
        private _logicGroup = [_x] call KISKA_fnc_ambientAnim_getNearestAttachLogicGroup;
        if (isNull _logicGroup) then {
            _logicGroup = createGroup sideLogic;
            _logicGroup deleteGroupWhenEmpty true;
            _logicGroup addEventHandler ["Deleted",{
                params ["_group"];
                
                private _mapId = _group getVariable ["KISKA_ambientAnimGroup_ID",-1];
                if (_mapId >= 0) then {
                    private _logicGroupsMap = call KISKA_fnc_ambientAnim_getAttachLogicGroupsMap;
                    _logicGroupsMap deleteAt _mapId;
                };
            }];

            [_logicGroup] call KISKA_fnc_ambientAnim_addAttachLogicGroup;
        };

        private _helper = _logicGroup createUnit ["Logic", [0,0,0], [], 0, "NONE"];
        _helper setPosWorld (getPosWorld _unit);
        _helper setVectorDir (vectorDir _unit);
        _helper setVectorUp (vectorUp _unit);

        _unitInfoMap set ["_attachToLogic",_helper];
        _unit attachTo [_helper,[0,0,0]];
    };


    /* --------------------------------------
        Handle Equipment
    -------------------------------------- */
    private _unitLoadout = getUnitLoadout _unit;
    private _loadoutAdjusted = false;

    private _removeAllWeapons = _animationSetInfo getOrDefault ["removeAllWeapons",false];
    if (_removeAllWeapons) then {
        removeAllWeapons _unit;
        _loadoutAdjusted = true;
    };

    private _removeBackpack = _animationSetInfo getOrDefault ["removeBackpack",false];
    if (_removeBackpack) then {
        removeBackpack _unit;
        _loadoutAdjusted = true;
    };

    private _removeNightVision = _animationSetInfo getOrDefault ["removeNightVison",false];
    if (_removeNightVision) then {
        removeAllAssignedItems _unit;
        _loadoutAdjusted = true;
    };

    private _equipmentLevelSelection = _equipmentLevel;
    if (_randomEquipmentLevel) then {
        _equipmentLevelSelection = [_equipmentLevel,""] call KISKA_fnc_selectRandom;
    };
    switch (_equipmentLevelSelection) do
    {
        case "NONE":
        {
            removeGoggles _unit;
            removeHeadgear _unit;
            removeVest _unit;
            removeAllWeapons _unit;
            removeBackpack _unit;
            removeAllAssignedItems _unit;
            _loadoutAdjusted = true;
        };
        case "LIGHT":
        {
            removeGoggles _unit;
            removeHeadgear _unit;
            removeVest _unit;
            removeBackpack _unit;
            _loadoutAdjusted = true;
        };
        case "MEDIUM":
        {
            removeGoggles _unit;
            removeHeadgear _unit;
            _loadoutAdjusted = true;
        };
        case "FULL":
        {
            removeGoggles _unit;
            _loadoutAdjusted = true;
        };
        default
        {
        };
    };

    if (_loadoutAdjusted) then {
        _unitInfoMap set ["_unitLoadout",_unitLoadout];
    };

    ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"] apply {
        [_unit,_x] remoteExecCall ["disableAI",_unit];
    };


    private _baseJipId = "KISKA_AmAnim_" + (str _unit);
    _unitInfoMap set ["KISKA_ambientAnim_JIPId_switchMove",(_baseJipId + "_sm")];
    _unitInfoMap set ["KISKA_ambientAnim_JIPId_playMoveNow",(_baseJipId + "_pmn")];

    /* --------------------------------------
        Initial Animate
    -------------------------------------- */
    _unit setVariable ["KISKA_ambientAnimMap",_unitInfoMap];
    [_unit] call KISKA_fnc_ambientAnim_play;


    /* --------------------------------------
        Add Eventhandlers
    -------------------------------------- */
    private _animDoneEventHandlerId = _unit addEventHandler ["AnimDone",
        {
            params ["_unit","_anim"];

            if (alive _unit) then {
                _this call KISKA_fnc_ambientAnim_play;
            };
        }
    ];
    _unitInfoMap set ["_animDoneEventHandlerId",_animDoneEventHandlerId];


    private _unitKilledEventHandlerId = _unit addEventHandler ["KILLED",
        {
            params ["_unit"];
            [_unit,false] call KISKA_fnc_ambientAnim_stop;
        }
    ];
    _unitInfoMap set ["_unitKilledEventHandlerId",_unitKilledEventHandlerId];


    private _unitDeletedEventHandlerId = _unit addEventHandler ["Deleted",
        {
            params ["_unit"];
            [_unit,true] call KISKA_fnc_ambientAnim_stop;
        }
    ];
    _unitInfoMap set ["_unitDeletedEventHandlerId",_unitDeletedEventHandlerId];


    if (_exitOnCombat) then {
        private _behaviourEventId = [
            _unit,
            (configFile >> "KISKA_eventHandlers" >> "Behaviour"),
            {
                params ["_unit","_behaviour","_eventHandlerConfig"];

                if (_behaviour == "COMBAT") then {
                    [
                        _unit,
                        _eventHandlerConfig,
                        _thisScriptedEventhandler
                    ] call KISKA_fnc_eventHandler_remove;

                    [_unit] call KISKA_fnc_ambientAnim_stop;
                };
            }
        ] call KISKA_fnc_eventHandler_addFromConfig;

        _unitInfoMap set ["_behaviourEventId",_behaviourEventId];
    };


};


nil
