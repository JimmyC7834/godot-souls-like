extends EntityComponent

class_name DummyInput
static func type() -> String:
    return "DummyInput"

func _ready():
    timer_action(PlayerInputController.ACTION.R_ATK_L, 2.0)

func timer_action(action: PlayerInputController.ACTION, sec: float):
    await get_tree().create_timer(sec).timeout
    if entity == null: return
    entity.action_queue.append(action)
    timer_action(action, sec)
