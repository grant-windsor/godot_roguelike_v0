class_name ConsumableItem
extends Item

var effect: ConsumableEffectComponent

func _init(map: MapData, start_position: Vector2i, key: String):
    super(map, start_position, key)

func set_effect_type():
    var effect_definition: ConsumableComponentDefinition = _item_definition.effect
    match effect_definition.type:
        "healing":
            effect = HealingConsumableComponent.new(self, effect_definition.healing_amount)

func consume(consumer: Player) -> void:
    var inventory: InventoryComponent = consumer.inventory_component
    
    inventory.items.erase(self)
    self.queue_free()

func get_targeting_radius() -> int:
    return -1

func activate(_action: ItemAction) -> bool:
    return effect.activate()