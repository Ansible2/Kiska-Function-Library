/* ----------------------------------------------------------------------------
Function: KISKA_fnc_hasConditionalConfig

Description:
    Checks if the given config (class) has a class underneath it named `KISKA_conditional`
     making it eligible to be used with `KISKA_fnc_getConfigDataConditional`.

    (begin config example)
        class MyConfig
        {
            class KISKA_conditional // returns true
            {
                // ...
            };
        };
    (end)

Parameters:
    0: _conditionalConfigParent <CONFIG> - Default: `configNull` - The config path to 
        check whether or not it has a conditional class.

Returns:
    <BOOL> - Whether or not the config has a conditional class.

Examples:
    (begin example)
        private _hasConditionalClass = [
            missionConfigFile >> "MyConfig"
        ] call KISKA_fnc_hasConditionalConfig;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_hasConditionalConfig";

params [
    ["_conditionalConfigParent",configNull,[configNull]]
];


isClass(_conditionalConfigParent >> "KISKA_conditional")
