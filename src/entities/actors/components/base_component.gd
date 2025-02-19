class_name Component
extends Node

@onready var entity: Actor = get_parent() as Actor


func get_map_data() -> MapData:
    return entity.map_data