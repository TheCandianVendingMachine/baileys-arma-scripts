#include "script_component.hpp"
player createDiarySubject [QGVAR(defusalGuide), "EOD for Dummies"];
player createDiarySubject [QGVAR(types), "Nuclear Weapon QRH"];
player createDiaryRecord [QGVAR(defusalGuide), ["Back of book", "
    Harrowing... important - The Sunday Oregonian<br/>
    A stellar reporting achievement - Ottawa Citizen<br/>
    Visceral... Sometimes shocking - New York Times
"], taskNull, "?", false];
private _randomPlayer = name selectRandom (allPlayers - entities "HeadlessClient_f");
player createDiaryRecord [QGVAR(defusalGuide), ["Dedications", format ["Dedicated To %1", _randomPlayer]], taskNull, "?", false];
player createDiaryRecord [QGVAR(defusalGuide), ["Closing Words", "Bomb defusal is tough, but it doesn't have to be. This book should of provided you with the knowledge required to defuse any bomb you may encounter."], taskNull, "?", false];
player createDiaryRecord [QGVAR(defusalGuide), ["What to expect if you fail", "Failing is not recommended. If you cut a wire out-of-order, or one that isn't to be cut at all, the bomb will trigger it's anti-tampering device and explode immediately. If you do fail, make sure you aren't near the bomb."], taskNull, "?", false];
player createDiaryRecord [QGVAR(defusalGuide), ["How to Defuse a Bomb", "Defusing bombs is a fairly complex ordeal, so the govenments of the world have agreed to standardise the defusal process. The International Standards Office has determined this protocol for the defusing of bombs (ISO3103):<br/>
<br/>- Step 1: Determine the type of bomb. ACE interact with the suspected bomb and select 'Determine Bomb Type'. This may take some time. Only EOD members can reliably determine bomb type, so be careful of false reports from amatures!
<br/>- Step 2: Figure out the defusal sequence. You should have gotten a handbook alongside this guide. Study it well, and determine the order of wires to cut.
<br/>- Step 3: Defuse the bomb. ACE interact with the suspected bomb and select 'Attempt Defusal' (You must have a Defusal Kit on you to have this option). Simply click on the wires in the order given by step 2 to safely defuse the bomb
<br/><br/>Now you too can defuse any bomb given to you! Good luck out there!
"], taskNull, "?", false];
player createDiaryRecord [QGVAR(defusalGuide), ["Basics of EOD", "'EOD' stands for 'Explosive Ordinance Disposal'. Your job is to go up the bomb and figure out how to ensure it doesn't blow up. This is a very dangerous job reserved for only the smartest individuals, so be careful out there!"], taskNull, "?", false];
player createDiaryRecord [QGVAR(defusalGuide), ["Welcome", "Welcome to EOD for Dummies! In this book we will be discussing the basics of EOD, how to defuse bombs, and what to expect if you fail!"], taskNull, "?", false];
{
    (GVAR(database) get _x) params ["_description", "_yield", "_defusalOrder"];
    private _defusalOrderString = "";
    {
        _x params ["", "_fontColour", "_colourName"];
        _defusalOrderString = _defusalOrderString + format["<font color='%1'>%2</font> ", _fontcolour, _colourName];
    } forEach _defusalOrder;
    player createDiaryRecord [QGVAR(types), [_x, format ["Description:<br/>%1<br/><br/>Yield: %2 Kilotonnes<br/>Defusal Order: %3", _description, _yield, _defusalOrderString]], taskNull, "?", false];
} forEach GVAR(allTypes);
