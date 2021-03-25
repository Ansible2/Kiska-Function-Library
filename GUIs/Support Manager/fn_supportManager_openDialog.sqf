if (missionNamespace getVariable ["KISKA_CBA_GCH_enabled",true]) then {
    createDialog "KISKA_supportManager_Dialog";
} else {
    hint "The Group Changer Dialog is diabled in the Server Addon Options";
};
