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

if (_event == "StartAttachmentDescentLoop") exitWith {
    _args params [
        ["_ropeUnitAttachmentDummy",objNull,[objNull]]
    ];

    private _attachmentLoopId = [
        {
            _ropeUnitAttachmentDummy setVelocity DUMMY_FAST_ROPE_DESCENT_VELOCITY;
        },
        0,
        _ropeUnitAttachmentDummy
    ] call CBA_fnc_addPerFrameHandler;
    _ropeUnitAttachmentDummy setVariable [ATTACHMENT_DESCENT_LOOP_VAR,_attachmentLoopId];


    nil
};

if (_event == "EndAttachmentDescentLoop") exitWith {
    _args params [
        ["_ropeUnitAttachmentDummy",objNull,[objNull]],
        ["_hookPosition",[],[[]],[3]]
    ];

    private _attachmentLoopId = _ropeUnitAttachmentDummy getVariable ATTACHMENT_DESCENT_LOOP_VAR;
    if !(isNil "_attachmentLoopId") then {
        _ropeUnitAttachmentDummy setVariable [ATTACHMENT_DESCENT_LOOP_VAR,nil];
        [_attachmentLoopId] call CBA_fnc_removePerFrameHandler;
    };

    _ropeUnitAttachmentDummy setPosASL (_hookPosition vectorAdd [0, 0, -1]);
    _ropeUnitAttachmentDummy setMass ATTACHMENT_DUMMY_ORIGINAL_MASS;
    _ropeUnitAttachmentDummy setCenterOfMass ATTACHMENT_DUMMY_ORIGINAL_CENTER_OF_MASS;

    // TODO: create new ropes?
    nil
};



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

if (_event == "StartFastRopeAnimation") exitWith {
    _args params [
        ["_unit",objNull,[objNull]]
    ];
    [_unit, "KISKA_FastRoping"] call _fn_playAnimation;

    if (isPlayer _unit) then {
        private _descentSoundHandlerId = [
            {
                playSound "KISKA_fastrope_descending";
            },
            1,
            _unit
        ] call CBA_fnc_addPerFrameHandler;
        _unit setVariable [DESCENT_SOUND_VAR,_descentSoundHandlerId];
    };


    nil
};

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
        [_descentSoundHandlerId] call CBA_fnc_removePerFrameHandler;
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
