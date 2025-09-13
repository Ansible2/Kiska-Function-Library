/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientNewsRadio

Description:
    Plays a selection of news sounds from the vanilla game at a given position.

Parameters:
    0: _origin <OBJECT or ARRAY> - The position the sound will play at. If array
        position is format ASL
    1: _duration <NUMBER> - How long should this broadcast last. Negative value
        will go on forever.
    2: _distance <NUMBER> - How far away the sound can be heard
    3: _volume <NUMBER> - The volume of the sounds (0-5).
    3: _isInside <BOOL> - Are these sounds being played indoors


Returns:
    <NUMBER> - The KISKA_fnc_playRandom3dSoundLoop Handler ID for stopping the sound 
        with KISKA_fnc_stopRandom3dSoundLoop

Examples:
    (begin example)
        [myRadio] call KISKA_fnc_ambientNewsRadio;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientNewsRadio";

params [
    ["_origin",objNull,[[],objNull]],
    ["_duration",60,[123]],
    ["_distance",500,[[],123],[3]],
    ["_volume",1,[123]],
    ["_isInside",false,[true]]
];

private _sounds = [
    "News_arrest",
    "News_BackOnline",
    "News_checkpoints",
    "News_CSAT_convoy_attacked",
    "News_depot_success",
    "News_execution",
    "News_hostels",
    "News_house_destroyed",
    "News_idap",
    "News_Infection01",
    "News_Jingle",
    "News_malaria_galili_secured",
    "News_malaria_luganville_secured",
    "News_malaria_savaka_secured",
    "News_outbreak_Boise",
    "News_power_plant",
    "News_radar_destroyed",
    "News_rebels_attack_Lugganville",
    "News_rescued",
    "News_weapons_prohibited",
    ["radio_dialogues_042_am_radio_broadcast_news_first_in_BROADCASTER_0",3],
    ["radio_dialogues_043_am_radio_broadcast_news_malaria_luganville_BROADCASTER_1",7],
    ["radio_dialogues_044_am_radio_broadcast_news_malaria_luganville_secured_BROADCASTER_0",7.5],
    ["radio_dialogues_045_am_radio_broadcast_news_malaria_savaka_BROADCASTER_2",6],
    ["radio_dialogues_046_am_radio_broadcast_news_malaria_savaka_secured_BROADCASTER_0",6],
    ["radio_dialogues_047_am_radio_broadcast_news_malaria_galili_BROADCASTER_2",6],
    ["radio_dialogues_051_am_radio_broadcast_news_arrest_BROADCASTER_0",6],
    ["radio_dialogues_052_am_radio_broadcast_news_execution_BROADCASTER_2",10],
    ["radio_dialogues_027_am_radio_broadcast_forecast_rain_c_BROADCASTER_0",6],
    ["radio_dialogues_024_am_radio_broadcast_forecast_cloud_staying_BROADCASTER_0",6]
];



private _3dSoundLoopId = [
    _origin,
    _sounds,
    5,
    [
        _distance,
        _volume,
        _isInside
    ]
] call KISKA_fnc_playRandom3dSoundLoop;

if (_duration > 0) then {
    [
        {
            params ["_3dSoundLoopId"];
            hint "timed stop";
            [_3dSoundLoopId] call KISKA_fnc_stopRandom3dSoundLoop;
        },
        [_3dSoundLoopId],
        _duration
    ] call KISKA_fnc_CBA_waitAndExecute;
};


_3dSoundLoopId