class_name Damage

enum TYPE {
    PHY,
    WAVE,
    FIRE,
    ICE,
    LIGHTING,
    MAGIC,
}

enum ATK_TYPE {
    SLASH,
    THRUST,
    STRIKE,
}

enum SCALING {
    S,
    A,
    B,
    C,
    D,
}

enum IMPACT {
    LOW,
    MEDIUM,
    HIGH,
    VERY_HIGH,
}

var values = {}
var source: Object

func _init(source: Object = null):
    self.values = {}
    self.source = source
