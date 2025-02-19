class_name ActionWithDirection
extends Action

var offset: Vector2i


func _init(actor: Actor, dx: int, dy: int) -> void:
    super._init(actor)
    offset = Vector2i(dx, dy)


func get_destination() -> Vector2i:
    return actor.grid_position + offset


func get_blocking_actor_at_destination() -> Actor:
    return get_map_data().get_blocking_actor_at_location(get_destination())


func get_target_actor() -> Actor:
    return get_map_data().get_actor_at_location(get_destination())