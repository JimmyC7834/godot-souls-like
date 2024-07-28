class_name GeneralStats

var max_hp: float
var max_stamina: float
@export var hp: float:
    set(v):
        if v > max_hp: return
        var diff: float = v - hp
        hp = v
        on_hp_changed.emit(diff)
        
@export var stamina: float:
    set(v):
        if v > max_stamina: return
        var diff: float = v - stamina
        stamina = v
        on_stamina_chanegd.emit(diff)
        
@export var equip_load: float
@export var poise: float = 0
@export var skill_slots: int = 1

signal on_hp_changed(diff: float)
signal on_stamina_chanegd(diff: float)

static func from_attributes(a: Attributes) -> GeneralStats:
    var s: GeneralStats = GeneralStats.new()
    s.max_hp = 30 * default_scale(a.get_attribute(Attributes.TYPE.DUR))
    s.max_stamina = 15 * default_scale(a.get_attribute(Attributes.TYPE.STA))
    
    s.hp = s.max_hp
    s.stamina = s.max_stamina
    s.equip_load = 4 * default_scale(a.get_attribute(Attributes.TYPE.STA))
    
    return s

static func default_scale(point: int):
    return (200 - point) * point / 200
