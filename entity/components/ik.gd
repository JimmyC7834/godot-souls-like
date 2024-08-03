extends EntityComponent

class_name IK

@onready var skeleton: Skeleton3D = $"../../Armature_002/Skeleton3D"
@onready var l_ray_cast: RayCast3D = $"../../Armature_002/Skeleton3D/IK_L/RayCast3D"
@onready var r_ray_cast: RayCast3D = $"../../Armature_002/Skeleton3D/IK_R/RayCast3D2"
@onready var ik_l: BoneAttachment3D = $"../../Armature_002/Skeleton3D/IK_L"
@onready var ik_r: BoneAttachment3D = $"../../Armature_002/Skeleton3D/IK_R"

func _physics_process(delta):
    pass
    #update_ik(34, l_ray_cast, ik_l)
    #update_ik(39, r_ray_cast, ik_r)

func update_ik(bone_idx: int, ray: RayCast3D, ik: BoneAttachment3D):
    if !ray.collide_with_bodies: return
    var target: Vector3 = ray.get_collision_point()
    if target.distance_to(ik.global_position) > 0.25:
       ik.global_position.y = target.y 
