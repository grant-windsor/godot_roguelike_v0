class_name Item
extends Entity

var _item_definition: ItemDefinition
var consumable_component: ConsumableComponent
# var equippable_component: EquippableComponent


const item_types = {
    "stimpack": "res://resources/items/consumables/stimpack.tres",
    "corpse": "res://resources/items/consumables/corpse.tres",
}

func _init(map: MapData, start_position: Vector2i, key: String):
    centered = false
    grid_position = start_position
    self.map_data = map
    z_index = Enums.ZIndex.ITEM
    setup(key)

func setup(key: String) -> void:
    var definition: ItemDefinition = load(item_types[key])
    _item_definition = definition
    entity_name = definition.name
    texture = definition.texture
    modulate = definition.color

    if definition.consumable_component_definition:
        set_consumable_effect(definition.consumable_component_definition)


func set_consumable_effect(effect_definition: ConsumableComponentDefinition):
    match effect_definition.type:
        "healing":
            consumable_component = HealingConsumableComponent.new(self, effect_definition)
