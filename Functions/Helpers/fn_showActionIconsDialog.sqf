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