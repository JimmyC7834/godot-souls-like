extends AnimEntityComponent

class_name Backstabbable
static func type() -> String:
    return "Backstabbable"

func backstab(damage: Damage):
    fire_anim()
    print(damage)
    await get_tree().create_timer(1).timeout
    entity.one_shot_interupt()
    entity.request_one_shot("LM2/Fall_Forward")
    
