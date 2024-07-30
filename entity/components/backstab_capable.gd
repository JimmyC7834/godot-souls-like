extends AnimEntityComponent

class_name BackstabCapable
static func type() -> String:
    return "BackstabCapable"

@export var backstab_point: Node3D
@export var area: Area3D
var disabled: bool = false

func _physics_process(delta):
    if entity.eventa(TimeActEvents.TAE.CAN_CRITICAL):
        var c: Backstabbable = get_backstab_target()
        if !c: return
    
        backstab(c)

func get_backstab_target() -> Backstabbable:
    for b in area.get_overlapping_bodies():
        if b is PlayerEntity and \
            b.get_component(Backstabbable.type()):
            var a: float = b.facing_dir.angle_to(entity.facing_dir)
            if a < PI / 4:
                return b.get_component(Backstabbable.type())
    return null

func backstab(backstabbale: Backstabbable):
    backstabbale.entity.global_position = backstab_point.global_position
    backstabbale.entity.rotation.y = backstab_point.global_rotation.y
    backstabbale.backstab(null)
    
    fire_anim()
