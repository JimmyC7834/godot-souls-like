class_name Inventory

var slots = {}

var items: Array[Item] = []
var item_idx: int = 0

func _init():
    var item = load("res://items/hp_potion.tres") as Consumable
    add_item(item, 1)
    equip_item(item)

func equip_item(item: Consumable):
    items.append(item)

func get_current_item() -> Consumable:
    if items.is_empty(): return null
    if not items[item_idx] in slots.keys(): return null
    if slots[items[item_idx]].count == 0: return null
    return items[item_idx]

func consume_item(item: Consumable):
    if items.is_empty(): return
    if not item in slots.keys(): return
    if slots[item].count == 0: return
    slots[item].count -= 1

func move_item_idx(diff: int):
    item_idx = (item_idx + diff) % item_idx

func add_item(item: Item, count: int):
    if not item in slots.keys():
        slots[item] = InventorySlot.new()
        slots[item].item = item
    slots[item].count += count

func get_slot(item: Item) -> InventorySlot:
    if not item in slots.keys():
        return null
    return slots[item]
