extends Condition

class_name EventCondition

@export var events: Array[TimeActEvents.TAE] = []

func evaluate(entity: GameEntity):
    for e in events:
        if not entity.eventa(e):
            return not super.evaluate(entity)
    return super.evaluate(entity)
