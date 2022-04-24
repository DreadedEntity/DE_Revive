/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

_this addAction [format ["Revive %1", _this call DREAD_fnc_getRankAndName], {
	params ["_target", "_caller", "_actionId", "_arguments"];
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic1";
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic2";
	_caller playMove "AinvPknlMstpSnonWnonDnon_medicEnd";
	sleep 10;
	[_target, false] call DREAD_fnc_unitSetReviveState;
	_target setDamage 0;
}, nil, 1000, false, true, "", "lifeState _target == 'INCAPACITATED' && _this == player"];