extends AnimEntityComponent

class_name ParryStandBreak

func is_parried_by(e: GameEntity):
    return e.eventa(TimeActEvents.TAE.PARRYING)

func parried_behaviour():
    entity.one_shot_interupt()
    entity.request_one_shot(anim, seek, scale)

static func type() -> String:
    return "ParryStandBreak"
