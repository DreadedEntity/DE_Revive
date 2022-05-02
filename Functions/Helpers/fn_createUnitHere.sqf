/////////////////////////////////////
// Function file for Armed Assault //
//    Created by: DreadedEntity    //
/////////////////////////////////////

private _unit = (createGroup east) createUnit ["O_officer_F", _this, [], 0, "NONE"];
[_unit, true] remoteExec ["setCaptive", _unit];
_unit call DREAD_fnc_addRevive;