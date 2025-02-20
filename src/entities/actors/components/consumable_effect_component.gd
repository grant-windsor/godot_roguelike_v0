class_name ConsumableEffectComponent
extends Node

@onready var item: Item = get_parent() as Item

func _ready():
    item.effect_component = self