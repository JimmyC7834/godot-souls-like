extends EntityComponent

class_name CriticalArea
static func type() -> String:
    return "CriticalArea"

@export var damaged_anim: StringName
@export var seek: float = -1.0
@export var scale: float = 1.0
@export var area: Area3D
@export var point: Node3D
var disabled: bool = false

func get_critical_source() -> PlayerEntity:
    for b in area.get_overlapping_bodies():
        if b is PlayerEntity and b.eventa(TimeActEvents.TAE.CAN_CRITICAL):
            return b
    return null

func critical_hit(damage: Damage):
    entity.one_shot_interupt()
    entity.request_one_shot(damaged_anim, seek, scale)
    #entity.damage(damage)
    await get_tree().create_timer(1).timeout
    entity.one_shot_interupt()
    entity.request_one_shot("LM2/Fall_Backward")
    
