extends AnimationPlayer

@export var hip_base_h: float = 0.975
@export var arr: Array

func _ready():
    for a in arr:
        if a is Animation:
            anim_root_convert(a)
            var lib = AnimationLibrary.new()
            lib.add_animation(a.resource_name, a.duplicate(true))
            add_animation_library("", lib)
        elif a is AnimationLibrary:
            for a_name in a.get_animation_list():
                var anim = a.get_animation(a_name)
                anim_root_convert(anim)
            add_animation_library("", a)
    
    ResourceSaver.save(get_animation_library("").duplicate(true), "res://out/out.res")

func anim_root_convert(anim: Animation):
    print("processing " + anim.resource_path)
    var arr = []
    #var root_path: String = anim.track_get_path(0)
    #var hips_idx: int = anim.add_track(Animation.TYPE_POSITION_3D)
    #anim.track_set_path(hips_idx, root_path.replace("Root", "Hips"))
    
    for i in anim.track_get_key_count(1):
        var value: Quaternion = anim.track_get_key_value(1, i)   
        anim.track_set_key_value(3, i, anim.track_get_key_value(3, i) * value)
    anim.remove_track(1)
    print("finished processing " + anim.resource_path)
