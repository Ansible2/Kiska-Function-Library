private _listOptions = [
    [0,1,2,3],
    [
        "Text Enabled - Voice Enabled",
        "Text Enabled - Voice Disabled",
        "Text Disabled - Voice Enabled",
        "Text Disabled - Voice Disabled"
    ],
    0
];


private _onChange = "
    private _selectedOption = _this;
    private _channelId = %1;
    
    switch _selectedOption do
    {
        case 0: { _channelId enableChannel [true, true] };
        case 1: { _channelId enableChannel [true, false] };
        case 2: { _channelId enableChannel [false, true] };
        case 3: { _channelId enableChannel [false, false] };
        default {};
    };
";

[
    [
        "KISKA_enableChannel_global",
        ["Global Channel", "Global channel will always be enabled for admins"],
        0
    ],
    [
        "KISKA_enableChannel_side",
        "Side Channel",
        1
    ],
    [
        "KISKA_enableChannel_command",
        "Command Channel",
        2
    ],
    [
        "KISKA_enableChannel_group",
        "Group Channel",
        3
    ],
    [
        "KISKA_enableChannel_vehicle",
        "Vehicle Channel",
        4
    ],
    [
        "KISKA_enableChannel_direct",
        "Direct Channel",
        5
    ]
] apply {
    _x params ["_variable","_title","_channelId"];


    [
        _variable,
        "LIST",
        _title,
        ["KISKA Radio Channels", "Enabled Channels"],
        _listOptions,
        nil,
        compileFinal (format [_onChange,_channelId])
    ] call CBA_fnc_addSetting;
};
