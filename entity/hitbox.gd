extends Area3D

class_name Hitbox

var source
var damage: Damage
var atk_info: AttackInfo
var hitted: Array[GameEntity] = []
var disabled: bool = false:
    set(v):
        monitoring = !v
        disabled = v
        hitted.clear()

func register(obj: Object):
    source = obj
    set_collision_layer_value(Global.HITBOX_LAYER, true)
    set_collision_mask_value(Global.HURTBOX_LAYER, true)
    monitorable = false
    monitoring = true
    area_entered.connect(handle_on_hit)

func enable(_damage: Damage, _atk_info: AttackInfo):
    disabled = false
    damage = _damage
    atk_info = _atk_info

func disable():
    disabled = true

func handle_on_hit(a: Area3D):
    if not a is Hurtbox: return
    if a.entity in hitted: return
    if source != null and a.entity == source: return
    if a.entity.eventa(TimeActEvents.TAE.INVINCIBLE): return
    
    # set target hitted
    print(name + " hitted " + a.name)
    a.hit(self, atk_info)

    hitted.append(a.entity)
