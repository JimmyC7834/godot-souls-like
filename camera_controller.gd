extends Node3D

class_name PlayerCamera

@onready var h = $h
@onready var v = $h/v
@onready var lock_on_area: Area3D = $h/v/Camera3D/Area3D

var lock_on: Node3D
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
    if event is InputEventMouseMotion and !lock_on:
        camroot_h -= event.relative.x * h_sensitivity
        camroot_v -= event.relative.y * v_sensitivity
    
    if Input.is_action_just_pressed("DEBUG_SHOW_MOUSE"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    elif Input.is_action_just_released("DEBUG_SHOW_MOUSE"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    
    if Input.is_action_just_pressed("LOCK_ON"):
        if lock_on:
            lock_on = null
            return
        
        var bodies: Array = lock_on_area.get_overlapping_bodies().filter(func (x): return x is GameEntity and !x.is_in_group("Player"))
        if bodies.is_empty(): return
        
        lock_on = bodies.reduce(func (x: Node3D, acc: Node3D):
            return x if acc.global_position.distance_to(global_position) < x.global_position.distance_to(global_position) \
                    else acc)
        
        print("lock on", str(lock_on))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE: return
    
    if lock_on:
        #camroot_v = global_position.angle_to(lock_on.global_position)
        h.rotation.y = 0
        v.rotation.x = -0.5
        look_at(lock_on.global_position)
    else:
        camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
        h.rotation.y = lerpf(h.rotation.y, camroot_h, h_acceleration * delta)
        v.rotation.x = lerpf(v.rotation.x, camroot_v, v_acceleration * delta)

    global_position = lerp(global_position, 
                            (get_tree().get_first_node_in_group("Player") as Node3D).global_position,
                            follow_speed * delta)
