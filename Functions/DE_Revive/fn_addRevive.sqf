/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

_this addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	if (_damage >= 0.99) then {
		if !(lifeState _unit == "INCAPACITATED") then {
			[_unit, true] call DREAD_fnc_unitSetReviveState;
			_unit call DREAD_fnc_addPlayerHoldRevive;
			_unit setVariable ["DE_TIME_KILLED", time];
		};
		_damage = 0;
	};
	_damage;
}];