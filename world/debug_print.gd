extends CanvasItem

const KENNEY_PIXEL = preload("res://assets/Kenney Pixel.ttf")
@onready var player: PlayerEntity = $"../player"

func _physics_process(_delta):
    queue_redraw()

func _draw():
    var e = Global.debug_entity if Global.debug_entity else player
    draw_input_action_buf(e, 0, 0)
    draw_tae(e, 64, 0)
    
func draw_input_action_buf(e: GameEntity, x: int = 0, y: int = 0):
    draw_string(KENNEY_PIXEL, Vector2(x, y), e.name + ": " + str(e.sm.cur.type), HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
    
    var y_off: float = 32
    var i: PlayerInputController = e.get_component(PlayerInputController.type())
    if i == null: return
    for f in i.queue:
        var _str: String = PlayerInputController.ACTION.keys()[f[1]]
        var color: Color = Color.CORAL
        draw_string(KENNEY_PIXEL, Vector2(x, y + y_off), _str, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, color)
        y_off += 16
    
func draw_tae(entity: GameEntity, x: int = 0, y: int = 0):
    var y_off: float = 32
    for e in TimeActEvents.TAE:
        var idx: int = TimeActEvents.TAE[e]
        var _str: String = "[x] " if entity.tae.event_active[idx] else "[ ] "
        var color: Color = Color.AQUAMARINE if entity.tae.event_active[idx] else Color.GRAY
        _str += e
        _str += str(entity.tae.event_args[idx])
        draw_string(KENNEY_PIXEL, Vector2(x, y + y_off), _str, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, color)
        y_off += 16
