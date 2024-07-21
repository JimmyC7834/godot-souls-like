extends Node

class_name PlayerHurtDetector

@onready var body_hurtboxes: Array[Area3D] = [
    $"../Armature_002/Skeleton3D/HurtboxBody1/Area3D",
    $"../Armature_002/Skeleton3D/HurtboxBody2/Area3D"
]

@onready var limbs_hurtboxes: Array[Area3D] = [
    $"../Armature_002/Skeleton3D/HurtboxLegUpL/Area3D",
    $"../Armature_002/Skeleton3D/HurtboxLegL/Area3D",
    $"../Armature_002/Skeleton3D/HurtboxLegUpR/Area3D",
    $"../Armature_002/Skeleton3D/HurtboxLegR/Area3D",
    $"../Armature_002/Skeleton3D/HurtBoxArmUpL/Area3D",
    $"../Armature_002/Skeleton3D/HurtBoxArmL/Area3D",
    $"../Armature_002/Skeleton3D/HurtBoxArmUpR/Area3D",
    $"../Armature_002/Skeleton3D/HurtBoxArmR/Area3D",
]

@onready var head_hurtboxes: Array[Area3D] = [
    $"../Armature_002/Skeleton3D/HurtboxHead/Area3D"
]

enum TYPE {
    HEAD,
    BODY,
    LIMBS
}
 
@export var player: Node3D

var hit_count: int = 0

signal on_head_enter(area: Area3D)
signal on_body_enter(area: Area3D)
signal on_limbs_enter(area: Area3D)
signal on_area_enter(area: Area3D, type: TYPE)

func _ready():
    for a in head_hurtboxes:
        a.area_entered.connect(fire_signal.bind(TYPE.HEAD, on_head_enter))
        a.area_exited.connect(remove_hit_area.bind(TYPE.HEAD))
    for a in body_hurtboxes:
        a.area_entered.connect(fire_signal.bind(TYPE.BODY, on_body_enter))
        a.area_exited.connect(remove_hit_area.bind(TYPE.BODY))
    for a in limbs_hurtboxes:
        a.area_entered.connect(fire_signal.bind(TYPE.LIMBS, on_limbs_enter))
        a.area_exited.connect(remove_hit_area.bind(TYPE.LIMBS))

func fire_signal(a: Area3D, type: TYPE, s: Signal):
    if player.tae.is_event_active(TimeActEvents.TAE.INVINCIBLE): return
    if a is Equipment and a.equipper == player: return

    if hit_count == 0:
        s.emit(a)
        on_area_enter.emit(a, type)
        print(TYPE.keys()[type] + " hit")
    
    hit_count += 1

func remove_hit_area(a: Area3D, type: TYPE):
    if a is Equipment and a.equipper == player: return
    hit_count -= 1
