class_name BumpAction
extends ActionWithDirection


func perform() -> bool:
    if get_target_actor():
        return MeleeAction.new(actor, offset.x, offset.y).perform()
    else:
        return MovementAction.new(actor, offset.x, offset.y).perform()