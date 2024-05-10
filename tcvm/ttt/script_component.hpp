#define COMPONENT ttt
#include "../script_component.hpp"

#define PRETTY_TIME(seconds) (str(floor((seconds) / 60)) + ":" + format["%1%2", floor(((seconds) % 60) / 10), floor(((seconds) % 60) % 10)])
#define MONEY_LOST_FF -15
#define MONEY_GAINED_ACCURATE 25
#define DNA_SCANNER ("potato_serverBox")
#define TTT_PLAYZONES ([\
    "playzone_0",\
    "playzone_1",\
    "playzone_2",\
    "playzone_3",\
    "playzone_4",\
    "playzone_5",\
    "playzone_6",\
    "playzone_7",\
    "playzone_M0",\
    "playzone_M1",\
    "playzone_M2",\
    "playzone_M3",\
    "playzone_M4",\
    "playzone_M5",\
    "playzone_M6",\
    "playzone_M7",\
    "playzone_M8",\
    "playzone_M9",\
    "playzone_M10"\
])

#define INNOCENT_RADIO "ACRE_PRC343"
#define TRAITOR_RADIO "ACRE_PRC148"

#define DETECTIVE_HAT "CUP_H_C_Policecap_01"
#define DETECTIVE_UNIFORM "CUP_U_C_Policeman_01"