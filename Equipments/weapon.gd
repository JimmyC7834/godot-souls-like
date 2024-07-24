extends Equipment

class_name Weapon

@export var anim_light_atk: StringName
@export var anim_heavy_atk: StringName
@export var anim_run_atk: StringName
@export var hitbox: Hitbox

func _ready():
    hitbox.register(self)
