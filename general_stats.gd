class_name GeneralStats

@export var hp: float
@export var stamina: float
@export var equip_load: float
@export var poise: float = 0
@export var skill_slots: int = 1

static func from_attributes(a: Attributes) -> GeneralStats:
    var s: GeneralStats = GeneralStats.new()
    s.hp = 30 * default_scale(a.get_attribute(Attributes.TYPE.DUR))
    s.stamina = 30 * default_scale(a.get_attribute(Attributes.TYPE.STA))
    s.equip_load = 4 * default_scale(a.get_attribute(Attributes.TYPE.STA))
    return s

static func default_scale(point: int):
    return (100 + point) * point / 200
