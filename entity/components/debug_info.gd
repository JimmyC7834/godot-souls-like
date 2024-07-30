extends EntityComponent

class_name DebugInfo
static func type() -> String:
    return "DebugInfo"

func _ready():
    on_entity_changed.connect(
        func ():
            entity.mouse_entered.connect(
                func():
                    Global.debug_entity = entity)

            #entity.mouse_exited.connect(
                #func():
                    #if Global.debug_entity == entity:
                        #Global.debug_entity = null)
    )
