extends CharacterBody3D

class_name GameEntity

# === CONST ===
var G: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var EMPTY_FUNC: Callable = func(): pass
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const DIR_FOLLOW_VELOCITY: float = 10.0
const ANIM_TREE_MOVEMENT_PATH: String = "parameters/Movement/conditions/"

# === Nodes ===
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var right_hand: BoneAttachment3D = $Armature_002/Skeleton3D/RightHand
@onready var tae: TimeActEvents = $TAE
@onready var input_action_buffer: InputActionBuffer = $InputActionBuffer
@onready var player_hurt_detector: HurtboxCollection = $PlayerHurtDetector
@onready var equipment: PlayerEquipment = $PlayerEquipment

var components = {}

# === Variables ===
var facing_dir: Vector3
var is_oneshot_1: bool = true
var last_anim: StringName

# === States ===
var S_ANIM: State

var sm: State.StateMachine = State.StateMachine.new()

func _ready():
    for c in get_children(true):
        if c is EntityComponent:
            components[c.type()] = c
            c.entity = self
            
    animation_tree.set(movement_path("Walking"), false)
    animation_tree.set(movement_path("Running"), false)

func _physics_process(delta):
    update_facing_dir()
    follow_facing_dir(delta)
    sm.update(delta)
    update_velocity(delta)
    apply_gravity(delta)
    move_and_slide()

func update_velocity(delta, include_y: bool = false):
    # apply root motion velocity
    var currentRotation = transform.basis.get_rotation_quaternion()
    var v: Vector3 = (currentRotation.normalized() * animation_tree.get_root_motion_position()) / delta
    if include_y:
        velocity = v
    else:
        velocity.x = v.x
        velocity.z = v.z

func apply_gravity(delta):
    if eventa(TimeActEvents.TAE.DISABLE_GRAVITY): return    
    
    if not is_on_floor():
        velocity.y -= G * delta

func follow_facing_dir(delta):
    if eventa(TimeActEvents.TAE.DISABLE_TURN): return
    
    # turning the character to the input/facing direction
    if facing_dir != Vector3.ZERO:
        var angle = atan2(-facing_dir.x, -facing_dir.z)
        rotation.y = lerp_angle(rotation.y, angle, delta * DIR_FOLLOW_VELOCITY)

func update_facing_dir():
    var direction: Vector3 = get_3d_direction()
    facing_dir = direction.normalized()

# initiate an one shot animation and enter aniamtion state
func request_one_shot(anim_name: StringName, seek: float = -1.0, scale: float = 1.0):
    print("fire one shot " + anim_name)
    tae.clear_all_event()
    fire_oneshot(is_oneshot_1, anim_name, seek, scale)
    is_oneshot_1 = !is_oneshot_1
    last_anim = anim_name
    sm.enter_state(S_ANIM)

# fires one host animation with alternating nodes to apply animation blending
func fire_oneshot(first: bool, anim_name: String, seek: float = -1.0, scale: float = 1.0):
    var idx: int = 1 if first else 2
    animation_tree.tree_root.get_node("ONESHOT_ANIM_%d" % idx).animation = anim_name
    animation_tree.set("parameters/ONESHOT_SEEK_%d/seek_request" % idx, seek)
    animation_tree.set("parameters/ONESHOT_SCALE_%d/scale" % idx, scale)
    animation_tree.set("parameters/ONESHOT_%d/request" % idx, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func one_shot_interupt():
    var idx: int = 1 if !is_oneshot_1 else 2
    animation_tree.set("parameters/ONESHOT_%d/request" % idx, AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func get_component(t):
    if not components.has(t): return null
    return components[t]

func parried():
    pass

func is_state(name: String):
    return sm.cur.name == name

func eventa(e: TimeActEvents.TAE):
    return tae.is_event_active(e)

func movement_path(str: String):
    return ANIM_TREE_MOVEMENT_PATH + str

func get_3d_direction() -> Vector3:
    return Vector3.ZERO
