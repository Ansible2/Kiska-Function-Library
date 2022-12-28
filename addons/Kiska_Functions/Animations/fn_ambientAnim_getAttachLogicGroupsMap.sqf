/* ----------------------------------------------------------------------------
Function: KISKA_fnc_ambientAnim_getAttachLogicGroupsMap

Description:
    Returns the hashmap that contains all logic groups used for ambient animatoins.

    Users can then reference all the groups with the `values` command.

    A hashmap was used in order to provide a quicker means of removing entries when
     a group is deleted as opposed to having to used the `find` command with an array.

Parameters:
	NONE

Returns:
    <HASHMAP> - A hashmap containing all the logic group

Examples:
    (begin example)
        private _map = call KISKA_fnc_ambientAnim_getAttachLogicGroupsMap;
    (end)

Author:
    Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_ambientAnim_getAttachLogicGroupsMap";

private _map = localNamespace getVariable "KISKA_ambientAnim_attachLogicGroupsMap";
if (isNil "_map") then {
	_map = createHashMap;
	localNamespace setVariable ["KISKA_ambientAnim_attachLogicGroupsMap",_map];
};


_map
