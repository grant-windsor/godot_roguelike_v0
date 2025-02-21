class_name Map
extends Node2D

signal dungeon_floor_changed(floor)

var map_data: MapData

@export var fov_radius: int = 8

@onready var tiles: Node2D = $Tiles
@onready var items: Node2D = $Items
@onready var actors: Node2D = $Actors
@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator
@onready var field_of_view: FieldOfView = $FieldOfView

func _ready():
	SignalBus.player_descended.connect(next_floor)

#TODO: enemies not getting added to scene tree
func generate(player: Actor, current_floor: int = 1) -> void:
	map_data = dungeon_generator.generate_dungeon(player, current_floor)
	if not map_data.entity_placed.is_connected(actors.add_child):
		map_data.entity_placed.connect(actors.add_child)
	_place_tiles()
	_place_items()
	_place_actors()
	dungeon_floor_changed.emit(current_floor)

func _place_tiles() -> void:
	for tile in map_data.tiles:
		tiles.add_child(tile)

func _place_items() -> void:
	for item in map_data.items:
		items.add_child(item)

func _place_actors() -> void:
	for actor in map_data.actors:
		actors.add_child(actor)

func update_fov(player_position: Vector2i) -> void:
	field_of_view.update_fov(map_data, player_position, fov_radius)

	for actor in map_data.actors:
		actor.visible = map_data.get_tile(actor.grid_position).is_in_view
	for item in map_data.items:
		item.visible = map_data.get_tile(item.grid_position).is_in_view

func next_floor() -> void:
	var player: Actor = map_data.player
	actors.remove_child(player)
	for entity in actors.get_children():
		entity.queue_free()
	for tile in tiles.get_children():
		tile.queue_free()
	generate(player, map_data.current_floor + 1)
	player.get_node("Camera2D").make_current()
	field_of_view.reset_fov()
	update_fov(player.grid_position)


func load_game(player: Actor) -> bool:
	map_data = MapData.new(0, 0, player)
	map_data.entity_placed.connect(actors.add_child)
	if not map_data.load_game():
		return false
	_place_tiles()
	_place_actors()
	dungeon_floor_changed.emit(map_data.current_floor)
	return true
