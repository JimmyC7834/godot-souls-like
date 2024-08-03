extends AnimationPlayer

@export var out_name: StringName = "out"
@export var folder_path: StringName = "res://"

var node_path = "Root Scene/RootNode/Skeleton3D:"
var h = 2

func _ready():
    var lib = AnimationLibrary.new()
    var dir = DirAccess.open(folder_path)
    for fn in dir.get_files():
        if fn.ends_with(".FBX"):
            var l = ResourceLoader.load(folder_path + "/" + fn)
            if l is AnimationLibrary:
                print("loaded ", folder_path + "/" + fn)
                add_lib(lib, l)

    #for a in libs:
        #add_lib(lib, a)
    
    add_animation_library("", lib)
    ResourceSaver.save(get_animation_library("").duplicate(true), folder_path + "/" + out_name + ".res")

func add_lib(lib, a):
    for an in a.get_animation_list():
        var ss: PackedStringArray = a.resource_path.split("/")

        var n = ss[len(ss) - 1].split("@")[1].split(".")[0]
        var anim: Animation = a.get_animation(an)
        for i in range(anim.get_track_count()):
            var _p = anim.track_get_path(i)
            var p = str(anim.track_get_path(i)).split(":")[1]
            anim.track_set_path(i, node_path + p)
        transfer_root(anim)
        lib.add_animation(n, anim.duplicate(true))

func transfer_root(anim: Animation):
    #var anim: Animation = get_animation(a_name)
    var root_pos_idx: int = -1
    var root_rot_idx: int = -1
    var hip_pos_idx: int = -1
    var hip_rot_idx: int = -1
    for i in range(anim.get_track_count()):
        if anim.track_get_path(i).get_subname(0) == "Bip001":
            if anim.track_get_type(i) == Animation.TYPE_POSITION_3D:
                root_pos_idx = i
            elif anim.track_get_type(i) == Animation.TYPE_ROTATION_3D:
                root_rot_idx = i
        elif anim.track_get_path(i).get_subname(0) == "Bip001 Pelvis":
            if anim.track_get_type(i) == Animation.TYPE_POSITION_3D:
                hip_pos_idx = i
            elif anim.track_get_type(i) == Animation.TYPE_ROTATION_3D:
                hip_rot_idx = i
    
    if hip_pos_idx == -1:
        hip_pos_idx = anim.add_track(Animation.TYPE_POSITION_3D)
        anim.track_set_path(hip_pos_idx, node_path + "Bip001 Pelvis")
    if hip_rot_idx == -1:
        hip_rot_idx = anim.add_track(Animation.TYPE_ROTATION_3D)
        anim.track_set_path(hip_rot_idx, node_path + "Bip001 Pelvis")
    
    #while anim.track_get_key_count(hip_pos_idx) > 0:
        #anim.track_remove_key(hip_pos_idx, 0)
    #
    #while anim.track_get_key_count(hip_rot_idx) > 0:
        #anim.track_remove_key(hip_rot_idx, 0)
    
    for i in range(anim.track_get_key_count(root_pos_idx)):
        var r_value = anim.track_get_key_value(root_pos_idx, i)
        var r_time = anim.track_get_key_time(root_pos_idx, i)
        anim.track_insert_key(hip_pos_idx, r_time, Vector3(0, 0, r_value.y - h))
        anim.track_set_key_value(root_pos_idx, i, Vector3(r_value.x, h, r_value.z))

    for i in range(anim.track_get_key_count(root_rot_idx)):
        var r_value = anim.track_get_key_value(root_rot_idx, i)
        var r_time = anim.track_get_key_time(root_rot_idx, i)
        if anim.track_find_key(hip_rot_idx, r_time) == -1:
            anim.track_insert_key(hip_rot_idx, r_time, Quaternion(-0.5, -0.5, -0.5, 0.5))
            print("notfound")
            
        anim.track_insert_key(hip_rot_idx, r_time, 
            r_value * anim.track_get_key_value(hip_rot_idx, anim.track_find_key(hip_rot_idx, r_time)))
        anim.track_set_key_value(root_rot_idx, i, Quaternion.IDENTITY)

    #anim.remove_track(root_rot_idx)
