if (!hasInterface) exitWith {};

diag_log "[FOX Uncon Spectator] init loaded";

// ACE Medical: игрок потерял/вернул сознание
["ace_unconscious", {
    params ["_unit", "_state"];

    private _controlledPlayer = missionNamespace getVariable ["ACE_player", player];

    if (_unit != _controlledPlayer) exitWith {};

    if (_state) then {
        [] call FOX_fnc_openSpectator;
    } else {
        [] call FOX_fnc_closeSpectator;
    };
}] call CBA_fnc_addEventHandler;


// Навешиваем обработчики на текущего игрока и на нового после respawn.
// Это нужно, потому что после респавна объект player может быть уже другим.
["unit", {
    params ["_newUnit", "_oldUnit"];

    if (isNull _newUnit) exitWith {};

    if (_newUnit getVariable ["FOX_unconSpectator_EHsAdded", false]) exitWith {};
    _newUnit setVariable ["FOX_unconSpectator_EHsAdded", true];

    _newUnit addEventHandler ["Killed", {
        params ["_unit", "_killer", "_instigator", "_useEffects"];

        diag_log "[FOX Uncon Spectator] player killed, closing spectator";

        [] call FOX_fnc_closeSpectator;
    }];

    _newUnit addEventHandler ["Respawn", {
        params ["_unit", "_corpse"];

        diag_log "[FOX Uncon Spectator] player respawned, closing spectator";

        // После респавна точно закрываем наш spectator
        [] call FOX_fnc_closeSpectator;

        // Страховка с задержкой, потому что respawn-скрипты миссии могут творить цирк
        [{
            [] call FOX_fnc_closeSpectator;
            [false, true, false] call ace_spectator_fnc_setSpectator;
        }, [], 0.25] call CBA_fnc_waitAndExecute;
    }];
}, true] call CBA_fnc_addPlayerEventHandler;
