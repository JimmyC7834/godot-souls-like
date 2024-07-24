extends GameEntity

# === States ===
var S_IDLE: State = State.new(
    "IDLE",
    func ():
        animation_tree.set(movement_path("Idle"), true)
        tae.set_event(1),        
    func (delta):
        var input_dir = get_3d_direction()
        if input_dir.length() > 0:
            sm.enter_state(S_WALKING)
            return
        
        fetch_input_cancel()
            ,
    func ():
        animation_tree.set(movement_path("Idle"), false),
)

var S_WALKING: State = State.new(
    "WALKING",
    func ():
        animation_tree.set(movement_path("Walking/blend_position"), Vector2(0, 1))
        animation_tree.set(movement_path("Walking"), true)
        
        tae.set_event(1)
        tae.set_event(4),
    func (delta):
        var input_dir = get_3d_direction()
        
        if input_dir.length() == 0:
            sm.enter_state(S_IDLE)
            return
 
        fetch_input_cancel()
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
        fetch_input_cancel()
        ,
    func ():
        animation_tree.set(movement_path("Running"), false)
        velocity = Vector3.ZERO,
)

var _S_ANIM: State = State.new(
    "ANIM",
    func ():
        tae.clear_all_event(),
    func (delta):
        var action: InputActionBuffer.ACTION = input_action_buffer.get_first_valid_action()
        # check for animation cancels
        if action == InputActionBuffer.ACTION.R_ATK_L:
            # cancel into the next animation by reading event args
            if !tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0] or !tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1]:
                    return
            request_one_shot(
                tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0],
                tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1])
        ,
    EMPTY_FUNC,
)

func _ready():
    S_ANIM = _S_ANIM
    super._ready()
    
    sm.cur = S_IDLE
    sm.enter_state(S_IDLE)
    
    player_hurt_detector.on_hit.connect(
        func (a, t):
            if a is Weapon and eventa(TimeActEvents.TAE.STANDBREAK):
                if a.equipper is PlayerController:
                    a.equipper.request_crit_atk()
                    return
            one_shot_interupt()
            request_one_shot("ImpactHead"))
    
    timer_action(InputActionBuffer.ACTION.R_ATK_L, 2)
    
    # reset state after animation chain is finished
    animation_tree.animation_finished.connect(func (a):
        if a == last_anim:
            sm.enter_state(S_IDLE))

func fetch_input_cancel():
    var input_action = input_action_buffer.get_first_valid_action()
    if input_action == InputActionBuffer.ACTION.R_ATK_L:
        var r = equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND)
        if r is Weapon:
            request_one_shot(r.anim_light_atk)
        return
    
    if input_action == InputActionBuffer.ACTION.ROLL:
        request_one_shot("Sprinting Forward Roll")
        return

func parried():
    one_shot_interupt()
    tae.set_event(TimeActEvents.TAE.STANDBREAK)
    request_one_shot("ImpactHead", 0, 0.25)

func get_3d_direction() -> Vector3:
    return Vector3.ZERO

func timer_action(action: InputActionBuffer.ACTION, sec: float):
    await get_tree().create_timer(sec).timeout
    input_action_buffer.queue.append([1, action])
    timer_action(action, sec)
