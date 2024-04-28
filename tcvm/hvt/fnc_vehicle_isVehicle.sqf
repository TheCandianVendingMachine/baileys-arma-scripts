#include "script_component.hpp"
params ["_object"];
(_object isKindOf "Air") || { (_object isKindOf "LandVehicle") && !(_object isKindOf "StaticWeapon") } || { _object isKindOf "Ship" }