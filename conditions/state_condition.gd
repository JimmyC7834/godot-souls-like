extends Condition

class_name StateCondition

@export var state: State.Type

func evaluate(entity: GameEntity):
    return super.evaluate(entity) and state == entity.sm.cur.type
