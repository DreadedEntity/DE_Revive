/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

// Should only run where _unit is local, produces global effects
params ["_unit", "_body"];
private ["_relativeDir", "_pos", "_leader"];
[_unit, format ["I am going to revive %1, cover me!", _body call DREAD_fnc_getRankAndName]] remoteExec ["groupChat", group _unit];
_relativeDir = _body getDir _unit;
_pos = getPos _body;
//_unit doMove _pos;
[_unit, _pos] remoteExec ["doMove", _unit];
waitUntil {moveToCompleted _unit};
//_unit setFormDir (_unit getDir _body);
[_unit, _unit getDir _body] remoteExec ["setFormDir", _unit];
sleep 0.5;
doStop _unit; //stop here prevents unit from making radio messages after doMove
_body setVariable ["DE_REVIVING", true, true];
_unit playMove "AinvPknlMstpSnonWnonDnon_medic1";
_unit playMove "AinvPknlMstpSnonWnonDnon_medic2";
sleep 11.764;
_unit playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd";
_body setVariable ["DE_REVIVING", nil, true];
//[_body, false] call DREAD_fnc_unitSetReviveState;
[_body, false] remoteExec ["DREAD_fnc_unitSetReviveState", _body];
_body setDamage 0;
_leader = leader _unit;
//_unit setFormDir (_unit getDir _leader);
[_unit, _unit getDir _leader] remoteExec ["setFormDir", _unit];
_unit doFollow _leader;
[_unit, _leader] remoteExec ["doFollow", _unit];