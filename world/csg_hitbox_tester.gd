extends CSGBox3D

@export var hitbox: Hitbox
@export var interval: float
@export var attack_info: AttackInfo
@export var color: Color

func _ready():
    material = material.duplicate(true)
    hitbox.register(null)
    
    var d = Damage.new()
    d.values = { Damage.TYPE.PHY: 50 }
    hitbox.enable(d, attack_info)
    update()

func update():
    await get_tree().create_timer(interval).timeout
    hitbox.disabled = !hitbox.disabled
    material.albedo_color = Color.WHEAT if hitbox.disabled else color
    update()
