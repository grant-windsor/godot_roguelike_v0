class_name ActorDefinition
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Actor"
@export var texture: AtlasTexture = AtlasTexture.new()
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var is_blocking_movement: bool = true

@export_category("Components")
# @export var ai_type: Actor.AIType
@export var inventory_capacity: int = 26
@export var level_info: LevelComponentDefinition

@export_category("Anatomy")
@export var anatomy: Array[BodyPart] = []