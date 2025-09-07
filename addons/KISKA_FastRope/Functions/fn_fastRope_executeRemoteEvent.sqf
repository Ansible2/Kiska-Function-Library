/* ----------------------------------------------------------------------------
Function: KISKA_fnc_fastRope_executeRemoteEvent

Description:
    Meant to execute a piece of code on a (potentially) remote machine during fastroping.

    Events:
    - `"UpdateAttachmentDummyMass"` - Adjusts the given attachment dummy's mass
        and position to prepare it for a unit to fastrope down. Arguments:
        - _ropeUnitAttachmentDummy <OBJECT> - The unit attachment dummy to adjust.
        - _hookPosition <PositionASL[]> - The position of the hook the rope is hangning from.
    - `"StartAttachmentDescentLoop"` - Adds a perframe handler to the local machine
        that will continuously push the attachment dummy down to give the appearance of
        sliding down the rope. Arguments:
        - _ropeUnitAttachmentDummy <OBJECT> - The unit attachment dummy to descend.
    - `"EndAttachmentDescentLoop"` - Ends the loop added with `"StartAttachmentDescentLoop"`
        and returns the attachment dummy's mass to normal. Arguments:
        - _ropeUnitAttachmentDummy <OBJECT> - The unit attachment dummy to stop descending.
        - _hookPosition <PositionASL[]> - The position of the hook the rope is hangning from.
    - `"StartFastRopeAnimation"` - Changes the given unit's animation to be that of fastroping
        and if that unit is a player, will start a loop to continuously play a sliding-down
        sound. Arguments:
        - _unit <OBJECT> - The unit fastroping.
    - `"EndFastRopeAnimation"` - Ends the sound loop made in `"StartFastRopeAnimation"`,
        resets the unit's animations, and will play a (local 2D) thud sound if the 
        unit is a player. Arguments: 
        - _unit <OBJECT> - The unit fastroping.

Parameters:
    0: _event <STRING> - The remote event to execute. Case Insensitive.
    1: _args <ANY> - The arguments for the given event.

Returns:
    NOTHING

Examples:
    (begin example)
        [
            "UpdateAttachmentDummyMass",
            [_ropeUnitAttachmentDummy,getPosASLVisual _hook]
        ] remoteExecCall ["KISKA_fnc_fastRope_executeRemoteEvent",_ropeUnitAttachmentDummy];
    (end)

Author(s):
    BaerMitUmlaut,
    Modified By: Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_fastRope_executeRemoteEvent";

#define DESCENT_SOUND_VAR "KISKA_fastrope_descendingSoundHandlerId"
#define ATTACHMENT_DESCENT_LOOP_VAR "KISKA_fastrope_descentAttachmentHandlerId"

#define DUMMY_FAST_ROPE_DESCENT_VELOCITY [0,0,-6]

#define ATTACHMENT_DUMMY_ORIGINAL_MASS 40
#define ATTACHMENT_DUMMY_ORIGINAL_CENTER_OF_MASS [0.000143227,0.00105986,-0.246147]
#define ATTACHMENT_DUMMY_DOWNWARD_MASS 80
#define ATTACHMENT_DUMMY_DOWNWARD_CENTER_OF_MASS [0, 0, -2]

params [
    ["_event","",[""]],
    ["_args",[],[]]
];


/* ----------------------------------------------------------------------------
    UpdateAttachmentDummyMass
---------------------------------------------------------------------------- */
if (_event == "UpdateAttachmentDummyMass") exitWith {
    _args params [
        ["_ropeUnitAttachmentDummy",objNull,[objNull]],
        ["_hookPosition",[],[[]],[3]]
    ];

    _ropeUnitAttachmentDummy setMass ATTACHMENT_DUMMY_DOWNWARD_MASS;
    _ropeUnitAttachmentDummy setCenterOfMass ATTACHMENT_DUMMY_DOWNWARD_CENTER_OF_MASS;
    _ropeUnitAttachmentDummy setPosASL (_hookPosition vectorAdd [0, 0, -2]);
    _ropeUnitAttachmentDummy setVectorUp [0, 0, 1];

    nil
};

/* ----------------------------------------------------------------------------
    StartAttachmentDescentLoop
---------------------------------------------------------------------------- */
if (_event == "StartAttachmentDescentLoop") exitWith {
    _args params [
        ["_ropeUnitAttachmentDummy",objNull,[objNull]]
    ];

    private _attachmentLoopId = [
        {
            // Setting the velocity manually to reduce twitching
            (_this select 0) setVelocity DUMMY_FAST_ROPE_DESCENT_VELOCITY;
        },
        0,
        _ropeUnitAttachmentDummy
    ] call CBA_fnc_addPerFrameHandler;
    _ropeUnitAttachmentDummy setVariable [ATTACHMENT_DESCENT_LOOP_VAR,_attachmentLoopId];


    nil
};

