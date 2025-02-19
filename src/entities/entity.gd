class_name Entity
extends Sprite2D

var entity_name: String
var map_data: MapData
var grid_position: Vector2i:
    set(value):
        grid_position = value
        position = Grid.grid_to_world(grid_position)


func get_entity_name() -> String:
    return entity_name
