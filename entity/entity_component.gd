extends Node

class_name EntityComponent

var entity: GameEntity:
    set(v):
        entity = v
        on_entity_changed.emit()

signal on_entity_changed

static func type() -> String:
    return "EntityComponent"
