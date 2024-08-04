class_name State

enum Type {
    IDLE = 0,
    WALKING = 1,
    RUNNING = 2,
    ANIM = 3,
}

var type: Type = Type.IDLE
var enter: Callable
var update: Callable
var exit: Callable

func _init(_type, _enter: Callable, _update: Callable, _exit: Callable):
    self.type = _type
    self.enter = _enter
    self.update = _update
    self.exit = _exit

class StateMachine:
    var cur: State
    
    func enter_state(state: State):
        print("State changed from ", cur.type, " to ", state.type)
        cur.exit.call()
        state.enter.call()
        cur = state
   
    func update(delta):
        if !cur: return
        cur.update.call(delta)
