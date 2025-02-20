class_name ConsumableItem
extends Item

var effect: ConsumableEffectComponent

func consume(consumer: Actor) -> void:
    var inventory: InventoryComponent = consumer.inventory_component
    inventory.items.erase(self)
    self.queue_free()

func get_targeting_radius() -> int:
    return -1

func activate(_action: ItemAction) -> bool:
    return false