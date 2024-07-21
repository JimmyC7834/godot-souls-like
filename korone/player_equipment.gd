extends Node

class_name PlayerEquipment

enum SLOT {
    LEFT_HAND = 0,
    RIGHT_HAND = 1
}

@export var player: Node3D
var left_hand: Equipment = null
var right_hand: Equipment = null

var equipments = {
    SLOT.LEFT_HAND: null,
    SLOT.RIGHT_HAND: null
}

@onready var slot_map = {
    SLOT.RIGHT_HAND: $"../Armature_002/Skeleton3D/RightHand",
}

const SWORD = preload("res://Equipments/sword.tscn")

func _ready():
    var s = SWORD.instantiate()
    equip(s, SLOT.RIGHT_HAND)

func equip(e: Equipment, slot: SLOT):
    if equipments[slot] == e: return
    
    e.equipper = player
    if equipments[slot] != null:
        slot_map[slot].get_child(0).queue_free()
    equipments[slot] = e
    slot_map[slot].add_child(equipments[slot])
    equipments[slot].reparent(slot_map[slot], false)

func get_equipment(slot: SLOT) -> Equipment:
    return equipments[slot]

func is_slot_empty(slot: SLOT) -> bool:
    return get_equipment(slot) == null
