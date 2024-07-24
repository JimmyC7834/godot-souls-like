extends EntityComponent

class_name ParryStandBreak

@export var standbreak_anim: StringName
@export var seek: float = 0.0
@export var scale: float = 1.0

func is_parried_by(e: GameEntity):
    return e.eventa(TimeActEvents.TAE.PARRYING)

func parried_behaviour():
    if !entity.animation_player.has_animation(standbreak_anim):
        push_warning("Missing parry standbreak anim at " + str(self))
        return

    entity.one_shot_interupt()
    entity.request_one_shot(standbreak_anim, seek, scale)

static func type() -> String:
    return "ParryStandBreak"
