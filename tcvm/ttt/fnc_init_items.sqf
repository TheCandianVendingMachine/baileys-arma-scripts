#include "script_component.hpp"

// [item id, item name, cost, code, condition]
GVAR(items) = [
    ["c4", "C4", 50, { _this addItem "SatchelCharge_Remote_Mag"; }, { _this canAdd "SatchelCharge_Remote_Mag" }],
    ["silence_pistol", "Silenced Makarov", 55, { _this removeWeapon (handgunWeapon _this); _this addMagazine "CUP_8Rnd_9x18_MakarovSD_M"; _this addWeapon "CUP_hgun_PB6P9"; _this addWeaponItem ["CUP_hgun_PB6P9", "CUP_muzzle_PB6P9"]; }],
    ["sniper", "Sniper Rifle", 55, { _this removeWeapon (primaryWeapon _this); _this addMagazine "hlc_20rnd_762x51_T_G3"; _this addWeapon "hlc_rifle_psg1"; }],
    ["binos", "Binoculars", 35, { _this linkItem  "Binocular" }, { (binocular _this) isEqualTo "" }],
    ["armour_l", "Body Armour (Light)", 20, { removeVest _this; _this addVest "V_TacVest_camo" }, { !((vest _this) isEqualTo "V_TacVest_camo") }],
    ["armour_h", "Body Armour (Heavy)", 50, { removeVest _this; _this addVest "V_PlateCarrierGL_blk" }, { !((vest _this) isEqualTo "V_PlateCarrierGL_blk") }],
    ["thermite_grenade", "Thermite Grenade", 15, { _this addItem "ACE_M14"; }, { _this canAdd "ACE_M14" }],
    ["radar", "Radar", 25, {
        _this setVariable [QGVAR(hasRadar), true];
        private _markers = [];
        {
            if ([_x] call FUNC(isAlive)) then {
                _markers pushBack [_x, createMarkerLocal [str _x, [0, 0, 0]]];
            };
        } forEach allRealPlayers;
        [FUNC(radar), 15, [_markers]] call CBA_fnc_addPerFrameHandler;
    }, { !(_this getVariable [QGVAR(hasRadar), false]) }],
    ["suicide", "Suicide Vest", 60, {
        _this setVariable [QGVAR(hasSuicideVest), true];
        
        private _action = ["suicide_vest", "Activate Vest", "", {
            params ["", "_player"];
            [QGVAR(play), [_player, QGVAR(suicideBomber)]] call CBA_fnc_globalEvent;
            removeAllWeapons _player;
            [{
                params ["_player"];
                if ([_player] call FUNC(isAlive)) then {
                    private _bomb = createVehicle ["SatchelCharge_Remote_Ammo_Scripted", [0, 0, 0], [], 0, "NONE"];
                    _bomb setPosASL getPosASL _player;
                    _bomb setDamage 1;
                };
            }, [_player], 2.98] call CBA_fnc_waitAndExecute;
        }, {true}, {}, []] call ace_interact_menu_fnc_createAction;
        [_this, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
        
    }, { !(_this getVariable [QGVAR(hasSuicideVest), false]) }],
    ["burn", "Burn Body", 40, {
        _this setVariable [QGVAR(hasBurnItem), true];
    }, { !(_this getVariable [QGVAR(hasBurnItem), false]) }],
    ["dna", "DNA Scanner", 15, { _this addItem DNA_SCANNER }, { _this canAdd DNA_SCANNER }],
    ["health", "Health Station", 40, {
        private _station = createVehicle ["CUP_fridge", [0, 0, 0], [], 0, "NONE"];
        _station setPosASL getPosASL _this;
        _station setVariable [QGVAR(usesLeft), 5];
        _action = [QGVAR(healthStation),"Heal Up","",{
           params ["_target", "_player"];
           private _usesLeft = (_target getVariable QGVAR(usesLeft)) - 1;
           _target setVariable [QGVAR(usesLeft), _usesLeft, true];
           ["ace_medical_treatment_fullHealLocal", [_player, _player], _player] call CBA_fnc_targetEvent;
           _player groupChat format ["You are healed. Uses left %1", _usesLeft];
        },{
            params ["_target", "_player"];
            (_target getVariable QGVAR(usesLeft)) > 0
        },{},[], [0,0,1], 5] call ace_interact_menu_fnc_createAction;
        [_station, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
    }]
];