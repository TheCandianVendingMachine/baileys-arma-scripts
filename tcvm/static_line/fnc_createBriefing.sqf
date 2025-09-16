#include "script_component.hpp"
// Called local to player. Generates briefing on how to defuse nukes

player createDiarySubject [QGVAR(staticLine), "Static-line Para"];
player createDiaryRecord [QGVAR(staticLine), ["How To (Pilot Guide)", "
 -- As you're approaching the drop-zone, ACE interact with the plane.<br/>
 -- Select the 'Static-line' option<br/>
 -- Wait until you are about three minutes away from the drop-zone.<br/>
 -- Change the light colour to 'STANDBY'. This allows the troopers to hook up to the static line and prepare for the jump.<br/>
 -- Once you are over the drop zone, change the light colour to 'GO'. This will start the paradrop, and all jumpers will go.<br/>
 -- Wait until all troopers are out<br/>
 -- Change the colour to OFF, and continue the flight plan
"], taskNull, "", false];

player createDiaryRecord [QGVAR(staticLine), ["How To (Trooper Guide)", "
 -- Wait until you recieve the indicator that the light has changed to STANDBY<br/>
 -- Once this happens, ACE interact with the plane<br/>
 -- Select the 'Static-line' option<br/>
 -- Select 'Hook-up'. You will be hooked up to the static line and ready for the jump.<br/>
 -- Wait until the pilot turns on the green light. When this happens, you will automatically jump out of the plane.<br/>
 -- If the pilot aborts the jump and the light turns OFF, you MUST re-hook when the light turns STANDBY again.
"], taskNull, "", false];
