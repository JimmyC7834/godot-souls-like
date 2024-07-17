extends Node3D
@onready var h = $h
@onready var v = $h/v

var camroot_h: float = 0
var camroot_v: float = 0
@export var cam_v_max: float = 50
@export var cam_v_min: float = -75
@export var follow_speed: float = 15.0
var h_sensitivity: float = 0.005
var v_sensitivity: float = 0.005
var h_acceleration: float = 10.0
var v_acceleration: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
    if event is InputEventMouseMotion:
        camroot_h -= event.relative.x * h_sensitivity
        camroot_v -= event.relative.y * v_sensitivity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    camroot_v= clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
    h.rotation.y = lerpf(h.rotation.y, camroot_h, h_acceleration * delta)
    v.rotation.x = lerpf(v.rotation.x, camroot_v, v_acceleration * delta)

    global_position = lerp(global_position, 
                            (get_tree().get_first_node_in_group("Player") as Node3D).global_position,
                            follow_speed * delta)
