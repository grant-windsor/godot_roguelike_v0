class_name Component
extends Node

@onready var parent: Entity

func _init(entity: Entity):
    parent = entity

func get_map_data() -> MapData:
    return parent.map_data