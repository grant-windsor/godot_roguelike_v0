class_name Actor
extends Entity


enum AIType {NONE, HOSTILE}

var _actor_definition: ActorDefinition
var blocks_movement: bool
var fighter_component: FighterComponent
var ai_component: BaseAIComponent
var inventory_component: InventoryComponent
var level_component: LevelComponent

var parts: Array[BodyPart] = []

#TODO: ENUM

const actor_types = {
    "player": "res://resources/actors/player_types/player.tres",
    "rat": "res://resources/actors/rat.tres",
    "zombie": "res://resources/actors/zombie.tres"
}
var key: String

func _init(map: MapData, start_position: Vector2i, key: String = "") -> void:
    centered = false
    grid_position = start_position
    self.map_data = map
    if key != "":
        setup(key)


func setup(key: String) -> void:
    self.key = key
    var definition: ActorDefinition = load(actor_types[key])
    _actor_definition = definition
    blocks_movement = _actor_definition.is_blocking_movement
    entity_name = definition.name
    texture = definition.texture
    modulate = definition.color

    # match _actor_definition.ai_type:
    #     AIType.HOSTILE:
    #         ai_component = HostileEnemyAIComponent.new()
    #         add_child(ai_component)

    # if _actor_definition.fighter_definition:
    #     fighter_component = FighterComponent.new(_actor_definition.fighter_definition)
    #     add_child(fighter_component)

    if _actor_definition.inventory_capacity > 0:
        inventory_component = InventoryComponent.new(_actor_definition.inventory_capacity)
        add_child(inventory_component)
    
    if _actor_definition.level_info:
        level_component = LevelComponent.new(_actor_definition.level_info)
        add_child(level_component)
        


func move(move_offset: Vector2i) -> void:
    map_data.unregister_blocking_actor(self)
    grid_position += move_offset
    map_data.register_blocking_actor(self)


func is_blocking_movement() -> bool:
    return blocks_movement




func is_alive() -> bool:
    return ai_component != null


func distance(other_position: Vector2i) -> int:
    var relative: Vector2i = other_position - grid_position
    return maxi(abs(relative.x), abs(relative.y))


func get_save_data() -> Dictionary:
    var save_data: Dictionary = {
        "x": grid_position.x,
        "y": grid_position.y,
    }
    if fighter_component:
        save_data["fighter_component"] = fighter_component.get_save_data()
    if ai_component:
        save_data["ai_component"] = ai_component.get_save_data()
    if inventory_component:
        save_data["inventory_component"] = inventory_component.get_save_data()
    if level_component:
        save_data["level_component"] = level_component.get_save_data()
    return save_data


func restore(save_data: Dictionary) -> void:
    grid_position = Vector2i(save_data["x"], save_data["y"])
    if fighter_component and save_data.has("fighter_component"):
        fighter_component.restore(save_data["fighter_component"])
    if ai_component and save_data.has("ai_component"):
        var ai_data: Dictionary = save_data["ai_component"]
        if ai_data["type"] == "ConfusedEnemyAI":
            var confused_enemy_ai := ConfusedEnemyAIComponent.new(ai_data["turns_remaining"])
            add_child(confused_enemy_ai)
    if inventory_component and save_data.has("inventory_component"):
        inventory_component.restore(save_data["inventory_component"])
    if level_component and save_data.has("level_component"):
        inventory_component.restore(save_data["level_component"])
