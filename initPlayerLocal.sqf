/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

waitUntil {time > 0};

//Self revive EXAMPLE
player addAction ["All units self-revive", {
	(allUnits select {lifeState _x == "INCAPACITATED"}) apply {
		_x remoteExec ["DREAD_fnc_unitSelfRevive", _x];
	};
}, nil, 10, false, true];

//Automatic squad reviving EXAMPLE - use this to create a much more robust system
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

//EXAMPLE - Spawn unit and add revive ability (locality is Server/Dedi)
player addAction ["Create remote unit", {
	(player getRelPos [5, 0]) remoteExec ["DREAD_fnc_createUnitHere", 2];
}, nil, 10, false, true];

//EXAMPLE loop of NPC reviving player every time he goes down
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

//addMissionEventHandler ["Draw3D", DREAD_fnc_draw3DMissionEventHandler];
call DREAD_fnc_startDraw3DEventHandler;
[] spawn DREAD_fnc_startGroupReviveActionManagerLoop;

