class_name Enemy
extends Actor

enum AIType {NONE, HOSTILE}

var _enemy_definition
var ai_component: BaseAIComponent
var xp_given: int



const enemy_types = {
    "rat": "res://resources/enemies/rat.tres",
    "wretch": "res://resources/enemies/wretch.tres"
}


func _init(map: MapData, start_position: Vector2i, key: String):
    super(map, start_position)
    setup(key)


func setup(key: String) -> void:
    var definition: EnemyDefinition = load(enemy_types[key])
    _enemy_definition = definition
    entity_name = definition.name
    texture = definition.texture
    modulate = definition.color

    hp_component = HpComponent.new(self, definition.hp)
    melee_attack_component = MeleeAttackComponent.new(self)

    match _enemy_definition.ai_type:
        AIType.HOSTILE:
            ai_component = HostileEnemyAIComponent.new(self)
            add_child(ai_component)
