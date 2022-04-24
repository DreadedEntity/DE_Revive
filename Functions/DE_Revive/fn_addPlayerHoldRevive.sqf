/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

[_this, 
	format ["revive %1", _this call DREAD_fnc_getRankAndName],
	"a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa",
	"a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa",
	"lifeState _target == 'INCAPACITATED' && _this == player && {_target != player && {_target distance _this < 3}}",
	"true",
	{ //action start
		(_this # 0) setVariable ["DE_REVIVING", true, true];
		(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic1";
		(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic2";
		(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic3";
	},
	nil,
	{ //action complete
		(_this # 0) setVariable ["DE_REVIVING", nil, true];
		[_this # 0, false] call DREAD_fnc_unitSetReviveState;
		(_this # 0) setDamage 0;
		(_this # 1) playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd";
	},
	{ //action interrupted
		(_this # 0) setVariable ["DE_REVIVING", nil, true];
		(_this # 1) playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd"
	},
	nil,
	14,
	1000,
	true,
	true,
	true] call BIS_fnc_holdActionAdd;