#include "script_component.hpp"

PREP(changeFlag);
PREP(canChangeFlag);
PREP(changeFlag);
PREP(setObjective);

GVAR(factions) = [
    /* default */   "\A3\Data_F\Flags\Flag_white_CO.paa",
    blufor,         "\A3\Data_F\Flags\Flag_blue_CO.paa",
    opfor,          "\A3\Data_F\Flags\Flag_red_CO.paa",
    independent,    "\A3\Data_F\Flags\Flag_green_CO.paa"
];
GVAR(exclude) = [];
