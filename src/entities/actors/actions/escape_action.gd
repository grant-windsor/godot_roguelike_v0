class_name EscapeAction
extends Action

func perform() -> bool:
	actor.map_data.save()
	SignalBus.escape_requested.emit()
	return false