class_name Actor
extends Entity

var hp_component: HpComponent
var melee_attack_component: MeleeAttackComponent

func _init(map: MapData, start_position: Vector2i) -> void:
    centered = false
    grid_position = start_position
    self.map_data = map
    z_index = Enums.ZIndex.ACTOR


func move(move_offset: Vector2i) -> void:
    map_data.unregister_blocking_entity(self)
    grid_position += move_offset
    map_data.register_blocking_entity(self)


func distance(other_position: Vector2i) -> int:
    var relative: Vector2i = other_position - grid_position
    return maxi(abs(relative.x), abs(relative.y))


func is_alive() -> bool:
    return hp_component.is_alive()

func heal(amount: int) -> int:
    return hp_component.heal(amount)

func attack(target: Actor) -> void:
    melee_attack_component.attack(target)


func convert_to_corpse() -> void:
    var corpse = Item.new(map_data, grid_position, "corpse")
    corpse.entity_name = "Remains of %s" % entity_name
    map_data.items.append(corpse)
    map_data.entity_placed.emit(corpse)
    map_data.actors.erase(self)
    self.queue_free()