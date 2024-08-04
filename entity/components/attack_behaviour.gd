extends EntityComponent

class_name AttackBehaviour
static func type() -> String:
    return "AttackBehaviour"

func _entity_ready():
    entity.tae.on_atk_behaviour_started.connect(start_attack)
    entity.tae.on_atk_behaviour_finished.connect(finish_attack)

func start_attack(e: TimeActEvents.TAE, atk_info: AttackInfo):
    if entity.eventa(TimeActEvents.TAE.R_ATK):
        enable_weapon_hitbox(
            entity.equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND),
            atk_info)
    elif entity.eventa(TimeActEvents.TAE.L_ATK):
        enable_weapon_hitbox(
            entity.equipment.get_equipment(PlayerEquipment.SLOT.LEFT_HAND),
            atk_info)

func finish_attack(e: TimeActEvents.TAE):
    if entity.eventa(TimeActEvents.TAE.R_ATK):
        disable_weapon_hitbox(
            entity.equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND))
    elif entity.eventa(TimeActEvents.TAE.L_ATK):
        disable_weapon_hitbox(
            entity.equipment.get_equipment(PlayerEquipment.SLOT.LEFT_HAND))

func enable_weapon_hitbox(w: Weapon, atk_info: AttackInfo):
    if entity is PlayerEntity:
        w.hitbox.enable(w.get_damage(entity.attributes), atk_info)

func disable_weapon_hitbox(w: Weapon):
    w.hitbox.disable()