/* ----------------------------------------------------------------------------
    EndAttachmentDescentLoop
---------------------------------------------------------------------------- */
if (_event == "EndAttachmentDescentLoop") exitWith {
    _args params [
        ["_ropeUnitAttachmentDummy",objNull,[objNull]],
        ["_hookPosition",[],[[]],[3]]
    ];

    private _attachmentLoopId = _ropeUnitAttachmentDummy getVariable ATTACHMENT_DESCENT_LOOP_VAR;
    if !(isNil "_attachmentLoopId") then {
        _ropeUnitAttachmentDummy setVariable [ATTACHMENT_DESCENT_LOOP_VAR,nil];
        [_attachmentLoopId] call KISKA_fnc_CBA_removePerFrameHandler;
    };

    _ropeUnitAttachmentDummy setPosASL (_hookPosition vectorAdd [0, 0, -1]);
    _ropeUnitAttachmentDummy setMass ATTACHMENT_DUMMY_ORIGINAL_MASS;
    _ropeUnitAttachmentDummy setCenterOfMass ATTACHMENT_DUMMY_ORIGINAL_CENTER_OF_MASS;

    nil
};


/* ----------------------------------------------------------------------------
    _fn_playAnimation
---------------------------------------------------------------------------- */
private _fn_playAnimation = {
    params ["_unit","_animation"];

    if (isNull (objectParent _unit)) then {
        _unit playMoveNow _animation;
    } else {
        // Execute on all machines. PlayMove and PlayMoveNow are bugged: 
        // They have local effects when executed on remote machines inside vehicles.
        _this remoteExecCall ["playMoveNow",0];
    };

    // if animation doesn't respond, do switchMove
    if ((animationState _unit) != _animation) then {
        _this remoteExecCall ["switchMove",0];
    };
};

/* ----------------------------------------------------------------------------
    StartFastRopeAnimation
---------------------------------------------------------------------------- */
if (_event == "StartFastRopeAnimation") exitWith {
    _args params [
        ["_unit",objNull,[objNull]]
    ];
    [_unit, "KISKA_FastRoping"] call _fn_playAnimation;

    if (isPlayer _unit) then {
        private _descentSoundHandlerId = [
            {
                private _unit = _this select 0;
                if !(alive _unit) exitWith {
                    _unit setVariable [DESCENT_SOUND_VAR,nil];
                    [_this select 1] call KISKA_fnc_CBA_removePerFrameHandler;
                };

                playSound "KISKA_fastrope_descending";
            },
            1,
            _unit
        ] call CBA_fnc_addPerFrameHandler;
        _unit setVariable [DESCENT_SOUND_VAR,_descentSoundHandlerId];
    };


    nil
};

/* ----------------------------------------------------------------------------
    EndFastRopeAnimation
---------------------------------------------------------------------------- */
if (_event == "EndFastRopeAnimation") exitWith {
    _args params [
        ["_unit",objNull,[objNull]],
        ["_reachedGround",false,[true]]
    ];

    [_unit,""] call _fn_playAnimation;
    _unit setVectorUp [0,0,1];

    private _descentSoundHandlerId = _unit getVariable DESCENT_SOUND_VAR;
    if !(isNil "_descentSoundHandlerId") then {
        _unit setVariable [DESCENT_SOUND_VAR,nil];
        [_descentSoundHandlerId] call KISKA_fnc_CBA_removePerFrameHandler;
    };

    if (_reachedGround AND {isPlayer _unit}) then {
        playSound "KISKA_fastrope_thud";
    };

    private _currentWeapon = currentWeapon _unit;
    if (_currentWeapon != "") then {
        _unit action ["SwitchWeapon", _unit, _unit, 299];
        [
            {
                params ["_unit", "_weapon"];
                // Abort if the unit already selected a different weapon
                if (
                    (currentWeapon _unit) != "" OR 
                    {
                        !((lifeState _unit) in ["HEALTHY", "INJURED"])
                    }
                ) exitWith {};
                _unit selectWeapon _weapon;
            }, 
            [_unit, _currentWeapon], 
            2
        ] call CBA_fnc_waitAndExecute;
    };


    nil
};


nil
