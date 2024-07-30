extends Item

class_name Consumable

@export var use_anim: StringName

signal on_used

func used_by(p: PlayerEntity):
    print("used item: ", display_name)
    on_used.emit()
