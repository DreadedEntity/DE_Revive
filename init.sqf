player addAction ["View icons", {
	[] spawn {
		// EXECUTE in EDEN EDITOR or EDITOR PREVIEW!
		disableSerialization;
	
		private _display = findDisplay 313 createDisplay "RscDisplayEmpty";
	
		private _edit = _display ctrlCreate ["RscEdit", 645];
		_edit ctrlSetPosition [safeZoneX + 50 * pixelW, safeZoneY + 50 * pixelH, safeZoneW - 500 * pixelW, 50 * pixelH];
		_edit ctrlSetBackgroundColor [0,0,0,1];
		_edit ctrlCommit 0;
	
		private _status = _display ctrlCreate ["RscEdit", 1337];
		_status ctrlSetPosition [safeZoneX + safeZoneW - 400 * pixelW, safeZoneY + 50 * pixelH, 350 * pixelW, 50 * pixelH];
		_status ctrlSetBackgroundColor [0,0,0,1];
		_status ctrlCommit 0;
		_status ctrlEnable false;
	
		private _tv = _display ctrlCreate ["RscTreeSearch", -1];
		_tv ctrlSetFont "EtelkaMonospacePro";
		_tv ctrlSetFontHeight 0.05;
		_tv ctrlSetPosition [safeZoneX + 50 * pixelW, safeZoneY + 125 * pixelH, safeZoneW - 100 * pixelW, safeZoneH - 175 * pixelH];
		_tv ctrlSetBackgroundColor [0,0,0,1];
		_tv ctrlCommit 0;
	
		_tv ctrlAddEventHandler ["treeSelChanged",
		{
			params ["_ctrlTV", "_selectionPath"];
			copyToClipboard (_ctrlTV tvText _selectionPath);
			playSound ("RscDisplayCurator_ping" + selectRandom ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"]);
			(ctrlParent _ctrlTv) displayCtrl 1337 ctrlSetText "Path copied to clipboard!";
		}];
	
		private _counter = 0;
		{
			private _files = addonFiles [_x # 0, ".paa"];
			{
				if ("\actions" in _x || "\holdaction" in _x) then
				{
					_counter = _counter + 1;
					_status ctrlSetText format ["%1 textures found.", _counter];
					private _index = _tv tvAdd [[], _x];
					_tv tvSetPicture [[_index], _x];
				};
			} forEach _files;
		} forEach allAddonsInfo;
	
		_tv tvSortAll [[], false];
	};
}, nil, 10, false, true];

man addAction ["Revive soldier", {
	params ["_target", "_caller", "_actionId", "_arguments"];
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic1";
	_caller playMove "AinvPknlMstpSnonWnonDnon_medic2";
	_caller playMove "AinvPknlMstpSnonWnonDnon_medicEnd";
	sleep 10;
	_target setUnconscious false;
	_target setCaptive false;
	_target allowDamage true;
	_target setDamage 0;
}, nil, 1000, false, true, "", "lifeState _target == 'INCAPACITATED'"];

addRevive = {
_this addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	
	if (_damage >= 0.99) then {
		if !(lifeState _unit == "INCAPACITATED") then {
			_unit setUnconscious true;
			_unit setCaptive true;
			_unit allowDamage false;
			[_unit, 
			"Revive soldier",
			"a3\missions_f_oldman\data\img\holdactions\holdaction_talk_ca.paa",
			"a3\ui_f\data\igui\cfg\actions\ico_cpt_start_on_ca.paa",
			"lifeState _target == 'INCAPACITATED' && _this == player && {_target distance _this < 3}",
			"true",
			{ systemChat "Begin action"; systemChat str _this;
				(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic1";
				(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic2";
				(_this # 1) playMove "AinvPknlMstpSnonWnonDnon_medic3";
			},
			nil,
			{ systemChat "End action"; systemChat str _this; (_this # 0) setDamage 0; (_this # 0) setUnconscious false; (_this # 0) setVariable ["DE_CAN_REVIVE", false]; (_this # 0) allowDamage true; (_this # 1) playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd"; },
			{ systemChat "Action interrupted"; systemChat str _this; (_this # 1) playMoveNow "AinvPknlMstpSnonWnonDnon_medicEnd" },
			nil,
			14,
			1000,
			true,
			true,
			true] call BIS_fnc_holdActionAdd;
			_unit setVariable ["DE_CAN_REVIVE", true];
		};
		_damage = 0;
	};
	_damage;
}];
};

[man, man_1, man_2] apply { _x call addRevive};
[man, man_1, man_2] apply { _x setDamage 0.99; _x setPos ((getPos _x) vectorAdd [0,0,3]) };

[] spawn {
	private "_deadMan";
	while {true} do {
		{
			if (lifeState _x == "INCAPACITATED") then {
				_deadMan = _x;
				(units player) apply {
					if (isNil {_x getVariable (str _deadMan)}) then {
						if (_x distance _deadMan < 50) then {
							if !(isPlayer _x) then {
								systemChat format ["Creating revive for %1", name _deadMan];
								_x addAction [format ["Revive %1", name _deadMan], {
								}, nil, 1000, false, true, "", "!(isPlayer _this)"];
								_x setVariable [str _deadMan, _deadMan];
							};
						};
					};
				};
			};
		} forEach allUnits;
		sleep 1;
	};
};