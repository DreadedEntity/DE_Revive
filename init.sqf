waitUntil {time > 0};

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

player addAction ["All units self-revive", {
	(allUnits select {lifeState _x == "INCAPACITATED"}) apply {_x spawn DREAD_fnc_unitSelfRevive};
}, nil, 10, false, true];

player addAction ["Start revive loop", {
	{
		if (lifeState _x == "INCAPACITATED") then {
			[man_3, _x] call DREAD_fnc_unitReviveBody;
		};
	} forEach allUnits;
}, nil, 10, false, true];
player addAction ["Kill player", {
	player setDamage 0.99;
	player setVelocityModelSpace [0,0,-10];
}, nil, 9, false, true];

[] spawn {
	while {true} do {
		if (lifeState player == "INCAPACITATED") then {
			//sleep 0.01;
			[man_3, player] call DREAD_fnc_unitReviveBody;
			man_3 removeAction (man_3 getVariable (str player));
		};
		sleep 1;
	};
};

addMissionEventHandler ["Draw3D", DREAD_fnc_draw3DMissionEventHandler];

if (isServer) then {
	[player, man, man_1, man_2, man_3] apply {
		_x call DREAD_fnc_addRevive;
	};
	//sleep 0.5;
	[man, man_1, man_2] apply { _x setDamage 0.99; [_x,[0,0,-8]] remoteExec ["setVelocityModelSpace", _x]; };
};
//player addAction ["View icons", DREAD_fnc_showActioniconsDialog, nil, 10, false, true];

player addRating 9001;