/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

private ["_icon","_color"];
(player nearEntities ["Man", 300]) apply {
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