/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

[] spawn {
	private ["_deadMan","_actionIndex"];
	while {true} do {
		{
			if (lifeState _x == "INCAPACITATED") then {
				_deadMan = _x;
				(units player) apply {
					if !(isPlayer _x) then {
						if (isNil {_x getVariable (str _deadMan)}) then {
							if (_x distance _deadMan < 50) then {
								//systemChat format ["Creating revive for %1", name _deadMan];
								_actionIndex = _x addAction [format ["Revive %1", name _deadMan], DREAD_fnc_unitReviveBodyAction, _deadMan, 1000, false, true, "", "!(isPlayer _this)"];
								_x setVariable [str _deadMan, _actionIndex];
							};
						} else {
							if (_x distance _deadMan > 50) then {
								//systemChat "removed";
								_x removeAction (_x getVariable (str _deadMan));
								_x setVariable [str _deadMan, nil];
							};
						};
					};
				};
			} else {
				_deadMan = _x;
				if (lifeState _x == "HEALTHY" || lifeState _x == "INJURED") then {
					(units player) apply {
						if !(isPlayer _x) then {
							if !(isNil {_x getVariable (str _deadMan)}) then {
								_x removeAction (_x getVariable (str _deadMan));
								_x setVariable [str _deadMan, nil];
							};
						};
					};
				};
			};
			sleep 0.01;
		} forEach allUnits;
		sleep 1;
	};
};