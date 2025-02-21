class_name ConsumableEffectComponent
extends Node

@onready var parent: ConsumableItem

func _init(entity: ConsumableItem):
    parent = entity

func get_map_data() -> MapData:
    return parent.map_data