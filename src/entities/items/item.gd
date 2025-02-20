class_name Item
extends Entity

var _item_definition: ItemDefinition

func _init(map: MapData, start_position: Vector2i):
    centered = false
    grid_position = start_position
    self.map_data = map

func setup(definition: ItemDefinition) -> void:
    _item_definition = definition
    entity_name = definition.name
    texture = definition.texture
    modulate = definition.color

