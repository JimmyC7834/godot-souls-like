extends EntityComponent

class_name DummyInput
static func type() -> String:
    return "DummyInput"

func _ready():
    timer_action(PlayerInputController.ACTION.R_ATK_L, 2.0)

func _physics_process(delta):
    if entity.eventa(TimeActEvents.TAE.STANDBREAK):
        var ca: CriticalArea = entity.get_component(CriticalArea.type()) as CriticalArea
        var source: PlayerEntity = ca.get_critical_source()
        if source:
            source.global_position = ca.point.global_position
            source.look_at(entity.global_position)
            source.request_one_shot("PC/Crit")
            ca.critical_hit(null)

func timer_action(action: PlayerInputController.ACTION, sec: float):
    await get_tree().create_timer(sec).timeout
    if entity == null: return
    entity.action_queue.append(action)
    timer_action(action, sec)
