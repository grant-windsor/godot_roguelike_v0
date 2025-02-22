class_name ConsumableComponent
extends Node

@onready var parent: Item

func _init(entity: Item):
    parent = entity

func get_map_data() -> MapData:
    return parent.map_data

func consume(consumer: Player) -> void:
    var inventory: InventoryComponent = consumer.inventory_component
    inventory.items.erase(parent)
    parent.queue_free()

func get_targeting_radius() -> int:
    return -1

func activate(_action: ItemAction) -> bool:
    return false