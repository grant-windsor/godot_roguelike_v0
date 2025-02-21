class_name MeleeAction
extends ActionWithDirection

func perform() -> bool:
    var target: Actor = get_target_actor()
    if not target:
        if actor == get_map_data().player:
            MessageLog.send_message("Nothing to attack.", GameColors.IMPOSSIBLE)
            return false
    actor.attack(target)
    return true