/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientRadio

Description:
	Play news on an object, ot your own assortment of sounds.
	Function is global and should run on one machine.
	Once players move out of a range, the broadcasts will stop and will not come back

Parameters:
	0: _radio <OBJECT> - The object that will be playing the news
	1: _duration <NUMBER> - How long should this broadcast last?
	2: _range <NUMBER> - How far away (2D) should players be before the broadcasts will stop?
	3: _volume <NUMBER> - The volume of the sounds
	4: _radioChannel <STRING> - What channel to use. This is to have a synced channel across multiple radios; they won't play the same thing twice
	5: _public <BOOL, NUMBER, or ARRAY> - Does the radioChannel info need to be network synced (publicVariable)
	6: _sounds <ARRAY> - What sounds do you want to play? This will default to a slection below of sounds. Sounds need to be defined in cfgSounds.
	

Returns:
	NOTHING

Examples:
    (begin example)

		[myRadio] spawn KISKA_fnc_ambientRadio;

    (end)

Author:
	Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) then {
	["Was not run on the server, recommend execution on server in the future",false] call KISKA_fnc_log;
};

if (!canSuspend) exitWith {
	["Must be run in scheduled envrionment, exiting to scheduled",true] call KISKA_fnc_log;
	_this spawn KISKA_fnc_ambientRadio;
};

params [
	["_radio",objNull,[objNull]],
	["_duration",300,[123]],
	["_range",200,[123]],
	["_volume",3,[123]],
	["_radioChannel","",[""]],
	["_public",false,[true,123,[]]],
	["_sounds",[],[[]]]
];

if (_radioChannel isEqualTo "") then {
	_radioChannel = "KISKA_radioChannel_1";
};

// diag if channel will be created
if (isNil _radioChannel) then {
	[["Created new radio channel ", _radioChannel],false] call KISKA_fnc_log;
};

// use default sounds if none provided AND channel is undefined
if (_sounds isEqualTo [] AND {isNil _radioChannel}) then {
	_sounds = [
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
	_sounds = missionNamespace getVariable _radioChannel;
};

// filter sounds
private _soundsFiltered = [];
// get any already used sounds in nameSpace
private _usedNamespace = _radioChannel + "_used";
private _usedSounds = missionNamespace getVariable [_usedNamespace,[]];
_sounds apply {
	// check if sound is defined
	if (isClass (configFile >> "cfgSounds" >> _x) OR {isClass (missionConfigFile >> "cfgSounds" >> _x)}) then {
		// check if sound has been used in namepace
		if !(_x in _usedSounds) then {
			_soundsFiltered pushBackUnique _x;
		};	
	} else {
		[[_x, " is undefined sound!"],true] call KISKA_fnc_log;
	};
};
missionNamespace setVariable [_radioChannel,_soundsFiltered,_public];

private _endTime = _duration + time;
waitUntil {
	// exit if players leave area
	if (_endTime <= time OR {!(((call CBA_fnc_players) findIf {(_x distance2d _radio) > _range}) isEqualTo -1)}) exitWith {true};

	// loop back if needed on used sounds
	if ((missionNamespace getVariable _radioChannel) isEqualTo []) then {
		// take all the used sounds and add them to the channel again
		missionNamespace setVariable [_radioChannel,(missionNamespace getVariable _usedNamespace),_public];
		// set used global back to empty array
		missionNamespace setVariable [_usedNamespace,[],_public];
	};

	// pick sound
	private _soundsToChoose = missionNamespace getVariable _radioChannel;
	private _randomNews = selectRandom _soundsToChoose;
	_soundsToChoose deleteAt (_soundsToChoose findIf {_x isEqualTo _randomNews});
	// sync to global
	missionNamespace setVariable [_radioChannel,_soundsToChoose,_public];

	
	// add sound to used list
	_usedSounds = missionNamespace getVariable [_usedNamespace,[]];
	_usedSounds pushBack _randomNews;
	// sync to global
	missionNamespace setVariable [_usedNamespace,_usedSounds,_public];

	// play sound
	[_randomNews,_radio,30,_volume,true] spawn KISKA_fnc_playSound3d;
	
	sleep (random [30,35,40]);

	false
};