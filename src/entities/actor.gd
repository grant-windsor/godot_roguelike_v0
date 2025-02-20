class_name Actor
extends Entity

var hp_component: HpComponent

func _init(map: MapData, start_position: Vector2i) -> void:
    centered = false
    grid_position = start_position
    self.map_data = map

func move(move_offset: Vector2i) -> void:
    map_data.unregister_blocking_actor(self)
    grid_position += move_offset
    map_data.register_blocking_actor(self)


func distance(other_position: Vector2i) -> int:
    var relative: Vector2i = other_position - grid_position
    return maxi(abs(relative.x), abs(relative.y))


func is_alive() -> bool:
    return hp_component.is_alive()