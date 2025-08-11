/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRopeEvent_getConfigData

Description:
    // TODO:

Parameters:
    0: _vehicleConfig <OBJECT | CONFIG> - The vehicle that a fastrope will be conducted
        from or its config path.
    1: _dataToFetch <STRING> - The data to fetch from the config. CASE-SENSITIVE

Returns:
    // TODO:
    
Examples:
    (begin example)
        private _ropeOrigins = [
            (configOf MyVehicle),
            "ropeOrigins"
        ] call KISKA_fnc_fastRopeEvent_getConfigData;
    (end)

    (begin example)
        private _friesType = [
            MyVehicle,
            "friesType"
        ] call KISKA_fnc_fastRopeEvent_getConfigData;    
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRopeEvent_getConfigData";

#define FRIES_TYPE_KEY "friesType"
#define ROPE_ORIGINS_KEY "ropeOrigins"
#define FRIES_ATTACHMENT_POINT_KEY "friesAttachmentPoint"
#define ON_INITIATED_KEY "onInitiated"
#define ON_HOVER_STARTED_KEY "onHoverStarted"

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

    if (_dataToFetch isEqualTo ON_INITIATED_KEY) exitWith {
        private _onInitiatedConfig = FIND_CONFIG_ANY(ON_INITIATED_KEY);
        if (isText _onInitiatedConfig) then {
            _dataValue = compileFinal (getText _onInitiatedConfig);
        } else {
            _dataValue = {};
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
};

if (isNil "_dataValue") exitWith {
    [["Unexpected _dataToFetch -> ",_dataToFetch],true] call KISKA_fnc_log;
    nil
};


_vehicleDataCacheMap set [_dataToFetch, _dataValue];
_dataValue
