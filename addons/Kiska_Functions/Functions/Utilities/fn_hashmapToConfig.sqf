/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hashmapToConfig

Description:
    Converts a hashmap into a string config representation.

    If a property is a HASHMAP, it is considered a class and will be recursively
     parsed.

Parameters:
    0: _classMap <HASMAP> - The hashmap to convert to a config.

Returns:
    <STRING> - The string class representation of the hashmap.

Examples:
    (begin example)
        private _configString = [
            createHashMapFromArray [
                [
                    "ExampleClass",
                    createHashMapFromArray [
                        ["numberProperty",1],
                        ["stringProperty","hello world"],
                        ["arrayProperty",[1,[2],[[3]]] ],
                        ["subClass", createHashMapFromArray [["subProp",1]] ]
                    ]
                ]
            ]
        ] call KISKA_fnc_hashmapToConfig;
        copyToClipboard _configString;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hashmapToConfig";

#define INDENTATION_AMOUNT 4

params [
    ["_classMap",[],[createHashMap]],
    ["_nestedLevel",0,[123]]
];

private _fn_prependSpaces = {
    params ["_original","_indentationLevel"];

    private _numberOfSpaces = _indentationLevel * INDENTATION_AMOUNT;
    if (_numberOfSpaces <= 0) exitWith { _original };

    private _array = [];
    for "_i" from 1 to _numberOfSpaces do { 
        _array pushBack " ";
    };
    _array pushBack _original;

    _array joinString ""
};


private _stringArray = [];
if (_nestedLevel isEqualTo 0) then {
    _stringArray append [
        "class Export",
        "{"
    ];
};

private _propertyIndentationLevel = _nestedLevel + 1;
_classMap apply {
    private _value = _y;
    if (_value isEqualType createHashMap) then {
        if ((count _value) < 1) then { continue };
        
        private _classname = ["class",_x] joinString " ";
        _stringArray append [
            [_classname,_propertyIndentationLevel] call _fn_prependSpaces,
            ["{",_propertyIndentationLevel] call _fn_prependSpaces,
            [_value,_propertyIndentationLevel] call hashmapToConfig,
            ["};",_propertyIndentationLevel] call _fn_prependSpaces
        ];
        continue;
    };

    private "_text";
    if (_value isEqualType []) then {
        private _arrayString = str _value;
        _arrayString = _arrayString regexReplace ["\[","{"];
        _arrayString = _arrayString regexReplace ["\]","}"];
        _text = [_x,"[] = ",_arrayString,";"] joinString "";

    } else {
        if (_value isEqualType "") then {
            _value = format ['"%1"',_value];
        };

        _text = [_x," = ",_value,";"] joinString "";
    };

    private _line = [
        _text,
        _propertyIndentationLevel
    ] call _fn_prependSpaces;
    _stringArray pushBack _line;
};

if (_nestedLevel isEqualTo 0) then {
    _stringArray pushBack "};";
};

_stringArray joinString endl
