class_name HpComponent
extends Component


signal hp_changed(hp, max_hp)

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		hp_changed.emit(hp, max_hp)
		if hp <= 0:
			var trigger_side_effects := true
			die(trigger_side_effects)


func _init(entity: Entity, starting_hp: int) -> void:
	super(entity)
	max_hp = starting_hp
	hp = max_hp


func heal(amount: int) -> int:
	if hp == max_hp:
		return 0
	
	var new_hp_value: int = hp + amount
	
	if new_hp_value > max_hp:
		new_hp_value = max_hp
		
	var amount_recovered: int = new_hp_value - hp
	hp = new_hp_value
	return amount_recovered


func take_damage(amount: int) -> void:
	hp -= amount


func increase_max_hp(amount: int) -> void:
	max_hp += amount
	hp += amount

# TODO: convert to corpse item
func die(trigger_side_effects := true) -> void:
	var death_message: String
	var death_message_color: Color

	if get_map_data().player == parent:
		death_message = "rip"
		death_message_color = GameColors.PLAYER_DIE
		SignalBus.player_died.emit()
	else:
		death_message = "The %s dies!" % parent.get_entity_name()
		death_message_color = GameColors.ENEMY_DIE

	if trigger_side_effects:
		MessageLog.send_message(death_message, death_message_color)


	parent.entity_name = "Remains of %s" % parent.entity_name
	# get_map_data().unregister_blocking_entity(parent)

	#TODO: Add this logic back in somewhere
	# entity.texture = death_texture
	# entity.modulate = death_color
	# entity.ai_component.queue_free()
	# entity.ai_component = null
	# get_map_data().player.level_component.add_xp(entity.level_component.xp_given)


func is_alive() -> bool:
	return hp > 0

func get_save_data() -> Dictionary:
	return {
		"max_hp": max_hp,
		"hp": hp,
	}

func restore(save_data: Dictionary) -> void:
	max_hp = save_data["max_hp"]
	hp = save_data["hp"]