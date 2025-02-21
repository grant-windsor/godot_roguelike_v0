class_name Item
extends Entity

var _item_definition: ItemDefinition

const item_types = {
    "stimpack": "res://resources/items/consumables/stimpack.tres"
}

func _init(map: MapData, start_position: Vector2i, key: String):
    centered = false
    grid_position = start_position
    self.map_data = map
    setup(key)

func setup(key: String) -> void:
    var definition: ItemDefinition = load(item_types[key])
    _item_definition = definition
    entity_name = definition.name
    texture = definition.texture
    modulate = definition.color

