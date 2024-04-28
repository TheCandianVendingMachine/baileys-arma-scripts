#include "script_component.hpp"

{
    _x call FUNC(teleport);
} forEach GVAR(queuedTeleports);

