/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim

Description:
    Provides an updated version of BIS_fnc_ambientAnim in a tighter package that
     allows for more customization.

Parameters:
	0: _units <ARRAY or OBJECT> - An array of units or a single unit to animate
	1: _animSet <ARRAY or STRING> - An array of animation set names (strings) that are located in the
        _animationMap or a single animation set. The array can be weighted or unweighted.
        (see selectRandomWeighted single array syntax)
	2: _exitOnCombat <BOOL> - True for unit to return to the state it was in prior to
        KISKA_fnc_ambientAnim being called when they are enter combat behaviour.
	3: _equipmentLevel <STRING> - A quick means of temporarily adjusting a unit's equipment
        to match a scene. Options:

        - "": no changes
        - "NONE": no goggles, headgear, vest, weapon, nvgs, backpack
        - "LIGHT": no goggles, headgear, vest, backpack
        - "MEDIUM": no goggles, headgear
        - "FULL": no goggles

	4: _snapToRange <NUMBER> - Certain animations (such as sitting in a chair) can
        be configured to orient the unit onto certain object types. This is how far
        will be searched around the unit to find an object to "snap" onto. Cannot be more then 10m.
    5: _fallbackFunction <CODE, ARRAY, or STRING> - (See KISKA_fnc_callBack) In the event that
        a unit is not able to find an object to snap to, this function will be called with the
        following params. If you still want the unit to be animated in this case, pass {}, "", or [].

            0. _animSetSelection <STRING> - The animation that failed to find a snap to object
            1. _unit <OBJECT> - The unit
            // the rest of these params are exactly as passed to the initial KISKA_fnc_ambientAnim call
            2. _animSet <ARRAY or STRING>
            3. _exitOnCombat <BOOL>
            4. _equipmentLevel <ARRAY or STRING>
            5. _snapToRange <NUMBER>
            6. _fallbackFunction <CODE, ARRAY, or STRING>
            7. _animationMap <HASHMAP or CONFIG>

	6: _animationMap <HASHMAP or CONFIG> - See KISKA_fnc_ambientAnim_createMapFromConfig
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

Author(s):
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim";
// TODO: handle remote units being passed
// TODO: Add supplemental animation sets by using polpox animation viewer
// TODO: Add LEAN_ON_TABLE animation set

#define DEFAULT_ANIMATION_MAP (configFile >> "KISKA_AmbientAnimations")
isEqual
params [
    ["_units",objNull,[[],objNull]],
	["_animationParams","",["",[]]],
    ["_exitOnCombat",false,[true]],
    ["_equipmentLevel","",["",[]]],
    ["_animationMap",DEFAULT_ANIMATION_MAP,[createHashMap,configNull]]
];

private _isRandomAnimationSet = (count _animationParams > 1) AND (_animationParams isEqualTypeAll "");

private ["_fallbackFunction","_snapToRange","_animSet","_backupAnims"];
private _fallbackFunctionIsPresent = false;
private _isSnapAnimations = false;
if ((_animationParams isEqualType "") OR _isRandomAnimationSet) then {
	_animSet = _animationParams;

} else {
	_snapAnimationParams params [
		["_animSetParam","",["",[]]],
		["_snapToRangeParam",5,[123]],
		["_backupAnimsParam","",["",[]]],
		["_fallbackFunctionParam",{},[[],"",{}]]
	];

	_animSet = _animSetParam;
	_snapToRange = _snapToRangeParam;
	_backupAnims = _backupAnimsParam;
	_fallbackFunction = _fallbackFunctionParam;
	_isSnapAnimations = true;

	if (_snapToRange > 10) then {
		_snapToRange = 10;
	};

	_fallbackFunctionIsPresent = _fallbackFunction isNotEqualTo {} AND
		_fallbackFunction isNotEqualTo [] AND
		_fallbackFunction isNotEqualTo "";
};


/* ----------------------------------------------------------------------------

    Verify params

---------------------------------------------------------------------------- */
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


private _randomAnimSet = _animSet isEqualType [];
private _randomEquipmentLevel = _equipmentLevel isEqualType [];


private _setsToVerify = _animSet;
if (!_randomAnimSet) then {
	_setsToVerify = [_animSet]
};

private _invalidSets = [];
_setsToVerify apply {
	if (_animationMap getOrDefault [_x,[]] isEqualTo []) then {
		_invalidSets pushBack _x;
	};
};

if (count _invalidSets > 0) exitWith {
	[["Invalid animation set(s) passed: ",_invalidSets],true] call KISKA_fnc_log;
	nil
};



