#include "script_component.hpp"

[ACE_PLAYER] joinSilent GVAR(traitorGroup);
ACE_PLAYER addItem TRAITOR_RADIO;
ACE_PLAYER setVariable [QGVAR(money), GVAR(traitorStartMoney), true];

[ACE_PLAYER, 1, ["ACE_SelfActions"], GVAR(traitorBuyAceInteract)] call ace_interact_menu_fnc_addActionToObject;

hint "You are a traitor! Read your briefing to understand what to do and who your fellow traitors are";

ACE_PLAYER createDiarySubject [QGVAR(traitorBrief), "TRAITOR BRIEFING"];
ACE_PLAYER createDiaryRecord [QGVAR(traitorBrief), ["BREIF", "You are a TRAITOR. Your goal is to kill all of the INNOCENTS before the mission is over. To do this, you need to acquire weapons and kill off the innocents<br/><br/>You have access to special weaponry if you have the money for it. Self-Interact and you will see a 'Buy' menu. From here you can purcahse various weapons that may cause yourself to be known as a TRAITOR.<br/><br/>Some weapons you purchase may need you to interact with dead bodies or self interact to activate. Others will automatically be added to your person"]];
private _traitors = "";
{
    private _playerName = name (allRealPlayers select _x);
    _traitors = _traitors + _playerName + "<br/>"
} forEach GVAR(traitors);
ACE_PLAYER createDiaryRecord [QGVAR(traitorBrief), ["TRAITORS", _traitors]];

