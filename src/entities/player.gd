class_name Player
extends Actor

# var _player_definition
var size: int
var encumbrance: int

var ac: int
var ev: int
var armor_coverage: int
var inventory_component: InventoryComponent
var level_component: LevelComponent


#TODO add quickness, speed, strength, etc

func _init(map: MapData, start_position: Vector2i) -> void:
    super(map, start_position)
    entity_name = "You"
    size = 100
    encumbrance = 0
    ac = 0
    ev = 0
    armor_coverage = 0
    
    var definition: PlayerDefinition = load("res://resources/player.tres")
    texture = definition.texture
    modulate = definition.color
    
    hp_component = HpComponent.new(self, 100)
    inventory_component = InventoryComponent.new(self, 26)
    level_component = LevelComponent.new(self, 150, 150)
    melee_attack_component = MeleeAttackComponent.new(self)



