class_name Attributes

enum TYPE {
    DUR = 1,
    STA = 2,
    STR = 3,
    DEX = 4,
    MEN = 5,
    WIL = 6,
}

var values = {
    TYPE.DUR: 0,
    TYPE.STA: 0,
    TYPE.STR: 0,
    TYPE.DEX: 0,
    TYPE.MEN: 0,
    TYPE.WIL: 0,
}

func get_attribute(s: TYPE):
    return values[s]
