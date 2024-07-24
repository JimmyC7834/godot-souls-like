extends CanvasItem

const KENNEY_PIXEL = preload("res://Kenney Pixel.ttf")
@onready var player: PlayerEntity = $"../korone_root"

func _physics_process(delta):
    queue_redraw()

func _draw():
    var e = Global.debug_entity if Global.debug_entity else player
    draw_input_action_buf(e, 0, 0)
    draw_tae(e, 64, 0)
    
func draw_input_action_buf(e: GameEntity, x: int = 0, y: int = 0):
    draw_string(KENNEY_PIXEL, Vector2(x, y), e.name + ": " + e.sm.cur.name, 0, -1, 16)
    
    var y_off: float = 32
    var i: PlayerInputController = e.get_component(PlayerInputController.type())
    if i == null: return
    for f in i.queue:
        var str: String = PlayerInputController.ACTION.keys()[f[1]]
        var color: Color = Color.CORAL
        draw_string(KENNEY_PIXEL, Vector2(x, y + y_off), str, 0, -1, 16, color)
        y_off += 16
    
func draw_tae(entity: GameEntity, x: int = 0, y: int = 0):
    var y_off: float = 32
    for e in TimeActEvents.TAE:
        var idx: int = TimeActEvents.TAE[e]
        var str: String = "[x] " if entity.tae.event_active[idx] else "[ ] "
        var color: Color = Color.AQUAMARINE if entity.tae.event_active[idx] else Color.GRAY
        str += e
        str += str(entity.tae.event_args[idx])
        draw_string(KENNEY_PIXEL, Vector2(x, y + y_off), str, 0, -1, 16, color)
        y_off += 16
