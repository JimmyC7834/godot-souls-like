extends Resource

class_name InputActionAnimCancel

@export var anim_name: StringName
@export var action: PlayerInputController.ACTION = PlayerInputController.ACTION.N
@export var condition: Condition

## Higher number means higher piority
@export var piority: int = 0

func cancellable(entity: GameEntity):
    if condition:
        return condition.is_true(entity)
    return true
