class_name HealingConsumableComponent
extends ConsumableComponent

var amount: int

func _init(item: Item, definition: HealingConsumableComponentDefinition) -> void:
    super(item)
    amount = definition.healing_amount


func activate(action: ItemAction) -> bool:
    var consumer: Actor = action.actor
    var amount_recovered: int = consumer.heal(amount)
    if amount_recovered > 0:
        MessageLog.send_message("You consume the %s, and recover %d HP!" % [parent.entity_name, amount_recovered], GameColors.HEALTH_RECOVERED)
        consume(consumer)
        return true
    MessageLog.send_message("Your health is already full.", GameColors.IMPOSSIBLE)
    return false