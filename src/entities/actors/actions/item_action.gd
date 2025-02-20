class_name ItemAction
extends Action


var item: Item
var target_position: Vector2i


func _init(actor: Actor, item: Item, target_location = null) -> void:
    super._init(actor)
    self.item = item
    if not target_location is Vector2i:
        target_location = actor.grid_position
    self.target_position = target_location


func get_target_actor() -> Actor:
    return get_map_data().get_actor_at_location(target_position)


func perform() -> bool:
    if item == null:
        return false
    return item.consumable_component.activate(self)