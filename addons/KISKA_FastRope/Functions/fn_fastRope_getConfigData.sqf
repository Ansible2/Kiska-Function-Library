/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_getConfigData

Description:
    Retrieves config data relevant to to fastroping. Has some interoperability 
     with similar properites configured for ACE fastroping. Values are cached
     after the first retrieval.

    Config data is expected to be defined inside a 
     `<CONFIG> >> "CfgVehicles" >> <VEHICLE-CLASS> >> "KISKA_fastRope"` config class.
     This can be under any config and will be located with `KISKA_fnc_findConfigAny`
     opting for the most specific. This allows consistent config overrides should
     one choose to do so instead of doing so through SQF.

    (begin config example)
        // inside description.ext
        class CfgVehicles
        {
            class B_Heli_Light_01_F
            {
                class KISKA_FastRope
                {
                    ropeOrigins[] = {"ropeOriginRight","ropeOriginLeft"};
                    friesType = "KISKA_FriesAnchorBar";
                    friesAttachmentPoint[] = {0,0.550,-0.007};
                };
            };
        };
    (end)
    
    Values that can be retireved:

    - "friesType" <STRING> : The vehicle class of a FRIES attachment point (basically hooks)
        that the ropes would hang from. If the bespoke KISKA property is not defined, 
        the ACE property `ace_fastrope_friesType` will also be searched for.
    - "ropeOrigins" <(PositionRelative[] | STRING)[]> : The relative position of 
        where the ropes should be attached to the FRIES object or in the case that
        no "friesType" is defined, the vehicle tself. Expected to be an array of
        relative positions and/or memory points to `attachTo`. If the bespoke KISKA
        property is not defined, the ACE property `ace_fastrope_ropeOrigins` will also
        be searched for.
    - "friesAttachmentPoint" <PositionRelative[]> : The relative position to use `attachTo`
        in order to attach the `friesType` to the fast roping vehicle. If the bespoke KISKA
        property is not defined, the ACE property `ace_fastrope_friesAttachmentPoint` will also
        be searched for.
    - "onHoverStarted" <STRING> : Uncompiled code that runs once the vehicle has (within ~2m) 
        reached the intended position that the vehicle will hover to fastrope units down.
        See the default implementation `KISKA_fnc_fastRopeEvent_onHoverStartedDefault`.
        `_this` will be the <HASHMAP> fastrope info map.
    - "onDropEnded" <STRING> : Uncompiled code that runs once the vehicle has severed the
        ropes from the vehicle. See the default implementation `KISKA_fnc_fastRopeEvent_onDropEndedDefault`.
        `_this` will be the <HASHMAP> fastrope info map.

Parameters:
    0: _vehicleConfig <OBJECT | CONFIG> - The vehicle that a fastrope will be conducted
        from or its config path.
    1: _dataToFetch <STRING> - The data to fetch from the config. CASE-SENSITIVE
        Options are: "friesType", "ropeOrigins", "friesAttachmentPoint", "

Returns:
    <STRING | ARRAY | CODE> - The configured value or compiled code for the config value.
    
Examples:
    (begin example)
        private _ropeOrigins = [
            (configOf MyVehicle),
            "ropeOrigins"
        ] call KISKA_fnc_fastRope_getConfigData;
    (end)

    (begin example)
        private _friesType = [
            MyVehicle,
            "friesType"
        ] call KISKA_fnc_fastRope_getConfigData;    
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_getConfigData";

#define FRIES_TYPE_KEY "friesType"
#define ROPE_ORIGINS_KEY "ropeOrigins"
#define FRIES_ATTACHMENT_POINT_KEY "friesAttachmentPoint"
#define ON_HOVER_STARTED_KEY "onHoverStarted"
#define ON_DROP_ENDED_KEY "onDropEnded"

#define ACE_ROPE_ORIGINS "ace_fastrope_ropeOrigins"
#define ACE_FRIES_TYPE "ace_fastrope_friesType"
#define ACE_FRIES_ATTACHMENT_POINT "ace_fastrope_friesAttachmentPoint"

params [
    ["_vehicleConfig",configNull,[configNull,objNull]],
    ["_dataToFetch","",[""]]
];

if (isNull _vehicleConfig) exitWith {};

if (_vehicleConfig isEqualType objNull) then {
    _vehicleConfig = configOf _vehicleConfig;
};

private _overallMap = localNamespace getVariable "KISKA_fastRope_dataCacheMap";
if (isNil "_overallMap") then {
    _overallMap = createHashMap;
    localNamespace setVariable ["KISKA_fastRope_dataCacheMap",_overallMap];
};

private _vehicleDataMap = _overallMap getOrDefaultCall [_vehicleConfig,{createHashMap},true];
private _dataValue = _vehicleDataMap get _dataToFetch;
if !(isNil "_dataValue") exitWith { _dataValue };

call {
    #define FIND_CONFIG_ANY(KEY) \
        [[ \
            "CfgVehicles", \
            configName _vehicleConfig, \
            "KISKA_fastRope", \
            KEY \
        ]] call KISKA_fnc_findConfigAny

    if (_dataToFetch isEqualTo ROPE_ORIGINS_KEY) exitWith {
        private _configOfData = FIND_CONFIG_ANY(ROPE_ORIGINS_KEY);
        if ( (isNull _configOfData) OR { !(isArray _configOfData) } ) then {
            _dataValue = getArray(_vehicleConfig >> ACE_ROPE_ORIGINS);
        } else {
            _dataValue = getArray _configOfData;
        };
    };

    if (_dataToFetch isEqualTo FRIES_TYPE_KEY) exitWith {
        private _configOfData = FIND_CONFIG_ANY(FRIES_TYPE_KEY);
        if ( (isNull _configOfData) OR { !(isText _configOfData) } ) then {
            _dataValue = getText(_vehicleConfig >> ACE_FRIES_TYPE);
        } else {
            _dataValue = getText _configOfData;
        };
    };

    if (_dataToFetch isEqualTo FRIES_ATTACHMENT_POINT_KEY) exitWith {
        private _configOfData = FIND_CONFIG_ANY(FRIES_ATTACHMENT_POINT_KEY);
        if ( (isNull _configOfData) OR { !(isArray _configOfData) } ) then {
            _dataValue = getArray(_vehicleConfig >> ACE_FRIES_ATTACHMENT_POINT);
            if (_dataValue isEqualTo []) then {
                _dataValue = [0,0,0];
            };
        } else {
            _dataValue = getArray _configOfData;
        };
    };

    if (_dataToFetch isEqualTo ON_HOVER_STARTED_KEY) exitWith {
        private _onHoverStartedConfig = FIND_CONFIG_ANY(ON_HOVER_STARTED_KEY);
        if (isText _onHoverStartedConfig) then {
            _dataValue = compileFinal (getText _onHoverStartedConfig);
        } else {
            _dataValue = {};
        };
    };

    if (_dataToFetch isEqualTo ON_DROP_ENDED_KEY) exitWith {
        private _onDropEndedConfig = FIND_CONFIG_ANY(ON_DROP_ENDED_KEY);
        if (isText _onDropEndedConfig) then {
            _dataValue = compileFinal (getText _onDropEndedConfig);
        } else {
            _dataValue = {};
        };
    };
};

if (isNil "_dataValue") exitWith {
    [["Unexpected _dataToFetch -> ",_dataToFetch],true] call KISKA_fnc_log;
    nil
};


_vehicleDataCacheMap set [_dataToFetch, _dataValue];
_dataValue
