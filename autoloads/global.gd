extends Node

enum COLLISION_LAYER {
    ENTITY_COLLIDER = 1,
    HITBOX = 5,
    HURTBOX = 6,
    CAMERA = 32
}
const HITBOX_LAYER: int = 5
const HURTBOX_LAYER: int = 6

var debug_entity: GameEntity
