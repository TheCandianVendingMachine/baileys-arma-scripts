#include "script_component.hpp"

params ["_vehicle"];

switch (true) do {
    case (_vehicle isKindOf "Air"): {
        private _engineDamage = _vehicle getHitPointDamage "HitEngine";
        private _rotorDamage = _vehicle getHitPointDamage "HitHRotor";
        !alive _vehicle || { _engineDamage == 1 } || { _rotorDamage == 1 } || { 0 == fuel _vehicle }
    };
    default { !alive _vehicle }
}