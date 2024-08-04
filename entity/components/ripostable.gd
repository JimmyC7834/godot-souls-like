extends AnimEntityComponent

class_name Ripostable
static func type() -> String:
    return "Ripostable"

@export var area: Area3D
@export var riposte_point: Node3D
var disabled: bool = false

func _physics_process(_delta):
    if entity.eventa(TimeActEvents.TAE.STANDBREAK):
        var c: RiposteCapable = get_riposte_source()
        if !c: return

        c.riposte(self)
        riposte(null)

func get_riposte_source() -> RiposteCapable:
    for b in area.get_overlapping_bodies():
        if b is PlayerEntity and \
            b.eventa(TimeActEvents.TAE.CAN_CRITICAL) and \
            b.get_component(RiposteCapable.type()):
            var a: float = b.facing_dir.angle_to(entity.facing_dir)
            if a > PI / 2:
                return b.get_component(RiposteCapable.type())
    return null

func riposte(damage: Damage):
    fire_anim()
    await get_tree().create_timer(1).timeout
    entity.one_shot_interupt()
    entity.request_one_shot("LM2/Fall_Backward")
    
