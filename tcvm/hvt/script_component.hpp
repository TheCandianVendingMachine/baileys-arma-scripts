#define COMPONENT hvt
#include "../script_component.hpp"
#define HVT_SPAWN_COOLDOWN 1.7
#define HVT_GET_IN_TIME 2
#define HVT_WALK_INTERVAL 1
#define HVT_WAIT_DISTANCE 4
#define LOAD_STATE_WAIT 0
#define LOAD_STATE_SPAWN 1
#define LOAD_STATE_COOLDOWN 2
#define LOAD_STATE_STRINGS ["Wait", "Spawn", "Cooldown"]
#define HVT_STATE_WAIT 0
#define HVT_STATE_MOVE_TO_POSITION 1
#define HVT_STATE_MOVE_TO_VEHICLE 2
#define HVT_STATE_GET_IN_VEHICLE 3
#define HVT_STATE_IN_VEHICLE 4
#define HVT_STATE_DEAD 5
#define HVT_STATE_STRINGS ["Wait", "Move To Position", "Move To Vehicle", "Get In Vehicle", "In Vehicle", "Dead"]
#define VEHICLE_STATE_MOVING 0
#define VEHICLE_STATE_LOADING 1
#define VEHICLE_STATE_UNLOADING 2
#define VEHICLE_STATE_FULL 3
#define VEHICLE_STATE_DEAD 4
#define VEHICLE_STATE_STRINGS ["Moving", "Loading", "Unloading", "Full", "Dead"]