/* ----------------------------------------------------------------------------

    Helper functions

---------------------------------------------------------------------------- */
private _setupAnimation = {
	params ["_unitInfoMap","_animSet","_randomAnimSet"];

    private _animSetSelection = _animSet;
    if (_randomAnimSet) then {
        _animSetSelection = [_animSet,""] call KISKA_fnc_selectRandom;
    };

    private _animationSetInfo = _animationMap getOrDefault [_animSetSelection,[]];
    _unitInfoMap set ["_animationSetInfo",_animationSetInfo];

};

private _setupAnimationWithSnap = {
	params ["_unitInfoMap","_animSet","_randomAnimSet","_unit"];

    private _animSetSelection = _animSet;
    if (_randomAnimSet) then {
        _animSetSelection = [_animSet,""] call KISKA_fnc_selectRandom;
    };

    private _animationSetInfo = _animationMap getOrDefault [_animSetSelection,[]];
    _unitInfoMap set ["_animationSetInfo",_animationSetInfo];
};


/* ----------------------------------------------------------------------------

    Apply Animations

---------------------------------------------------------------------------- */
_units apply {
    private _unit = _x;
    if !(alive _unit) then {
        continue;
    };

    private _unitIsAnimated = (_unit getVariable ["KISKA_ambientAnimMap",[]]) isNotEqualTo [];
    if (_unitIsAnimated) then {
        [_unit] call KISKA_fnc_ambientAnim_stop;
    };

    private _unitInfoMap = createHashmap;
	detach _unit;
 
	if (_isSnapAnimations) then {
		[
			_unitInfoMap,
			_animSet,
			_randomAnimSet
		] call _setupAnimation;

	} else {
		[
			_unitInfoMap,
			_animSet,
			_randomAnimSet
		] call _setupAnimationWithSnap;

	};

    /* --------------------------------------
        Handle Object Snapping
    -------------------------------------- */
    detach _unit;
    private _snapToObjectsMap = _animationSetInfo getOrDefault ["snapToObjectsMap",[]];
    if (_isSnapAnimations AND (_snapToObjectsMap isNotEqualTo [])) then {
        private _types = keys _snapToObjectsMap;

        // using nearObjects to support snapping to simple objects
        private _nearObjects = _unit nearObjects _snapToRange;
        private _didSnap = false;
        _nearObjects apply {
            private _unitUsing = _x getVariable ["KISKA_ambientAnim_objectUsedBy",objNull];
            if !(isNull _unitUsing) then {
                continue;
            };

            private _objectType = toLowerANSI (typeOf _x);
            if !(_objectType in _types) then {
                private _parentTypeIndex = _types findIf {
                    _objectType isKindOf _x;
                };

                if (_parentTypeIndex isEqualTo -1) then {
                    continue;
                };

                _objectType = _types select _parentTypeIndex;
            };

            _x setVariable ["KISKA_ambientAnim_objectUsedBy",_unit];
            _unitInfoMap set ["_snapToObject",_x];

            private _relativeObjectInfo = _snapToObjectsMap get _objectType;
            [_unit,_x] remoteExecCall ["disableCollisionWith",_unit];
            [_x,_unit] remoteExecCall ["disableCollisionWith",_x];
            [_x,_unit,_relativeObjectInfo] call KISKA_fnc_setRelativeVectorAndPos;
            _didSnap = true;

            break;
        };

        if ((!_didSnap) AND _fallbackFunctionIsPresent) then {
            [
                [
                    _animSetSelection,
                    _unit,
                    _animSet,
                    _exitOnCombat,
                    _equipmentLevel,
                    _snapToRange,
                    _fallbackFunction,
                    _animationMap
                ],
                _fallbackFunction
            ] call KISKA_fnc_callBack;

            continue;
        };
    };

    /* --------------------------------------
        Handle AttachTo Logic
        // some animations (STAND_ARMED_1)
        // will wind up stuttering if not attached to a logic.
        // this also happens with BIS_fnc_ambientAnim.
        // unknown why.

        // This does also benefit some seated animations if required.
    -------------------------------------- */
    if (_animationSetInfo getOrDefault ["attachToLogic",false]) then {
        private _logicGroup = call KISKA_fnc_ambientAnim_getAttachToLogicGroup;
        if (isNull _logicGroup) then {
            _logicGroup = createGroup sideLogic;
            [_logicGroup] call KISKA_fnc_ambientAnim_setAttachToLogicGroup;
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

            } else {
                [_unit] call KISKA_fnc_ambientAnim_stop;

            };
        }
    ];
    _unitInfoMap set ["_animDoneEventHandlerId",_animDoneEventHandlerId];


    private _unitKilledEventHandlerId = _unit addEventHandler ["KILLED",
        {
            params ["_unit"];
            [_unit] call KISKA_fnc_ambientAnim_stop;
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
