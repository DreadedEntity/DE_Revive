/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

[me, man, man_1, man_2, man_3] apply {
	_x call DREAD_fnc_addRevive;
};
//sleep 0.5;
[man, man_1, man_2] apply { _x setDamage 0.99; [_x,[0,0,-8]] remoteExec ["setVelocityModelSpace", _x]; };