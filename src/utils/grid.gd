class_name Grid 
extends Object

const tile_size = Vector2i(24, 36)

static func grid_to_world(grid_pos: Vector2i) -> Vector2i:
	return grid_pos * tile_size
	
static func world_to_grid(world_pos: Vector2i) -> Vector2i:
	return world_pos / tile_size
