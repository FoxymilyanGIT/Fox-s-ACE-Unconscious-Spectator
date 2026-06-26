if (missionNamespace getVariable ["FOX_uncon_spectator_active", false]) exitWith {};

diag_log "[FOX Uncon Spectator] opening spectator";

missionNamespace setVariable ["FOX_uncon_spectator_active", true];

// Кого можно наблюдать.
// Пока разрешаем всех живых игроков, кроме себя.
[
    allPlayers select { alive _x && { _x != player } },
    [player]
] call ace_spectator_fnc_updateUnits;

// Разрешённые режимы камеры:
// 0 - свободная камера
// 1 - вид от первого лица
// 2 - следование за юнитом
[[0, 1, 2], []] call ace_spectator_fnc_updateCameraModes;

// Стартовая позиция камеры рядом с телом игрока
[
    0,
    objNull,
    -2,
    getPosATL player,
    getDir player
] call ace_spectator_fnc_setCameraAttributes;

// Включаем spectator.
// true  - включить
// true  - принудительный интерфейс, нельзя закрыть ESC
// false - НЕ скрывать тело игрока, чтобы его могли лечить
[true, true, false] call ace_spectator_fnc_setSpectator;
