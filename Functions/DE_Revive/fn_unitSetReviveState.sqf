/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

// Should only run where _unit is local, but produces global effects
params ["_unit", "_revive"];
if (_revive) then {
	_unit setUnconscious true;
	_unit setCaptive true;
	_unit allowDamage false;
} else {
	_unit setUnconscious false;
	_unit setCaptive false;
	_unit allowDamage true;
};