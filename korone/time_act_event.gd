extends Node

class_name TimeActEvents

enum TAE {
    # arg1: string = name of next anim
    RH_ATK_ANIM_CANCEL = 1,
    LH_ATK_ANIM_CANCEL = 2,
    MOVEMENT_CANCEL = 3,
    ROLL_CANCEL = 4,
    GUARD_CANCEL = 5,
    JUMP_CANCEL = 6,
    ITEM_CANCEL = 7,
    CAST_CANCEL = 8,
    
    DISABLE_TURN = 15,
    DISABLE_GRAVITY = 16,

    ATK_BEHAVIOUR = 20,
    STANDBREAK = 21,
    PARRYING = 22,
    GUARDING = 23,
    INVINCIBLE = 24,
    
    # arg1: Array[Area3D] = array of hitted area3d
    R_ATK = 25,
    L_ATK = 26,
}

const EMPTY_ARGS = [null, null, null]

var event_active = {}
var event_args = {}

signal on_event_set(e: TAE)
signal on_event_cleared(e: TAE)

func _init():
    for e in TAE.values():
        event_active[e] = false
        event_args[e] = EMPTY_ARGS

func is_event_active(e: TAE) -> bool:
    return event_active[e]

func get_event_args(e: TAE):
    return event_args[e]

func set_events(arr: Array[TAE]):
    for e in arr:
        set_event(e)

func set_event_kesy(key: TAEKey):
    pass

func set_event(e: TAE, arg1 = null, arg2 = null, arg3 = null):
    event_active[e] = true
    event_args[e] = [arg1, arg2, arg3]
    on_event_set.emit(e)
    
func clear_event(e: TAE):
    event_active[e] = false
    event_args[e] = EMPTY_ARGS
    on_event_cleared.emit(e)

func clear_all_event():
    for e in TAE.values():
        event_active[e] = false
        event_args[e] = EMPTY_ARGS
        on_event_cleared.emit(e)

func invoke_atk_behaviour(e: TAE):
    if not e in [TAE.R_ATK, TAE.L_ATK]:
        push_warning("Incorrect setup for invoke_atk_behaviour in " + name)
        return
    
    clear_event(e)
    set_event(e, [])
