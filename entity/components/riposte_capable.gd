extends AnimEntityComponent

class_name RiposteCapable
static func type() -> String:
    return "RiposteCapable"

func riposte(ripostable: Ripostable):
    entity.global_position = ripostable.riposte_point.global_position
    entity.rotation.y = ripostable.riposte_point.global_rotation.y
    fire_anim()
