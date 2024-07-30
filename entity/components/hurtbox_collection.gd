extends EntityComponent

class_name HurtboxCollection

@export var hurtboxes: Array[Area3D] = []

var hit_counts = {}
var hit_count: int = 0

signal on_hit(hitbox: Hitbox, hurtbox: Hurtbox, atk_value: AttackValue)

func _ready():
    on_entity_changed.connect(
        func ():
            for a in hurtboxes:
                if a is Hurtbox:
                    a.register(entity)
                    a.on_hit.connect(hit.bind(a))
    )

func _process(delta):
    assert(hit_counts.values().all(func(x): return x >= 0), str(hit_counts.values()))

func hit(hitbox: Hitbox, atk_value: AttackValue, hurtbox: Hurtbox):
    if hitbox.source is Weapon and hitbox.source.equipper == entity: return
    on_hit.emit(hitbox, hurtbox, atk_value)

static func type() -> String:
    return "HurtboxCollection"

#func fire_signal(hitbox: Area3D, hurtbox: EntityHurtbox):
    #if player.tae.is_event_active(TimeActEvents.TAE.INVINCIBLE): return
    #if hitbox is EntityHitbox and hitbox.source is Weapon and hitbox.source.equipper == player: return
#
    #if not hitbox in hit_counts.keys():
        #hit_counts[hitbox] = 0
#
    #if hit_counts[hitbox] == 0:
        #on_area_enter.emit(hitbox, hurtbox)
    #
    #hit_counts[hitbox] += 1
#
#func remove_hit_area(hitbox: Area3D, hurtbox: EntityHurtbox):
    #if hitbox is EntityHitbox and hitbox.source is Weapon and hitbox.source.equipper == player: return
    #if not hitbox in hit_counts.keys():
        #hit_counts[hitbox] = 0
    #else:
        #hit_counts[hitbox] -= 1
