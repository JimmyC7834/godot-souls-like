extends EntityComponent

class_name AttackBehaviour
static func type() -> String:
    return "AttackBehaviour"

func _physics_process(delta):
    if entity.is_state("ANIM"):
        attack_behaviour_check()

func attack_behaviour_check():
    if entity.eventa(TimeActEvents.TAE.R_ATK):
        attack_behaviour(TimeActEvents.TAE.R_ATK)
    
    if entity.eventa(TimeActEvents.TAE.L_ATK):
        attack_behaviour(TimeActEvents.TAE.L_ATK)
            
func attack_behaviour(e: TimeActEvents.TAE) -> Hurtbox:
    if not e in [TimeActEvents.TAE.L_ATK, TimeActEvents.TAE.R_ATK]: return
    
    var w: Weapon
    if e == TimeActEvents.TAE.L_ATK:
        w = entity.equipment.get_equipment(PlayerEquipment.SLOT.LEFT_HAND)
    else:
        w = entity.equipment.get_equipment(PlayerEquipment.SLOT.RIGHT_HAND)        
    
    var hits: Array[Area3D] = w.hitbox.get_overlapping_areas()
    var p: ParryStandBreak = entity.get_component(ParryStandBreak.type())
    
    for a in hits:
        var hitted = entity.tae.get_event_args(e)[0]
        if a in hitted: continue
        if not a is Hurtbox: continue
        if a.entity == entity: continue
        if a.entity.eventa(TimeActEvents.TAE.INVINCIBLE): continue
        
        var atk_value = entity.tae.get_event_args(e)[1]
        
        # set target hitted
        print(name + " hitted " + a.name)
        if p and p.is_parried_by(a.entity):
            p.parried_behaviour()
        else:
            a.hit(w.hitbox, atk_value)

        hitted.append(a.entity)
        entity.tae.event_args[e] = [hitted, atk_value, null]
        return a

    return null
