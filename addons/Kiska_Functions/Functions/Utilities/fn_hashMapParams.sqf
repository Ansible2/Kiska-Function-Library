/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmapParams

Description:
    Converts a hashmap into a list of validated potential private variables. 
    
    Similar to the `params` command.

Parameters:
    0: _argsMap : <HASHMAP> - Any hashmap.
    1: _paramDetails : <[STRING,CODE,ANY[],(NUMBER | NUMBER[])][]> - An array of 
        [
            hashmap key, 
            code that returns a default value, 
            an array of valid types,
            if value is an array, the valid number of entries in that array
        ]

Returns:
    [ANY[],STRING[]] or STRING - An array of variable values from the hashmap and their 
        corresponding suggested variable names. Suggested variable names are the
        key names provided in the `_paramDetails` argument plus a leading underscore 
        `_` should the key not already begin with one. Should a string be returned instead,
        this means a map value had an incorrect type according to the `_paramDetails`.

Examples:
    (begin example)
        private _map = createHashMapFromArray [
            ["a",1],["_b",2],["c",3]
        ];

        private _mapParams = [
            _map,
            [
                ["a",{0},[123]],
                ["_b",{0},[123]]
            ]
        ] call KISKA_fnc_hashMapParams;
        (_mapParams select 0) params (_mapParams select 1);
        [_a,_b]
    (end)

    (begin example)
        private _map = createHashMapFromArray [
            ["a",1],["_b",2],["c",3]
        ];

        private _error = [
            _map,
            [
                ["a",{0},[123]],
                ["_b",{"bbbb"},[""]]
            ]
        ] call KISKA_fnc_hashMapParams;
        hint _error; // _b is not the right type
    (end)

Author(s):
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashMapParams";

params [
    ["_argsMap",nil,[createHashMap]],
    ["_paramDetails",[],[[]]]
];

private "_invalidArgumentMessage";
private _paramVariableNames = [];
private _paramValues = _paramDetails apply {
    _x params [
        ["_key","",[""]],
        ["_default",{},[{}]],
        ["_types",[],[[]]],
        ["_expectedArrayCount",-1,[123,[]]]
    ];
    _key = trim _key;
    private _paramValue = _argsMap getOrDefaultCall [_key,{import "_default"; call _default}];
    if ((_types isNotEqualTo []) AND {!(_paramValue isEqualTypeAny _types)}) then {
        _invalidArgumentMessage = [_key," value ",_paramValue," is invalid, must be of types -> ",_types] joinString "";
        break;
    };

    private _variableName = _key;
    if ((_variableName select [0,1]) isNotEqualTo "_") then {
        _variableName = ["_",_key] joinString "";
    };

    _paramVariableNames pushBack _variableName;

    if (
        (_paramValue isEqualType []) AND 
        {
            (
                (_expectedArrayCount isEqualType 123) AND
                {
                    (_expectedArrayCount > 0) AND {(count _paramValue) isNotEqualTo _expectedArrayCount} 
                }
            ) OR
            {!(count _paramValue) in _expectedArrayCount}
        }
    ) then {
        _invalidArgumentMessage = [_key," value ",_paramValue," is an invalid number of entries, must have a count of -> ",_expectedArrayCount] joinString "";
        break;
    };

    _paramValue
};
if (!isNil "_invalidArgumentMessage") exitWith { _invalidArgumentMessage };


[_paramValues,_paramVariableNames]
