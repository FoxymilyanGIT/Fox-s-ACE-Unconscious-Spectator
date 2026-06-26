if (missionNamespace getVariable ["FOX_uncon_spectator_active", false]) exitWith {};

diag_log "[FOX Uncon Spectator] opening spectator";

missionNamespace setVariable ["FOX_uncon_spectator_active", true];

// Сохраняем сторону игрока в момент потери сознания.
// Для Independent тут обычно будет resistance.
private _playerSide = side group player;

missionNamespace setVariable ["FOX_uncon_spectator_side", _playerSide];

diag_log format ["[FOX Uncon Spectator] player side: %1", _playerSide];

// Все возможные стороны в ACE Spectator.
private _allSides = [west, east, resistance, civilian];

// Разрешаем только сторону игрока.
// Остальные стороны убираем из spectator.
[
    [_playerSide],
    _allSides - [_playerSide]
] call ace_spectator_fnc_updateSides;

// Игроки, которых можно выбрать в списке слева:
// - живые
// - не сам игрок
// - на той же стороне
private _spectatableUnits = allPlayers select {
    alive _x
    && { _x != player }
    && { side group _x == _playerSide }
};

// Явно обновляем список юнитов в spectator.
// Первый массив - кого показывать.
// Второй массив - кого скрывать.
[
    _spectatableUnits,
    allPlayers - _spectatableUnits
] call ace_spectator_fnc_updateUnits;

// Доступные режимы камеры:
// 0 - Free camera
// 1 - First person
// 2 - Follow / third person
[[0, 1, 2], []] call ace_spectator_fnc_updateCameraModes;

// Автообновление списка, пока игрок в нашем spectator.
// Нужно, чтобы новые респавны/смерти/подключения обновлялись в списке слева.
[_playerSide] spawn {
    params ["_playerSide"];

    while { missionNamespace getVariable ["FOX_uncon_spectator_active", false] } do {
        private _spectatableUnits = allPlayers select {
            alive _x
            && { _x != player }
            && { side group _x == _playerSide }
        };

        [
            _spectatableUnits,
            allPlayers - _spectatableUnits
        ] call ace_spectator_fnc_updateUnits;

        sleep 2;
    };
};

// Если есть союзник, сразу ставим камеру на него.
// Потом игрок сможет выбрать другого союзника в списке слева.
if (_spectatableUnits isNotEqualTo []) then {
    [
        2,
        _spectatableUnits select 0,
        -2,
        [],
        0
    ] call ace_spectator_fnc_setCameraAttributes;
} else {
    // Если союзников нет, камера стартует около тела игрока.
    [
        0,
        objNull,
        -2,
        getPosATL player,
        getDir player
    ] call ace_spectator_fnc_setCameraAttributes;
};

// Включаем spectator.
// hidePlayer = false, чтобы тело игрока оставалось лечимым.
[true, true, false] call ace_spectator_fnc_setSpectator;
