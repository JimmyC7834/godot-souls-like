extends Equipment

class_name Weapon

@export var moveset: WeaponMoveset
@export var anim_light_atk: StringName
@export var light_atk_stamina_cost: float
@export var anim_heavy_atk: StringName
@export var heavy_atk_stamina_cost: float
@export var anim_run_atk: StringName
@export var hitbox: Hitbox

@export var scalers: Array[DamageScaler] = []
@export var poise_damage: float = 10.0

func _ready():
    hitbox.register(self)

func get_damage(attributes: Attributes) -> Damage:
    var damage: Damage = Damage.new(self)
    for scaler: DamageScaler in scalers:
        if !scaler.damage_type in damage.values.keys():
            damage.values[scaler.damage_type] = 0
        damage.values[scaler.damage_type] += scaler.get_damage(
            attributes.get_attribute(scaler.scaling_attribute))

    return damage
