extends CharacterBody3D


var G: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var EMPTY_FUNC: Callable = func(): pass
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const DIR_FOLLOW_VELOCITY: float = 10.0
const ANIM_TREE_MOVEMENT_PATH: String = "parameters/Movement/conditions/"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var right_hand: BoneAttachment3D = $Armature_002/Skeleton3D/RightHand
@onready var tae: TimeActEvents = $TAE
@onready var input_action_buffer: InputActionBuffer = $InputActionBuffer

var run_timer: float = 0.25
var facing_dir: Vector3
var is_oneshot_1: bool = true
var last_anim: StringName

var S_IDLE: State = State.new(
    "IDLE",
    func ():
        animation_tree.set(movement_path("Idle"), true),
    func (delta):
        var input_dir = get_input_direction()
        if input_dir.length() > 0:
            sm.enter_state(S_WALKING)
            return
            
            ,
    func ():
        animation_tree.set(movement_path("Idle"), false),
)

var S_WALKING: State = State.new(
    "WALKING",
    func ():
        animation_tree.set(movement_path("Walking/blend_position"), Vector2(0, 1))
        animation_tree.set(movement_path("Walking"), true),
    func (delta):
        var input_dir = get_input_direction()
        
        if input_dir.length() == 0:
            sm.enter_state(S_IDLE)
            return
        
        if Input.is_action_pressed("ROLL"):
            run_timer -= delta
            if run_timer < 0:
                animation_tree.set(movement_path("Running"), true)
                sm.enter_state(S_RUNNING)
                return
        
        if Input.is_action_just_released("ROLL"):
            run_timer = 0.25
            if run_timer > 0:
                request_one_shot("Sprinting Forward Roll")
                return
                
        if Input.is_action_just_pressed("R1"):
            var obj = right_hand.get_child(0)
            if obj is Weapon:
                request_one_shot(obj.anim_light_atk)
            return
            ,
    func ():
        animation_tree.set(movement_path("Walking"), false)
        velocity = Vector3.ZERO,
)

var S_RUNNING: State = State.new(
    "RUNNING",
    func ():
        animation_tree.set(movement_path("Running/blend_position"), Vector2(0, 1))
        animation_tree.set(movement_path("Running"), true),
    func (delta):
        var input_dir = get_input_direction()
        
        if Input.is_action_just_released("ROLL"):
            sm.enter_state(S_WALKING)
            return
        
        if Input.is_action_just_pressed("R1"):
            var obj = right_hand.get_child(0)
            if obj is Weapon:
                request_one_shot(obj.anim_run_atk)
                return
            ,
    func ():
        animation_tree.set(movement_path("Running"), false)
        run_timer = 0.25
        velocity = Vector3.ZERO,
)

var S_ANIM: State = State.new(
    "ANIM",
    func ():
        tae.clear_all_event(),
    func (delta):
        var action: InputActionBuffer.ACTION = input_action_buffer.get_first_valid_action()
        if action == InputActionBuffer.ACTION.R_ATK_L:
            request_one_shot(
                tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0],
                tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1])
        ,
    EMPTY_FUNC,
)

var sm: State.StateMachine = State.StateMachine.new()

func _ready():
    animation_tree.set(movement_path("Walking"), false)
    animation_tree.set(movement_path("Running"), false)
    
    sm.cur = S_IDLE
    sm.enter_state(S_IDLE)
    animation_tree.animation_finished.connect(func (a):
        if a == last_anim:
            sm.enter_state(S_IDLE))

func _physics_process(delta):
    update_facing_dir()
    follow_facing_dir(delta)
    sm.update(delta)
    update_velocity(delta)
    apply_gravity(delta)
    move_and_slide()

func update_velocity(delta, include_y: bool = false):
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
    
    if facing_dir != Vector3.ZERO:
        var angle = atan2(-facing_dir.x, -facing_dir.z)
        rotation.y = lerp_angle(rotation.y, angle, delta * DIR_FOLLOW_VELOCITY)

func update_facing_dir():
    var h_rot = $"../Camera/h".global_transform.basis.get_euler().y
    var direction: Vector3 = get_3d_input_direction()
    
    facing_dir = direction.rotated(Vector3.UP, h_rot).normalized()

func request_one_shot(anim_name: StringName, seek: float = -1.0, scale: float = 1.0):
    print("fire one shot " + anim_name)
    fire_oneshot(is_oneshot_1, anim_name, seek, scale)
    is_oneshot_1 = !is_oneshot_1
    last_anim = anim_name
    sm.enter_state(S_ANIM)

func fire_oneshot(first: bool, anim_name: String, seek: float = -1.0, scale: float = 1.0):
    var idx: int = 1 if first else 2
    animation_tree.tree_root.get_node("ONESHOT_ANIM_%d" % idx).animation = anim_name
    animation_tree.set("parameters/ONESHOT_SEEK_%d/seek_request" % idx, seek)
    animation_tree.set("parameters/ONESHOT_SCALE_%d/scale" % idx, scale)
    animation_tree.set("parameters/ONESHOT_%d/request" % idx, true)

func eventa(e: TimeActEvents.TAE):
    return tae.is_event_active(e)

func movement_path(str: String):
    return ANIM_TREE_MOVEMENT_PATH + str

func get_input_direction() -> Vector2:
    return Vector2(Input.get_action_strength("MOVE_LEFT") - Input.get_action_strength("MOVE_RIGHT"), 
                    Input.get_action_strength("MOVE_FORWARD") - Input.get_action_strength("MOVE_BACKWARD"))

func get_3d_input_direction() -> Vector3:
    return Vector3(Input.get_action_strength("MOVE_LEFT") - Input.get_action_strength("MOVE_RIGHT"), 
                    0, 
                    Input.get_action_strength("MOVE_FORWARD") - Input.get_action_strength("MOVE_BACKWARD"))
