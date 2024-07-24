extends Node3D

class_name Equipment

var equipper: GameEntity:
    set(v):
        equipper = v
        on_equipper_changed.emit(v)

signal on_equipper_changed(e)
