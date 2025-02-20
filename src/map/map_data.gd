class_name MapData
extends RefCounted

signal entity_placed(entity)

const entity_pathfinding_weight = 10.0

var width: int
var height: int
var tiles: Array[Tile]
var items: Array[Item]
var actors: Array[Actor]
var player: Actor
var down_stairs_location: Vector2i
var current_floor: int = 0

var pathfinder: AStarGrid2D


func _init(map_width: int, map_height: int, player: Actor) -> void:
    width = map_width
    height = map_height
    self.player = player
    items = []
    actors = []
    _setup_tiles()

func _setup_tiles() -> void:
    tiles = []
    for y in height:
        for x in width:
            var tile_position := Vector2i(x,y)
            var tile := Tile.new(tile_position, "wall")
            tiles.append(tile)

func get_tile(grid_position: Vector2i) -> Tile:
    var tile_index: int = grid_to_index(grid_position)
    if tile_index == -1:
        return null
    return tiles[tile_index]

func get_tile_xy(x:int, y:int) -> Tile:
    var grid_position := Vector2i(x, y)
    return get_tile(grid_position)

func grid_to_index(grid_position: Vector2i) -> int:
    if not is_in_bounds(grid_position):
        return -1
    return grid_position.y * width + grid_position.x

func is_in_bounds(coordinate: Vector2i) -> bool:
    return (
        0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
    )

func get_blocking_actor_at_location(grid_position: Vector2i) -> Actor:
    for actor in actors:
        if actor.grid_position == grid_position:
            return actor
    return null

func register_blocking_actor(entity: Actor) -> void:
    pathfinder.set_point_weight_scale(entity.grid_position, entity_pathfinding_weight)

func unregister_blocking_actor(entity: Actor) -> void:
    pathfinder.set_point_weight_scale(entity.grid_position, 0)

func setup_pathfinding() -> void:
    pathfinder = AStarGrid2D.new()
    pathfinder.region = Rect2i(0, 0, width, height)
    pathfinder.update()
    for y in height:
        for x in width:
            var grid_position := Vector2i(x, y)
            var tile: Tile = get_tile(grid_position)
            pathfinder.set_point_solid(grid_position, not tile.is_walkable())
    for actor in actors:
        register_blocking_actor(actor)


func get_actors() -> Array[Actor]:
    return actors


func get_actor_at_location(location: Vector2i) -> Actor:
    for actor in get_actors():
        if actor.grid_position == location:
            return actor
    return null

func get_items() -> Array[Item]:
    var items: Array[Item] = []
    for item in items:
        if item.consumable_component != null:
            items.append(item)
    return items

func get_save_data() -> Dictionary:
    var save_data := {
        "width": width,
        "height": height,
        "player": player.get_save_data(),
        "current_floor": current_floor,
        "down_stairs_location": {"x": down_stairs_location.x, "y": down_stairs_location.y},
        "entities": [],
        "tiles": []
    }
    # for item in items:
        # save_data["items"].append(item.get_save_data())
    for actor in actors:
        if actor == player:
            continue
        save_data["actors"].append(actor.get_save_data())
    for tile in tiles:
        save_data["tiles"].append(tile.get_save_data())
    return save_data

func restore(save_data: Dictionary) -> void:
    width = save_data["width"]
    height = save_data["height"]
    down_stairs_location = Vector2i(save_data["down_stairs_location"]["x"], save_data["down_stairs_location"]["y"])
    current_floor = save_data["current_floor"]
    _setup_tiles()
    for i in tiles.size():
        tiles[i].restore(save_data["tiles"][i])
    setup_pathfinding()
    player.restore(save_data["player"])
    player.map_data = self
    actors = [player]
    for actor_data in save_data["actors"]:
        var new_actor := Actor.new(self, Vector2i.ZERO)
        new_actor.restore(actor_data)
        actors.append(new_actor)


func save() -> void:
    var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
    var save_data: Dictionary = get_save_data()
    var save_string: String = JSON.stringify(save_data)
    var save_hash: String = save_string.sha256_text()
    file.store_line(save_hash)
    file.store_line(save_string)


func load_game() -> bool:
    var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
    var retrieved_hash: String = file.get_line()
    var save_string: String = file.get_line()
    var calculated_hash: String = save_string.sha256_text()
    var valid_hash: bool = retrieved_hash == calculated_hash
    if not valid_hash:
        return false
    var save_data: Dictionary = JSON.parse_string(save_string)
    restore(save_data)
    return true