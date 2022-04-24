/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

//(format ["Adding event handler: %1", _this]) remoteExec ["systemChat", 0];
[_this,["HandleDamage", DREAD_fnc_handleDamageEventHandler]] remoteExec ["addEventHandler", 0];