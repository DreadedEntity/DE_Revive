/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

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

//Possible next version, but the above is working so ehh
//while {true} do {
//	{
//		private _unit = _x;
//		private _reviveList = _unit getVariable ["DE_REVIVE_ACTIONS", []];
//		private _updateReviveList = false;
//		{
//			private _tested = _x;
//			private _varName = "DE_REVIVE_" joinString (str _tested);
//			if (_unit distance _tested > 50) then { //TODO: Replace magic number 50 with variable for creator flexibility
//				private _arrayPos = _reviveList findIf {_x == _tested};
//				if (_arrayPos > -1) then {
//					private _actionIndex = _unit getVariable _varName;
//					if !(isNil "_actionIndex") then {
//						_unit removeAction _actionIndex;
//						_unit setVariable [_varName, nil];
//						_reviveList deleteAt _arrayPos;
//						_updateReviveList = true;
//					};
//				};
//			} else {
//				private _lifeState = lifeState _tested;
//				if (_lifeState == "INCAPACITATED") then {
//					if (_unit distance _tested < 50) then {
//						if (isNil {_unit getVariable _varName}) then {
//							_actionIndex = _unit addAction [format ["Revive %1", name _tested], DREAD_fnc_unitReviveBodyAction, _tested, 1000, false, true, "", "!(isPlayer _this)"];
//							_unit setVariable [_varName, _actionIndex];
//						};
//					};
//				} else {
//					if ((_lifeState select [0,4]) != "DEAD") then { //idk what "DEAD-RESPAWN" and "DEAD-SWITCHING" is, but we might as well exclude all cases
//
//					};
//				}
//			};
//		} forEach allUnits;
//		if (_updateReviveList) then {
//			_unit setVariable ["DE_REVIVE_ACTIONS", _reviveList];
//		};
//		sleep 0.001; //Don't know how costly this code is but go ahead and allow suspension in the middle
//	} forEach ((units player) select { !isPlayer _x}); //Remove any player units, however, upon reflection, in unitReviveBody I could add a player check and just create a custom waypoint, rather than attempt to revive via commands
//	//TODO(?): Edit unitReviveBody to check if player or AI, AI will attempt to revive via existing code, player will have custom "Revive" waypoint added to unit pos
//
//	sleep 1;
//}