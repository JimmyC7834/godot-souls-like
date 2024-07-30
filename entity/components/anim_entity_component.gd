extends EntityComponent

class_name AnimEntityComponent
static func type() -> String:
    push_error("AnimEntityComponent type not set")
    return "AnimEntityComponent"

@export var anim: StringName
@export var seek: float = -1.0
@export var scale: float = 1.0

func _ready():
    on_entity_changed.connect(anim_check, Object.CONNECT_ONE_SHOT)
    
func anim_check():
    if !entity.animation_player.has_animation(anim):
        push_error("Missing anim at ", type(), " in ", entity)

func fire_anim(interrupt: bool = true):
    if interrupt:
        entity.one_shot_interupt()
    entity.request_one_shot(anim, seek, scale)
