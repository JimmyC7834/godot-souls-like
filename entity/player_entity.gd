extends GameEntity

class_name PlayerEntity

const RUNNING_STANIMA_COST: float = 10
const STANIMA_RECOVERY: float = 25

@onready var camera: PlayerCamera = $"../Camera"
@onready var cam_h: Node3D = $"../Camera/h"

@export var attributes_preset: AttributePreset
var attributes: Attributes
var inventory: Inventory = Inventory.new()

var blend_position: Vector2 = Vector2(0, 1)

# === States ===
var _S_IDLE: State = State.new(
    "IDLE",
    func ():
        animation_tree.set("parameters/Movement/conditions/Idle", true)
        tae.clear_all_event()
        tae.set_event(1),        
    func (delta):
        stanima_recovery(delta)
        
        if dir_3d.length() > 0:
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

        stanima_recovery(delta)

        if dir_3d.length() == 0:
            sm.enter_state(S_IDLE)
            return
 
        if peek_action() == PlayerInputController.ACTION.RUN and \
            general_stats.stamina > 0:
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

        general_stats.stamina -= RUNNING_STANIMA_COST * delta

        if general_stats.stamina <= 0 or \
            peek_action() == PlayerInputController.ACTION.STOP_RUN:
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
        fetch_action_cancel()
        
        var a = get_component(AttackBehaviour.type()) as AttackBehaviour
        a.attack_behaviour_check()
        ,
    EMPTY_FUNC,
)

func _ready():
    S_IDLE = _S_IDLE
    S_ANIM = _S_ANIM
    super._ready()
    
    attributes = attributes_preset.get_attributes()
    general_stats = GeneralStats.from_attributes(attributes)
    
    var h: HurtboxCollection = get_component(HurtboxCollection.type())
    if h: h.on_hit.connect(handle_on_hit)
    
    if is_in_group("Player"):
        Player.player = self

func update_facing_dir(delta):
    if camera.lock_on:
        facing_dir = -global_position.direction_to(camera.lock_on.global_position)
    else:
        var h_rot = cam_h.global_transform.basis.get_euler().y
        var direction: Vector3 = dir_3d
        if dir_3d == Vector3.ZERO: return
        facing_dir = direction.rotated(Vector3.UP, h_rot).normalized()

func handle_on_hit(hitbox: Hitbox, hurtbox: Hurtbox, atk_value: AttackValue):
    if hitbox.source is Weapon:
        if eventa(TimeActEvents.TAE.STANDBREAK) and hitbox.source.equipper is PlayerEntity:
            hitbox.source.equipper.request_crit_atk()
            return
        
        damage(hitbox.source.get_damage(attributes))
        one_shot_interupt()
        if atk_value.impact_rank == Damage.IMPACT.HIGH:
            var angle: float = facing_dir.angle_to(hitbox.source.equipper.facing_dir)
            if angle > PI / 2:
                request_one_shot("LM2/Fall_Backward")
            else:
                request_one_shot("LM2/Fall_Forward")
                
        else:
            request_one_shot("ImpactHead")

func fetch_action_cancel():
    var action = fetch_action()

    match action:
        PlayerInputController.ACTION.R_ATK_L when general_stats.stamina > 0:
            var r = equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND)
            if r is Weapon:
                one_shot_interupt()
                
                if is_state("ANIM"):
                    if !tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0] or !tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1]:
                        return
                    request_one_shot(
                        tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[0],
                        tae.get_event_args(TimeActEvents.TAE.RH_ATK_ANIM_CANCEL)[1])
                else:
                    request_one_shot(r.anim_light_atk)
                
                general_stats.stamina -= r.light_atk_stamina_cost
    
        PlayerInputController.ACTION.R_ATK_H when general_stats.stamina > 0:
            var r = equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND)
            if r is Weapon:
                one_shot_interupt()
                request_one_shot(r.anim_heavy_atk, 0.1, 1.0)
                general_stats.stamina -= r.heavy_atk_stamina_cost
    
        PlayerInputController.ACTION.ROLL when general_stats.stamina > 0:
            one_shot_interupt()
            general_stats.stamina -= 20.0
            
            var h_rot = cam_h.global_transform.basis.get_euler().y
            var dir: Vector3 = dir_3d.rotated(Vector3.UP, h_rot).normalized()
            var angle: float = atan2(-dir.x, -dir.z)
            rotation.y = angle
            request_one_shot("PC/Roll", -1.0, 1.5)

        PlayerInputController.ACTION.ITEM_USE:
            one_shot_interupt()
            var item: Consumable = inventory.get_current_item()
            if item:
                request_one_shot(item.use_anim, -1.0, 0.75, func ():
                    item.used_by(self)
                    inventory.consume_item(item))
            
        PlayerInputController.ACTION.N:
            pass
        _:
            pass

func stanima_recovery(delta):
    general_stats.stamina += STANIMA_RECOVERY * delta
