#define IS_ROPE_BROKEN_INFO_INDEX 6

params [
    ["_rope",objNull,[objNull]],
    ["_vehicle",objNull,[objNull]]
];

private _deployedRopeInfo = _vehicle getVariable ["KISKA_fastRope_deployedRopeInfo", []];
private "_brokenRopeInfo";
_deployedRopeInfo apply {
    if (
        ((_x select ROPE_TOP_INFO_INDEX) isEqualTo _rope) OR 
        {(_x select ROPE_BOTTOM_INFO_INDEX) isEqualTo _rope}
    ) then {
        _brokenRopeInfo = _x;
        break;
    };
};

// TODO: can this not just be deleted from the list?
_brokenRopeInfo set [IS_ROPE_BROKEN_INFO_INDEX, true];


_brokenRopeInfo
