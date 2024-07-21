extends Equipment

class_name Weapon

@export var anim_light_atk: StringName
@export var anim_heavy_atk: StringName
@export var anim_run_atk: StringName

func _ready():
    set_collision_layer_value(Global.HITBOX_LAYER, true)
    set_collision_mask_value(Global.HURTBOX_LAYER, true)
