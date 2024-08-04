extends Resource

class_name AttributePreset

@export var DUR: int
@export var STA: int
@export var STR: int
@export var DEX: int
@export var MEN: int
@export var WIL: int

func get_attributes():
    var a: Attributes = Attributes.new()
    a.values = {
        Attributes.TYPE.DUR: self.DUR,
        Attributes.TYPE.STA: self.STA,
        Attributes.TYPE.STR: self.STR,
        Attributes.TYPE.DEX: self.DEX,
        Attributes.TYPE.MEN: self.MEN,
        Attributes.TYPE.WIL: self.WIL,
    }
    return a
