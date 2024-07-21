extends CanvasItem

const KENNEY_PIXEL = preload("res://Kenney Pixel.ttf")
@onready var player: PlayerController = $"../korone_root"

func _physics_process(delta):
    queue_redraw()

func _draw():
    draw_input_action_buf(0, 0)
    draw_tae(64, 0)
    
func draw_input_action_buf(x: int = 0, y: int = 0):
    var y_off: float = 32
    for f in player.input_action_buffer.queue:
        var str: String = InputActionBuffer.ACTION.keys()[f[1]]
        var color: Color = Color.CORAL
        draw_string(KENNEY_PIXEL, Vector2(x, y + y_off), str, 0, -1, 16, color)
        y_off += 16
    
func draw_tae(x: int = 0, y: int = 0):
    var y_off: float = 32
    for e in TimeActEvents.TAE:
        var idx: int = TimeActEvents.TAE[e]
        var str: String = "[x] " if player.tae.event_active[idx] else "[ ] "
        var color: Color = Color.AQUAMARINE if player.tae.event_active[idx] else Color.GRAY
        str += e
        str += str(player.tae.event_args[idx])
        draw_string(KENNEY_PIXEL, Vector2(x, y + y_off), str, 0, -1, 16, color)
        y_off += 16
