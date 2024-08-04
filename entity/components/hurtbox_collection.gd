extends EntityComponent

class_name HurtboxCollection

@export var hurtboxes: Array[Area3D] = []

var hit_counts = {}
var hit_count: int = 0

signal on_hit(hitbox: Hitbox, hurtbox: Hurtbox, atk_info: AttackInfo)

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

func hit(hitbox: Hitbox, atk_info: AttackInfo, hurtbox: Hurtbox):
    if hitbox.source is Weapon and hitbox.source.equipper == entity: return
    on_hit.emit(hitbox, hurtbox, atk_info)

static func type() -> String:
    return "HurtboxCollection"
