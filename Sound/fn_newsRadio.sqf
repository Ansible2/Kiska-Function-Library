/* ----------------------------------------------------------------------------
Function: KISKA_fnc_newsRadio

Description:
	Play news on an object.
	Function is global and should run on one machine.

Parameters:
	0: _radio <OBJECT> - The object that will be playing the news
	1: _duration <NUMBER> - How long should this broadcast last?
	2: _sounds <ARRAY> - what sounds do you want to play? This will default to a slection below of sounds. Sounds need to be defined in cfgSounds

Returns:
	NOTHING

Examples:
    (begin example)

		[myRadio,120] call KISKA_fnc_newsRadio;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */

if (!isServer) then {
	"Recommend execution on server" call BIS_fnc_errorMsg;
};

params [
	["_radio",objNull,[objNull]],
	["_duration",300,[123]],
	["_sounds",[],[[]]]
];

private _endTime = _duration + time;

if (_sounds isEqualTo [] AND {isNil "KISKA_newsSounds"}) then {
	KISKA_newsSounds = [
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
		"radio_dialogues_042_am_radio_broadcast_news_first_in_BROADCASTER_0",
		"radio_dialogues_043_am_radio_broadcast_news_malaria_luganville_BROADCASTER_1",
		"radio_dialogues_044_am_radio_broadcast_news_malaria_luganville_secured_BROADCASTER_0",
		"radio_dialogues_045_am_radio_broadcast_news_malaria_savaka_BROADCASTER_2",
		"radio_dialogues_046_am_radio_broadcast_news_malaria_savaka_secured_BROADCASTER_0",
		"radio_dialogues_047_am_radio_broadcast_news_malaria_galili_BROADCASTER_2",
		"radio_dialogues_051_am_radio_broadcast_news_arrest_BROADCASTER_0",
		"radio_dialogues_052_am_radio_broadcast_news_execution_BROADCASTER_2",
		"radio_dialogues_027_am_radio_broadcast_forecast_rain_c_BROADCASTER_0",
		"radio_dialogues_024_am_radio_broadcast_forecast_cloud_staying_BROADCASTER_0"
	];
} else {
	KISKA_newsSounds = _sounds;
};

if (isNil "KISKA_usedNewsSounds") then {
	KISKA_usedNewsSounds = [];
};

waitUntil {
	if (_endTime <= time OR {!(((call CBA_fnc_players) findIf {(_x distance2d _radio) > 200}) isEqualTo -1)}) exitWith {true};

	if (KISKA_newsSounds isEqualTo []) then {
		KISKA_newsSounds = KISKA_usedNewsSounds;
		KISKA_usedNewsSounds = [];
	};

	private _randomNews = selectRandom KISKA_newsSounds;

	KISKA_newsSounds deleteAt (KISKA_newsSounds findIf {_x isEqualTo _randomNews});
	
	KISKA_usedNewsSounds pushBack _randomNews;

	// check if sound is actually defined
	if (isClass (configFile >> "cfgSounds" >> _randomNews) OR {isClass (missionConfigFile >> "cfgSounds" >> _randomNews)}) then {
		[_randomNews,_radio,30,3,true] spawn KISKA_fnc_playSound3d;
	} else {
		(_randomNews + " is undefined sound") call BIS_fnc_error;
	};
	
	sleep (random [30,35,40]);

	false
};