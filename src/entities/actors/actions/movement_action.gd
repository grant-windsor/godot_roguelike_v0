class_name MovementAction
extends ActionWithDirection


func perform() -> bool:
	var destination: Vector2i = get_destination()
	var map_data: MapData = get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	if not destination_tile or not destination_tile.is_walkable() or get_blocking_actor_at_destination():
		if actor == get_map_data().player:
			MessageLog.send_message("That way is blocked.", GameColors.IMPOSSIBLE)
		return false
	actor.move(offset)
	return true