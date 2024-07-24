extends Area3D

class_name Hitbox

var source

func register(obj: Object):
    source = obj
    set_collision_layer_value(Global.HITBOX_LAYER, true)
    set_collision_mask_value(Global.HURTBOX_LAYER, true)
    monitorable = true
    monitoring = true
