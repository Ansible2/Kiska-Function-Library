/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim

Description:
    Provides an updated version of BIS_fnc_ambientAnim in a tigher package that
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
            > "" - no changes
            > "NONE" - no goggles, headgear, vest, weapon, nvgs, backpack
            > "LIGHT" - no goggles, headgear, vest, backpack
            > "MEDIUM" - no goggles, headgear
            > "FULL" - no goggles
	4: _snapToRange <NUMBER> - Certain animations (such as sitting in a chair) can
        be configured to orient the unit onto certain object types. This is how far
        will be searched around the unit to find an object to "snap" onto.
	5: _animationMap <HASHMAP or CONFIG> - See KISKA_fnc_ambientAnim_createMapFromConfig
        This is a hashmap that will searched for information for a specific _animSet
        _animset. A config can be passed and will be parsed/cached.

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

params [
    ["_units",objNull,[[],objNull]],
    ["_animSet","",["",[]]],
    ["_exitOnCombat",false,[true]],
    ["_equipmentLevel","",["",[]]],
    ["_snapToRange",5,[123]],
    ["_animationMap",DEFAULT_ANIMATION_MAP,[createHashMap,configNull]]
];

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

private _randomAnimSet = _animset isEqualType [];
private _randomEquipmentLevel = _equipmentLevel isEqualType [];


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
    /* --------------------------------------
        Get Animation Set Info
    -------------------------------------- */
    private _animSetSelection = _animset;
    if (_randomAnimSet) then {
        _animSetSelection = [_animSet,""] call KISKA_fnc_selectRandom;
    };
    private _animationSetInfo = _animationMap getOrDefault [_animSetSelection,[]];
    if (_animationSetInfo isEqualTo []) then {
        [["Empty animation set provided: ", _animSetSelection], true] call KISKA_fnc_log;
        continue;
    };
    _unitInfoMap set ["_animationSetInfo",_animationSetInfo];


    /* --------------------------------------
        Handle Object Snapping
    -------------------------------------- */
    detach _unit;
    private _snapToObjectsMap = _animationSetInfo getOrDefault ["snapToObjectsMap",[]];
    private _canSnap = _snapToRange > 0;
    if (_canSnap AND (_snapToObjectsMap isNotEqualTo [])) then {
        private _types = keys _snapToObjectsMap;

        private _nearestObjects = nearestObjects [_unit, _types, _snapToRange, true];
        _nearestObjects apply {
            private _unitUsing = _x getVariable ["KISKA_ambientAnim_objectUsedBy",objNull];
            if !(isNull _unitUsing) then {
                continue;
            };

            _x setVariable ["KISKA_ambientAnim_objectUsedBy",_unit];
            _unitInfoMap set ["_snapToObject",_x];

            private _relativeObjectInfo = _snapToObjectsMap get (typeOf _x);
            _unit disableCollisionWith _x;
            [_x,_unit,_relativeObjectInfo] call KISKA_fnc_setRelativeVectorAndPos;

            break;
        };
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
        _unit disableAI _x;
    };


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

    _unit setVariable ["KISKA_ambientAnimMap",_unitInfoMap];
    [_unit] call KISKA_fnc_ambientAnim_play;
};


nil
