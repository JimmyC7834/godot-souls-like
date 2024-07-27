extends GameEntity

class_name PlayerEntity

@onready var camera: PlayerCamera = $"../Camera"
@onready var cam_h: Node3D = $"../Camera/h"

var blend_position: Vector2 = Vector2(0, 1)

# === States ===
var _S_IDLE: State = State.new(
    "IDLE",
    func ():
        animation_tree.set("parameters/Movement/conditions/Idle", true)
        tae.clear_all_event()
        tae.set_event(1),        
    func (delta):
        var input_dir = dir_3d
        if input_dir.length() > 0:
            sm.enter_state(S_WALKING)
            return
        
        fetch_action_cancel()
            ,
    func ():
        animation_tree.set("parameters/Movement/conditions/Idle", false),
)

var S_WALKING: State = State.new(
    "WALKING",
    func ():
        animation_tree.set("parameters/Movement/conditions/Walking", true)

        tae.clear_all_event()        
        tae.set_event(1)
        tae.set_event(4),
    func (delta):
        var b_pos: Vector2 = animation_tree.get("parameters/Movement/Walking/blend_position")
        animation_tree.set("parameters/Movement/Walking/blend_position",
                            lerp(b_pos, blend_position, DIR_FOLLOW_VELOCITY * delta))

        var input_dir = dir_3d
        
        if input_dir.length() == 0:
            sm.enter_state(S_IDLE)
            return
 
        if peek_action() == PlayerInputController.ACTION.RUN:
            sm.enter_state(S_RUNNING)
            return

        fetch_action_cancel()
            ,
    func ():
        animation_tree.set("parameters/Movement/conditions/Walking", false)
        velocity = Vector3.ZERO,
)

var S_RUNNING: State = State.new(
    "RUNNING",
    func ():
        animation_tree.set("parameters/Movement/conditions/Running", true)
        tae.clear_all_event(),
    func (delta):
        var b_pos: Vector2 = animation_tree.get("parameters/Movement/Running/blend_position")
        animation_tree.set("parameters/Movement/Running/blend_position",
                            lerp(b_pos, blend_position, DIR_FOLLOW_VELOCITY * delta))

        if peek_action() == PlayerInputController.ACTION.STOP_RUN:
            sm.enter_state(S_WALKING)
            return
        
        fetch_action_cancel()
            ,
    func ():
        animation_tree.set("parameters/Movement/conditions/Running", false)
        velocity = Vector3.ZERO,
)

var _S_ANIM: State = State.new(
    "ANIM",
    func ():
        tae.clear_all_event(),
    func (delta):
        var action: PlayerInputController.ACTION = fetch_action()
        # check for animation cancels
        if action == PlayerInputController.ACTION.R_ATK_L:
            # cancel into the next animation by reading event args
            if !tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0] or !tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1]:
                    return
            request_one_shot(
                tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0],
                tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1])
        
        var a = get_component(AttackBehaviour.type()) as AttackBehaviour
        a.attack_behaviour_check()
        ,
    EMPTY_FUNC,
)

func _ready():
    S_IDLE = _S_IDLE
    S_ANIM = _S_ANIM
    super._ready()
    
    sm.cur = S_IDLE
    sm.enter_state(S_IDLE)
    
    var h: HurtboxCollection = get_component(HurtboxCollection.type())
    if h:
        h.on_hit.connect(
            func (hitbox: Hitbox, hurtbox: Hurtbox):
                if hitbox.source is Weapon and eventa(TimeActEvents.TAE.STANDBREAK):
                    if hitbox.source.equipper is PlayerEntity:
                        hitbox.source.equipper.request_crit_atk()
                        return
                one_shot_interupt()
                request_one_shot("ImpactHead"))

func update_facing_dir():
    if camera.lock_on:
        facing_dir = -global_position.direction_to(camera.lock_on.global_position)
    else:
        var h_rot = cam_h.global_transform.basis.get_euler().y
        var direction: Vector3 = dir_3d
        facing_dir = direction.rotated(Vector3.UP, h_rot).normalized()

func fetch_action_cancel():
    var action = fetch_action()
    match action:
        PlayerInputController.ACTION.R_ATK_L:
            var r = equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND)
            if r is Weapon:
                request_one_shot(r.anim_light_atk)
    
        PlayerInputController.ACTION.R_ATK_H:
            var r = equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND)
            if r is Weapon:
                request_one_shot(r.anim_heavy_atk, 0.1, 1.0)
    
        PlayerInputController.ACTION.ROLL:
            var h_rot = cam_h.global_transform.basis.get_euler().y
            var dir: Vector3 = dir_3d.rotated(Vector3.UP, h_rot).normalized()
            var angle: float = atan2(-dir.x, -dir.z)
            rotation.y = angle
            call_deferred("request_one_shot", "PC/Roll", -1.0, 1.5)
            #request_one_shot("PC/Roll", -1.0, 1.5)

        PlayerInputController.ACTION.N:
            pass
        _:
            push_warning("fetched unknown ACTION " + str(action))

func request_crit_atk():
    one_shot_interupt()
    request_one_shot("PC/Crit")
