/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

//Run where _this is local, produces global effect
_this setVariable ["DE_REVIVING", true, true];
sleep 5;
_this setVariable ["DE_REVIVING", nil, true];
//_this setUnconscious false;
[_this, false] remoteExec ["setUnconscious", _this];
sleep 5;
_this playMove "AinvPpneMstpSlayWnonDnon_medic";
sleep 4;
//[_this, false] call DREAD_fnc_unitSetReviveState;
[_this, false] remoteExec ["DREAD_fnc_unitSetReviveState", _this];
_this setDamage 0;