extends Node

class_name InputActionBuffer

enum ACTION {
    N = 0,
    MOVEMENT = 1,
    ROLL = 2,
    GUARD = 3,
    JUMP = 4,
    ITEM_USE = 5,
    CAST = 6,
    
    R_ATK = 10,
    R_ATK_L = 11,
    R_ATK_H = 12,
    L_ATK = 20,
    L_ATK_L = 21,
    L_ATK_H = 22,
}

# returns an indicator func, which if true, the action is allowed
var ACTION_EVENT_MAP = {
    ACTION.MOVEMENT: func():
        return tae.is_event_active(TimeActEvents.TAE.MOVEMENT_CANCEL),
    ACTION.R_ATK_L: func():
        return tae.is_event_active(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL),
    ACTION.R_ATK_H: func():
        return tae.is_event_active(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL),
    ACTION.ROLL: func():
        return tae.is_event_active(TimeActEvents.TAE.ROLL_CANCEL),
}

const ACTION_MAP = {
    "MOVE_FORWARD": ACTION.MOVEMENT,
    "MOVE_BACKWARD": ACTION.MOVEMENT,
    "MOVE_LEFT": ACTION.MOVEMENT,
    "MOVE_RIGHT": ACTION.MOVEMENT,
    "R1": ACTION.R_ATK_L,
    "R2": ACTION.R_ATK_H,
    "ROLL": ACTION.ROLL,
}

const BUF_FRAME: int = 20

@export var tae: TimeActEvents

# [(frame, action)]
var queue: Array[Array] = []

func _input(e):
    for key in ACTION_MAP.keys():
        if Input.is_action_just_pressed(key):
            queue.append([1, ACTION_MAP[key]])

func _physics_process(delta):
    clear_overtime_actions()

func get_first_valid_action() -> ACTION:
    var action: ACTION = ACTION.N
    for a in queue:
        if is_action_allowed(a[1]):
            clear()            
            action = a[1]

    return action

func clear_overtime_actions():
    for i in range(queue.size()):
        queue[i][0] += 1
        if queue[i][0] > BUF_FRAME:
            queue = queue.slice(i, queue.size())
            break

func pop():
    if queue.is_empty():
        return ACTION.N
    return queue.pop_front()

func clear():
    queue.clear()

func is_action_allowed(a: ACTION):
    return ACTION_EVENT_MAP[a].call()
