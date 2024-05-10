#include "script_component.hpp"

[ACE_PLAYER] joinSilent GVAR(detectiveGroup);
ACE_PLAYER setVariable [QGVAR(money), GVAR(detectiveStartMoney)];

[ACE_PLAYER, 1, ["ACE_SelfActions"], ttt_detectiveBuyAceInteract] call ace_interact_menu_fnc_addActionToObject;

removeHeadgear ACE_PLAYER;
ACE_PLAYER addHeadgear DETECTIVE_HAT;

removeUniform ACE_PLAYER;
ACE_PLAYER forceAddUniform DETECTIVE_UNIFORM;

hint "You are a detective! Read your briefing to understand what to do";

ACE_PLAYER createDiarySubject ["detectiveBrief", "DETECTIVE BRIEFING"];
ACE_PLAYER createDiaryRecord ["detectiveBrief", ["BREIF", "You are a DETECTIVE. Your goal is to kill all of the TRAITORS before the mission is over. To do this, you need to figure out who are traitors and kill them<br/><br/>You have access to special weaponry if you have the money for it. Self-Interact and you will see a 'Buy' menu. From here you can purcahse various weapons that may help to determine who are TRAITORs.<br/><br/>Some weapons you purchase may need you to interact with dead bodies or self interact to activate. Others will automatically be added to your person"]]

