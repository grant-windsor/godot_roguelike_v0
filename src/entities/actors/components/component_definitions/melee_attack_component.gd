class_name MeleeAttackComponent
extends Component

func _init(parent: Entity):
    super(parent)

func attack(target: Actor) -> void:
    var damage: int = 3
    var attack_color: Color
    if parent == get_map_data().player:
        attack_color = GameColors.PLAYER_ATTACK        
    else:
        attack_color = GameColors.ENEMY_ATTACK
    
    var attack_description: String = "%s attacks %s" % [parent.get_entity_name(), target.get_entity_name()]
    if damage > 0:
        attack_description += " for %d hit points." % damage
        MessageLog.send_message(attack_description, attack_color)
        target.hp_component.take_damage(damage)
    else:
        attack_description += " but does no damage."
        MessageLog.send_message(attack_description, attack_color)