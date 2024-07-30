extends Control

const MAX_HP_BAR_LENGTH: float = 1250
const MAX_STAMINA_BAR_LENGTH: float = 750

@export var health_bar: ProgressBar
@export var stamina_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
    register()

func register():
    health_bar.custom_minimum_size.x = scaled_hp_bar_length()
    health_bar.max_value = Player.player.general_stats.hp
    health_bar.value = Player.player.general_stats.hp
    stamina_bar.custom_minimum_size.x = scaled_stamina_bar_length()
    stamina_bar.max_value = Player.player.general_stats.stamina
    stamina_bar.value = Player.player.general_stats.stamina
    
    Player.player.general_stats.on_hp_changed.connect(update_hp_bar)
    Player.player.general_stats.on_stamina_chanegd.connect(update_stamina_bar)

func scaled_hp_bar_length():
    return sqrt((Player.player.general_stats.max_hp - 150) / 2500 * 100) / 10 * MAX_HP_BAR_LENGTH

func scaled_stamina_bar_length():
    return sqrt((Player.player.general_stats.max_stamina - 50) / 2500 * 100) / 10 * MAX_STAMINA_BAR_LENGTH

func update_hp_bar(diff: float):
    health_bar.value = Player.player.general_stats.hp

func update_stamina_bar(diff: float):
    stamina_bar.value = Player.player.general_stats.stamina
