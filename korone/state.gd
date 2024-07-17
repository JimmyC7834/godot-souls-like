class_name State

var name: String
var enter: Callable
var update: Callable
var exit: Callable

func _init(name: String, enter: Callable, update: Callable, exit: Callable):
    self.name = name
    self.enter = enter
    self.update = update
    self.exit = exit

class StateMachine:
    var cur: State
    
    func enter_state(state: State):
        print("State changed from ", cur.name, " to ", state.name)
        cur.exit.call()
        state.enter.call()
        cur = state
   
    func update(delta):
        if !cur: return
        cur.update.call(delta)
