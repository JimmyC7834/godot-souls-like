extends Area3D

class_name EntityHurtbox

enum TYPE {
    STANDARD,
    HEAD,
    LIMB,
    BODY
}

@export var type: TYPE
var entity: GameEntity

signal on_hit(hitbox: EntityHitbox)

func register(e: GameEntity):
    entity = e
    set_collision_layer_value(Global.HURTBOX_LAYER, true)
    set_collision_mask_value(Global.HITBOX_LAYER, true)
    monitorable = true
    monitoring = true

func hit(hitbox: EntityHitbox):
    on_hit.emit(hitbox)
