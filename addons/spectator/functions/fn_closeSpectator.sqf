if !(missionNamespace getVariable ["FOX_uncon_spectator_active", false]) exitWith {};

diag_log "[FOX Uncon Spectator] closing spectator";

missionNamespace setVariable ["FOX_uncon_spectator_active", false];

[false, true, false] call ace_spectator_fnc_setSpectator;
