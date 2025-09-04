#define COMPONENT static_line
#include "../script_component.hpp"

#define LIGHT_OFF_STR "OFF"
#define LIGHT_RED_STR "STANDBY"
#define LIGHT_GREEN_STR "GREEN"

#define ACTION_COLOUR "#ffffdd35"
#define LIGHT_OFF_COLOUR "#ffdddddd"
#define LIGHT_RED_COLOUR "#ffdd1111"
#define LIGHT_GREEN_COLOUR "#ff11ff11"

#define LIGHT_OFF_TEXT (format ["<t color='%1'>%2</t>", LIGHT_OFF_COLOUR, LIGHT_OFF_STR])
#define LIGHT_RED_TEXT (format ["<t color='%1'>%2</t>", LIGHT_RED_COLOUR, LIGHT_RED_STR])
#define LIGHT_GREEN_TEXT (format ["<t color='%1'>%2</t>", LIGHT_GREEN_COLOUR, LIGHT_GREEN_STR])
