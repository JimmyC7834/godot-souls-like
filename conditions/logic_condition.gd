extends Condition

class_name LogicCondition

@export var a: Condition
@export_enum("AND", "OR") var type
@export var b: Condition

func evaluate(entity: GameEntity):
    match type:
        "AND":
            return a.evaluate(entity) and b.evaluate(entity)
        "OR":
            return a.evaluate(entity) or b.evaluate(entity)
