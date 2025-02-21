class_name Game
extends Node2D


signal player_created(player)

@onready var player: Actor
@onready var input_handler: InputHandler = $InputHandler
@onready var map: Map = $Map
@onready var camera: Camera2D = $Camera2D

const level_up_menu_scene: PackedScene = preload("res://src/gui/levelup_menu/level_up_menu.tscn")


func new_game() -> void:
	player = Player.new(null, Vector2i.ZERO)
	player.level_component.level_up_required.connect(_on_player_level_up_requested)
	player_created.emit(player)
	remove_child(camera)
	player.add_child(camera) 
	map.generate(player)
	map.update_fov(player.grid_position)
	MessageLog.send_message.bind(
		"Hello and welcome, adventurer, to yet another dungeon!",
		GameColors.WELCOME_TEXT
	).call_deferred()
	camera.make_current.call_deferred()

func load_game() -> bool:
	player = Player.new(null, Vector2i.ZERO)
	remove_child(camera)
	player.add_child(camera)
	if not map.load_game(player):
		return false
	player.level_component.level_up_required.connect(_on_player_level_up_requested)
	player_created.emit(player)
	map.update_fov(player.grid_position)
	MessageLog.send_message.bind(
		"Welcome back, adventurer!",
		GameColors.WELCOME_TEXT
	).call_deferred()
	camera.make_current.call_deferred()
	return true
	
	
func _physics_process(_delta: float) -> void:
	var action: Action = await input_handler.get_action(player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		if action.perform():
			_handle_enemy_turns()
		map.update_fov(player.grid_position)

func _handle_enemy_turns() -> void:
	for actor in get_map_data().actors:
		if actor.is_alive() and actor != player:
			actor.ai_component.perform()

func get_map_data() -> MapData:
	return map.map_data

func _on_player_level_up_requested() -> void:
	var level_up_menu: LevelUpMenu = level_up_menu_scene.instantiate()
	add_child(level_up_menu)
	level_up_menu.setup(player)
	# TODO: instead of having a DUMMY state, just do this
	set_physics_process(false)
	await level_up_menu.level_up_completed
	set_physics_process.bind(true).call_deferred()