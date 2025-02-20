class_name Action
extends RefCounted

var actor: Actor


func _init(entity: Actor) -> void:
    self.actor = entity


func perform() -> bool:
    return false


func get_map_data() -> MapData:
    return actor.map_data
