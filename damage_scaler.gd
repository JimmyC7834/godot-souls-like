extends Resource

class_name DamageScaler

@export var damage_type: Damage.TYPE = Damage.TYPE.PHY
@export var base: int = 0

@export var scaling_attribute: Attributes.TYPE = Attributes.TYPE.STR
@export_range(0.0, 2.0) var scaling: float = 0.0

func get_damage(stat_value: int) -> float:
    return base + scaling * stat_value

#@export_category("BASE")
#@export var base_phy: int
#@export var base_wave: int
#@export var base_fire: int
#@export var base_ice: int
#@export var base_lighting: int
#@export var base_magic: int
#
#@export_category("SCALING")
#@export var scaling_str: Damage.SCALING
#@export var scaling_dex: Damage.SCALING
#@export var scaling_men: Damage.SCALING
#@export var scaling_wil: Damage.SCALING
#
#var base_values = {}
#var scalings = {}
    
