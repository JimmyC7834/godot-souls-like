extends Resource
class_name Condition

@export var invert: bool

func evaluate(entity: GameEntity):
    return !invert
