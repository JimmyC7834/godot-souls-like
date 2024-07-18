extends Node3D

@onready var sword: Node3D = $Sword

@export var omega: float = 1.0

func _physics_process(delta):
    sword.rotate_y(omega * delta)
