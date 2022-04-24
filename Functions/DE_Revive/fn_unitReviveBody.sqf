/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

// Should only run where _unit is local, produces global effects
params ["_unit", "_body"];
private ["_relativeDir", "_pos", "_leader"];
_unit groupChat format ["I am going to revive %1, cover me!", _this call DREAD_fnc_getRankAndName];
_relativeDir = _body getDir _unit;
_pos = getPos _body;
_unit doMove _pos;
waitUntil {moveToCompleted _unit};
_unit setFormDir (_unit getDir _body);
sleep 0.5;
doStop _unit; //stop here prevents unit from making radio messages after doMove
_body setVariable ["DE_REVIVING", true];
_unit playMove "AinvPknlMstpSnonWnonDnon_medic1";
_unit playMove "AinvPknlMstpSnonWnonDnon_medic2";
sleep 11.764;
_unit playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd";
_body setVariable ["DE_REVIVING", nil];
[_body, false] call DREAD_fnc_unitSetReviveState;
_body setDamage 0;
_leader = leader _unit;
_unit setFormDir (_unit getDir _leader);
_unit doFollow _leader;