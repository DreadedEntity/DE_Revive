//player addAction ["View icons", {
//	[] spawn {
//		// EXECUTE in EDEN EDITOR or EDITOR PREVIEW!
//		disableSerialization;
//	
//		private _display = findDisplay 313 createDisplay "RscDisplayEmpty";
//	
//		private _edit = _display ctrlCreate ["RscEdit", 645];
//		_edit ctrlSetPosition [safeZoneX + 50 * pixelW, safeZoneY + 50 * pixelH, safeZoneW - 500 * pixelW, 50 * pixelH];
//		_edit ctrlSetBackgroundColor [0,0,0,1];
//		_edit ctrlCommit 0;
//	
//		private _status = _display ctrlCreate ["RscEdit", 1337];
//		_status ctrlSetPosition [safeZoneX + safeZoneW - 400 * pixelW, safeZoneY + 50 * pixelH, 350 * pixelW, 50 * pixelH];
//		_status ctrlSetBackgroundColor [0,0,0,1];
//		_status ctrlCommit 0;
//		_status ctrlEnable false;
//	
//		private _tv = _display ctrlCreate ["RscTreeSearch", -1];
//		_tv ctrlSetFont "EtelkaMonospacePro";
//		_tv ctrlSetFontHeight 0.05;
//		_tv ctrlSetPosition [safeZoneX + 50 * pixelW, safeZoneY + 125 * pixelH, safeZoneW - 100 * pixelW, safeZoneH - 175 * pixelH];
//		_tv ctrlSetBackgroundColor [0,0,0,1];
//		_tv ctrlCommit 0;
//	
//		_tv ctrlAddEventHandler ["treeSelChanged",
//		{
//			params ["_ctrlTV", "_selectionPath"];
//			copyToClipboard (_ctrlTV tvText _selectionPath);
//			playSound ("RscDisplayCurator_ping" + selectRandom ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"]);
//			(ctrlParent _ctrlTv) displayCtrl 1337 ctrlSetText "Path copied to clipboard!";
//		}];
//	
//		private _counter = 0;
//		{
//			private _files = addonFiles [_x # 0, ".paa"];
//			{
//				if ("\actions" in _x || "\holdaction" in _x) then
//				{
//					_counter = _counter + 1;
//					_status ctrlSetText format ["%1 textures found.", _counter];
//					private _index = _tv tvAdd [[], _x];
//					_tv tvSetPicture [[_index], _x];
//				};
//			} forEach _files;
//		} forEach allAddonsInfo;
//	
//		_tv tvSortAll [[], false];
//	};
//}, nil, 10, false, true];

addPlayerClickRevive = {
	_this addAction [format ["Revive %1 %2", [toUpper ((rank _this) select [0,1]), toLower ((rank _this) select [1, count (rank _this) - 1])] joinString "", (name _this splitString " ") # ((count (name _this splitString " ")) - 1)], {
		params ["_target", "_caller", "_actionId", "_arguments"];
		_caller playMove "AinvPknlMstpSnonWnonDnon_medic1";
		_caller playMove "AinvPknlMstpSnonWnonDnon_medic2";
		_caller playMove "AinvPknlMstpSnonWnonDnon_medicEnd";
		sleep 10;
		[_target, false] call unitSetReviveState;
		_target setDamage 0;
	}, nil, 1000, false, true, "", "lifeState _target == 'INCAPACITATED'"];
};

addPlayerHoldRevive = {
	[_this, 
	format ["revive %1 %2", [toUpper ((rank _this) select [0,1]), toLower ((rank _this) select [1, count (rank _this) - 1])] joinString "", (name _this splitString " ") # ((count (name _this splitString " ")) - 1)],
	"a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa",
	"a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa",
	"lifeState _target == 'INCAPACITATED' && _this == player && {_target != player && {_target distance _this < 3}}",
	"true",
	{
		(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic1";
		(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic2";
		(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic3";
	},
	nil,
	{ [_this # 0, false] call unitSetReviveState; (_this # 0) setDamage 0; (_this # 1) playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd"; },
	{ (_this # 1) playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd" },
	nil,
	14,
	1000,
	true,
	true,
	true] call BIS_fnc_holdActionAdd;
};

addRevive = {
	_this addEventHandler ["HandleDamage", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		if (_damage >= 0.99) then {
			if !(lifeState _unit == "INCAPACITATED") then {
				[_unit, true] call unitSetReviveState;
				_unit call addPlayerHoldRevive;
				_unit setVariable ["DE_TIME_KILLED", time];
			};
			_damage = 0;
		};
		_damage;
	}];
};

unitSetReviveState = {
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
};

unitReviveBody = {
	params ["_unit", "_body"];
	private ["_relativeDir", "_pos", "_leader"];
	_unit groupChat format ["I am going to revive %1 %2, cover me!", [toUpper ((rank _body) select [0,1]), toLower ((rank _body) select [1, count (rank _body) - 1])] joinString "", (name _body splitString " ") # ((count (name _body splitString " ")) - 1)];
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
	[_body, false] call unitSetReviveState;
	_body setDamage 0;
	_leader = leader _unit;
	_unit setFormDir (_unit getDir _leader);
	_unit doFollow _leader;
};
unitReviveBodyAction = {
	[_this # 0, _this # 3] call unitReviveBody;
	(_this # 0) removeAction (_this # 2);
};

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
								_actionIndex = _x addAction [format ["Revive %1", name _deadMan], unitReviveBodyAction, _deadMan, 1000, false, true, "", "!(isPlayer _this)"];
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
			};
			sleep 0.01;
		} forEach allUnits;
		sleep 1;
	};
};

//[] spawn {
//	while {true} do {
//		{
//			if (lifeState _x == "INCAPACITATED") then {
//				sleep 2;
//				[man_3, _x] call unitReviveBody;
//			};
//		} forEach allUnits;
//		sleep 1;
//	};
//};

player addAction ["Start revive loop", {
	{
		if (lifeState _x == "INCAPACITATED") then {
			[man_3, _x] call unitReviveBody;
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
			[man_3, player] call unitReviveBody;
			man_3 removeAction (man_3 getVariable (str player));
		};
		sleep 1;
	};
};

addMissionEventHandler ["Draw3D", {
	allUnits apply {
		if (lifeState _x == "INCAPACITATED") then {
			_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revivemedic_ca.paa";
			_color = [1,0,0,1];
			if (!isNil {_x getVariable "DE_REVIVING"}) then {
				_icon = "a3\ui_f\data\igui\cfg\holdactions\holdaction_revive_ca.paa";
				_color = [1,1,0,1];
			};
			drawIcon3D [_icon, _color, ASLToAGL (aimPos _x), 1, 1, 1, "", true, 0, "RobotoCondensed", "", true];
		};
	};
}];

[player, man, man_1, man_2, man_3] apply { _x call addRevive};
//man call addPlayerClickRevive;
[man, man_1, man_2] apply { _x setDamage 0.99; _x setVelocityModelSpace [0,0,-7] };

player addRating 9001;